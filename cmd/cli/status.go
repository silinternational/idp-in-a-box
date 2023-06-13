/*
Copyright © 2023 SIL International
*/
package main

import (
	"fmt"
	"log"

	"github.com/silinternational/tfc-ops/lib"
	"github.com/spf13/cobra"
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
	pFlags := getPersistentFlags()

	lib.SetToken(pFlags.token)

	workspaceName := fmt.Sprintf("idp-%s-prod-000-core", pFlags.idp)
	vars, err := lib.GetVarsFromWorkspace(pFlags.org, workspaceName)
	if err != nil {
		log.Fatalf("failed to get the variables from %q", workspaceName)
	}

	for _, v := range vars {
		switch v.Key {
		case "aws_region":
			fmt.Println("Primary region: ", v.Value)

		case "aws_region_secondary":
			fmt.Println("Secondary region: ", v.Value)

		case "aws_failover_active":
			if v.Value == "true" {
				fmt.Println("IdP Failover is ACTIVE")
			} else {
				fmt.Println("IdP Failover is NOT active")
			}

		case "aws_create_secondary":
			if v.Value == "true" {
				fmt.Println("Secondary resources ARE created")
			} else {
				fmt.Println("Secondary resources are NOT created")
			}
		}
	}
}
