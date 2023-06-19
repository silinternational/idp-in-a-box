/*
Copyright © 2023 SIL International
*/

package multiregion

import (
	"fmt"
	"log"

	"github.com/silinternational/tfc-ops/v3/lib"
	"github.com/spf13/cobra"
)

const (
	Core                   = "000-core"
	Cluster                = "010-cluster"
	ClusterSecondary       = "010-cluster-secondary"
	Database               = "020-database"
	DatabaseSecondary      = "020-database-secondary"
	Ecr                    = "022-ecr"
	Phpmyadmin             = "030-phpmyadmin"
	PhpmyadminSecondary    = "030-phpmyadmin-secondary"
	EmailService           = "031-email-service"
	EmailServiceSecondary  = "031-email-service-secondary"
	DbBackup               = "032-db-backup"
	IdBroker               = "040-id-broker"
	IdBrokerSecondary      = "040-id-broker-secondary"
	IdBrokerSearch         = "041-id-broker-search"
	PwManager              = "050-pw-manager"
	PwManagerSecondary     = "050-pw-manager-secondary"
	Simplesamlphp          = "060-simplesamlphp"
	SimplesamlphpSecondary = "060-simplesamlphp-secondary"
	IdSync                 = "070-id-sync"
	IdSyncSecondary        = "070-id-sync-secondary"
)

const awsFailoverActive = "aws_failover_active"

type Failover struct {
	testMode bool
	tfcOrg   string

	workspaces map[string]Workspace
}

type Workspace struct {
	lib.Workspace
	variables []lib.Var
}

func InitFailoverCmd(parentCmd *cobra.Command) {
	failoverCmd := &cobra.Command{
		Use:   "failover",
		Short: "Failover to secondary region",
		Long:  `Make Terraform, AWS, and Cloudflare changes for failover to secondary region`,
		Run: func(cmd *cobra.Command, args []string) {
			runFailover()
		},
	}

	parentCmd.AddCommand(failoverCmd)
}

func runFailover() {
	pFlags := getPersistentFlags()

	lib.SetToken(pFlags.token)

	fmt.Println(`Please confirm activation of failover mode. Type "yes" to continue.`)
	var prompt string
	_, _ = fmt.Scanln(&prompt)
	if prompt != "yes" {
		return
	}

	f := newFailover(pFlags)

	f.setFailoverActiveVariable("true")
}

func newFailover(pFlags PersistentFlags) *Failover {
	allWorkspaces := map[string]func(flags PersistentFlags) string{
		Core:                   coreWorkspace,
		ClusterSecondary:       clusterSecondaryWorkspace,
		DatabaseSecondary:      databaseSecondaryWorkspace,
		PhpmyadminSecondary:    pmaSecondaryWorkspace,
		EmailServiceSecondary:  emailSecondaryWorkspace,
		IdBrokerSecondary:      brokerSecondaryWorkspace,
		PwManagerSecondary:     pwSecondaryWorkspace,
		SimplesamlphpSecondary: sspSecondaryWorkspace,
		IdSyncSecondary:        syncSecondaryWorkspace,
	}

	f := Failover{
		testMode:   pFlags.readOnlyMode,
		tfcOrg:     pFlags.org,
		workspaces: map[string]Workspace{},
	}

	fmt.Println("Reading Terraform workspace information...")
	for wsKey, wsNameFunc := range allWorkspaces {
		workspaceName := wsNameFunc(pFlags)
		properties, err := lib.GetWorkspaceData(f.tfcOrg, workspaceName)
		if err != nil {
			log.Fatalf("failed to get workspace %q: %s", workspaceName, err)
		}

		variables, err := lib.GetVarsFromWorkspace(f.tfcOrg, workspaceName)
		if err != nil {
			log.Fatalf("failed to get workspace %q variables: %s", workspaceName, err)
		}

		f.workspaces[wsKey] = Workspace{
			Workspace: properties.Data,
			variables: variables,
		}
	}

	return &f
}

func (f *Failover) setFailoverActiveVariable(value string) {
	fmt.Printf("Setting %q variable to true.", awsFailoverActive)
	v := f.findVariable(Core, awsFailoverActive)

	if f.testMode {
		return
	}

	lib.UpdateVariable(f.tfcOrg, f.workspaces[Core].Attributes.Name, v.ID, lib.TFVar{
		Key:   awsFailoverActive,
		Value: value,
	})
}

func (f *Failover) findVariable(workspace, key string) lib.Var {
	for _, v := range f.workspaces[workspace].variables {
		if v.Key == key {
			return v
		}
	}
	return lib.Var{}
}
