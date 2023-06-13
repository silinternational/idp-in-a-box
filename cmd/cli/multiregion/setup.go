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

	setMultiregionVariables(pFlags)
}

// setMultiregionVariables sets variables in Terraform Cloud as needed for a multiregion IdP
func setMultiregionVariables(pFlags PersistentFlags) {
	fmt.Println("\nsetting variables...")

	coreVars := []lib.TFVar{
		{Key: "aws_create_secondary", Value: "true"},
		{Key: "aws_failover_active", Value: "false"},
		{Key: "aws_region_secondary", Value: pFlags.secondaryRegion},
	}
	if err := setVars(pFlags, coreWorkspace(pFlags), coreVars); err != nil {
		return
	}

	backupVars := []lib.TFVar{
		{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)},
		{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)},
	}
	if err := setVars(pFlags, backupWorkspace(pFlags), backupVars); err != nil {
		return
	}
}

// setVars sets a list of variables using the current variable values to decide whether to update or create
func setVars(pFlags PersistentFlags, workspace string, newVars []lib.TFVar) error {
	currentVars, err := lib.GetVarsFromWorkspace(pFlags.org, workspace)
	if err != nil {
		log.Fatalf("failed to get the variables from %q", workspace)
	}

	for _, v := range newVars {
		if err := setVar(pFlags, currentVars, workspace, v); err != nil {
			log.Fatalf("Error: could not set variable %q in workspace %q: %s", v.Key, workspace)
		}
	}
	return nil
}

// setVar sets a variable using the list of current variables to decide whether to update or create
func setVar(pFlags PersistentFlags, vars []lib.Var, workspace string, tfVar lib.TFVar) error {
	if v := findVar(vars, tfVar.Key); v == nil {
		fmt.Printf("%s - creating var.%s with value %q\n", workspace, tfVar.Key, tfVar.Value)
		if !pFlags.readOnlyMode {
			lib.CreateVariable(pFlags.org, workspace, tfVar)
		}
	} else {
		if v.Value == tfVar.Value {
			fmt.Printf("%s - var.%s is already set to %q\n", workspace, tfVar.Key, tfVar.Value)
			return nil
		}
		fmt.Printf("%s - setting var.%s to %q\n", workspace, tfVar.Key, tfVar.Value)
		if !pFlags.readOnlyMode {
			lib.UpdateVariable(pFlags.org, workspace, v.ID, tfVar)
		}
	}
	return nil
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
