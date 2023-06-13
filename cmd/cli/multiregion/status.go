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

func InitStatusCmd(parentCmd *cobra.Command) {
	statusCmd := &cobra.Command{
		Use:   "status",
		Short: "Read the current status of the IdP",
		Long:  `Read the current status of the IdP. Does not modify any infrastructure.`,
		Run: func(cmd *cobra.Command, args []string) {
			runStatus()
		},
	}

	parentCmd.AddCommand(statusCmd)
}

func runStatus() {
	pFlags := getPersistentFlags()

	lib.SetToken(pFlags.token)

	workspaceName := fmt.Sprintf("idp-%s-prod-000-core", pFlags.idp)
	const varAwsFailoverActive = "aws_failover_active"
	failoverActive, err := lib.GetWorkspaceVar(pFlags.org, workspaceName, varAwsFailoverActive)
	if err != nil {
		log.Fatalf("failed to get the value of %q", varAwsFailoverActive)
	}

	if failoverActive.Value == "true" {
		fmt.Println("IdP Failover is ACTIVE")
	} else {
		fmt.Println("IdP Failover is NOT active")
	}
}
