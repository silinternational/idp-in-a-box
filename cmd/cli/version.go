/*
Copyright © 2023 SIL International
*/
package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

func SetupVersionCmd(parentCommand *cobra.Command) {
	parentCommand.AddCommand(versionCmd)
}

// version is set at build time
var version = "(unknown)"

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Show idp-cli version",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Version %s\n", version)
	},
}
