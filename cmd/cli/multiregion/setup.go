/*
Copyright © 2023 SIL International
*/

package multiregion

import (
	"fmt"
	"log"

	"github.com/silinternational/tfc-ops/lib"
	"github.com/spf13/cobra"
)

func InitSetupCmd(parentCmd *cobra.Command) {
	setupCmd := &cobra.Command{
		Use:   "setup",
		Short: "Manage multiregion setup",
		Long:  `Perform initial setup of a multiregion IdP`,
		Run: func(cmd *cobra.Command, args []string) {
			runSetup()
		},
	}

	parentCmd.AddCommand(setupCmd)
}

func runSetup() {
	pFlags := getPersistentFlags()

	lib.SetToken(pFlags.token)

	clonePrimaryWorkspaces(pFlags)
	setMultiregionVariables(pFlags)
	deleteUnusedVariables(pFlags)
	setProviderCredentials(pFlags)
	setSensitiveVariables(pFlags)
}

// clonePrimaryWorkspaces creates new secondary workspaces by cloning the corresponding primary workspace
func clonePrimaryWorkspaces(pFlags PersistentFlags) {
	fmt.Println("\ncloning workspaces...")

	cloneWorkspace(pFlags, clusterWorkspace(pFlags))
	cloneWorkspace(pFlags, databaseWorkspace(pFlags))
	cloneWorkspace(pFlags, pmaWorkspace(pFlags))
	cloneWorkspace(pFlags, emailWorkspace(pFlags))
	cloneWorkspace(pFlags, brokerWorkspace(pFlags))
	cloneWorkspace(pFlags, pwWorkspace(pFlags))
	cloneWorkspace(pFlags, sspWorkspace(pFlags))
	cloneWorkspace(pFlags, syncWorkspace(pFlags))
}

// cloneWorkspace creates a new secondary workspace by cloning the corresponding primary workspac
func cloneWorkspace(pFlags PersistentFlags, workspace string) {
	newWorkspace := workspace + "-secondary"
	fmt.Printf("cloning %s to %s\n", workspace, newWorkspace)

	if !pFlags.readOnlyMode {
		config := lib.CloneConfig{
			Organization:    pFlags.org,
			SourceWorkspace: workspace,
			NewWorkspace:    newWorkspace,
			CopyVariables:   true,
		}
		sensitiveVars, err := lib.CloneWorkspace(config)
		if err != nil {
			log.Fatalf("Error: failed to clone workspace %s: %s", workspace, err)
			return
		}

		// TODO: update the VCS working directory (add "-secondary")

		if len(sensitiveVars) > 0 {
			fmt.Printf("%s - these sensitive variables must be set manually:\n", workspace)
			for _, v := range sensitiveVars {
				fmt.Printf("  %s\n", v)
			}
		}
	}
}

