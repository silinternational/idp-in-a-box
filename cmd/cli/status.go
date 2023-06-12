/*
Copyright © 2023 SIL International
*/
package main

import (
	"fmt"
	"log"

	"github.com/silinternational/tfc-ops/lib"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Read the current status of the IdP",
	Long:  `Read the current status of the IdP. Does not modify any infrastructure.`,
	Run: func(cmd *cobra.Command, args []string) {
		status()
	},
}

func setupStatusCmd(rootCmd *cobra.Command) {
	rootCmd.AddCommand(statusCmd)
}

func status() {
	idp := viper.GetString("idp")
	if idp == "" {
		log.Fatalln("no IdP key is set, use --idp to set the IdP key")
	}

	org := viper.GetString("org")
	if org == "" {
		log.Fatalln("no org is set, use --org to set the Terraform Cloud org")
	}

	token := viper.GetString("token")
	if token == "" {
		log.Fatalln("no token is set, use --token to set the Terraform Cloud API token")
	}
	lib.SetToken(token)

	workspaceName := fmt.Sprintf("idp-%s-prod-000-core", idp)
	const varAwsFailoverActive = "aws_failover_active"
	failoverActive, err := lib.GetWorkspaceVar(org, workspaceName, varAwsFailoverActive)
	if err != nil {
		log.Fatalf("failed to get the value of %q", varAwsFailoverActive)
	}

	if failoverActive.Value == "true" {
		fmt.Println("IdP Failover is ACTIVE")
	} else {
		fmt.Println("IdP Failover is NOT active")
	}
}