// setMultiregionVariables sets variables in Terraform Cloud as needed for a multiregion IdP
func setMultiregionVariables(pFlags PersistentFlags) {
	fmt.Println("\nsetting variables...")

	// Set variables in primary workspaces that also point to secondary workspaces

	coreVars := []lib.TFVar{
		{Key: "aws_create_secondary", Value: "true"},
		{Key: "aws_failover_active", Value: "false"},
		{Key: "aws_region_secondary", Value: pFlags.secondaryRegion},
	}
	setVars(pFlags, coreWorkspace(pFlags), coreVars)

	backupVars := []lib.TFVar{
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, backupWorkspace(pFlags), backupVars)

	// Set variables in the new secondary workspaces

	clusterVars := []lib.TFVar{
		{Key: "aws_zones", Value: getZonesHCL(pFlags.secondaryRegion), Hcl: true},
	}
	setVars(pFlags, clusterSecondaryWorkspace(pFlags), clusterVars)

	databaseVars := []lib.TFVar{
		{Key: "availability_zone", Value: pFlags.secondaryRegion + "a"}, // TODO: make this work in all regions
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database", Value: pFlags.org + "/" + databaseWorkspace(pFlags)},
	}
	setVars(pFlags, databaseSecondaryWorkspace(pFlags), databaseVars)

	pmaVars := []lib.TFVar{
		{Key: "pma_subdomain", Value: pFlags.idp + "-pma-secondary"},
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, pmaSecondaryWorkspace(pFlags), pmaVars)

	emailVars := []lib.TFVar{
		{Key: "email_subdomain", Value: pFlags.idp + "-email-secondary"},
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, emailSecondaryWorkspace(pFlags), emailVars)

	brokerVars := []lib.TFVar{
		{Key: "broker_subdomain", Value: pFlags.idp + "-broker-secondary"},
		{Key: "mfa_totp_apibaseurl", Value: "TODO"},     // TODO: get this value
		{Key: "mfa_webauthn_apibaseurl", Value: "TODO"}, // TODO: get this value
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_email_secondary", Value: pFlags.org + "/" + emailSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, brokerSecondaryWorkspace(pFlags), brokerVars)

	pwVars := []lib.TFVar{
		{Key: "api_subdomain", Value: pFlags.idp + "-pw-api-secondary"},
		{Key: "ui_subdomain", Value: pFlags.idp + "-pw-secondary"},
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_email_secondary", Value: pFlags.org + "/" + emailSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_broker_secondary", Value: pFlags.org + "/" + brokerSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, pwSecondaryWorkspace(pFlags), pwVars)

	sspVars := []lib.TFVar{
		{Key: "ssp_subdomain", Value: pFlags.idp + "-secondary"},
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_broker_secondary", Value: pFlags.org + "/" + brokerSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_pwmanager_secondary", Value: pFlags.org + "/" + pwSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, sspSecondaryWorkspace(pFlags), sspVars)

	syncVars := []lib.TFVar{
		{Key: "sync_subdomain", Value: pFlags.idp + "-sync-secondary"},
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_email_secondary", Value: pFlags.org + "/" + emailSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_broker_secondary", Value: pFlags.org + "/" + brokerSecondaryWorkspace(pFlags)},
	}
	setVars(pFlags, syncSecondaryWorkspace(pFlags), syncVars)
}

func deleteUnusedVariables(pFlags PersistentFlags) {
	fmt.Println("\nDeleting unused variables...")
	fmt.Println("(This feature is not yet implemented.)")
	// TODO: implement this, i.e. delete unused remotes and aws_region
}

func setProviderCredentials(pFlags PersistentFlags) {
	fmt.Println("\nSetting provider credential variables...")
	fmt.Println("(This feature is not yet implemented.)")
	// TODO: look for a variable set and apply it, or create variables directly in each new workspace
}

func setSensitiveVariables(pFlags PersistentFlags) {
	fmt.Println("\nSetting sensitive variables...")
	fmt.Println("(This feature is not yet implemented.)")
	// TODO: prompt for sensitive values or get them from config
}

// setVars sets a list of variables using the current variable values to decide whether to update or create
func setVars(pFlags PersistentFlags, workspace string, newVars []lib.TFVar) {
	currentVars, err := lib.GetVarsFromWorkspace(pFlags.org, workspace)
	if err != nil {
		log.Fatalf("failed to get the variables from %q", workspace)
	}

	for _, v := range newVars {
		setVar(pFlags, currentVars, workspace, v)
	}
}

// setVar sets a variable using the list of current variables to decide whether to update or create
func setVar(pFlags PersistentFlags, vars []lib.Var, workspace string, tfVar lib.TFVar) {
	if v := findVar(vars, tfVar.Key); v == nil {
		fmt.Printf("%s - creating var.%s with value %q\n", workspace, tfVar.Key, tfVar.Value)
		if !pFlags.readOnlyMode {
			lib.CreateVariable(pFlags.org, workspace, tfVar)
		}
	} else {
		if v.Value == tfVar.Value {
			fmt.Printf("%s - var.%s is already set to %q\n", workspace, tfVar.Key, tfVar.Value)
			return
		}
		fmt.Printf("%s - setting var.%s to %q\n", workspace, tfVar.Key, tfVar.Value)
		if !pFlags.readOnlyMode {
			lib.UpdateVariable(pFlags.org, workspace, v.ID, tfVar)
		}
	}
}

// findVar locates a variable by its key
func findVar(vars []lib.Var, key string) *lib.Var {
	for _, v := range vars {
		if v.Key == key {
			return &v
		}
	}
	return nil
}

func getZonesHCL(region string) string {
	// TODO: call the AWS EC2 API to get the actual list of zones. This list is safe for us-east-1, us-east-2, and us-west-2, at least.

	const template = `[
  "%[1]sa", 
  "%[1]sb", 
  "%[1]sc",
  "%[1]sd",
]`
	return fmt.Sprintf(template, region)
}
