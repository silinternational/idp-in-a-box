/*
Copyright © 2023 SIL International
*/
package main

import (
	"errors"
	"fmt"
	"log"
	"os"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

const requiredPrefix = "required - "

var defaultsFile string

func Execute() {
	rootCmd := &cobra.Command{
		Use:   "idp",
		Short: "idp-in-a-box CLI",
		Long: `idp is a CLI tool for the silinternational/idp-in-a-box system.
It can be used to check the status of the IdP. It can also be used to establish secondary resources
in a second AWS region, and to initiate a secondary region failover action.`,
	}

	rootCmd.PersistentFlags().StringVar(&defaultsFile, "defaults", "", "Defaults file")

	var org string
	rootCmd.PersistentFlags().StringVar(&org, "org", "", requiredPrefix+"Terraform Cloud organization")
	if err := viper.BindPFlag("org", rootCmd.PersistentFlags().Lookup("org")); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}

	var token string
	rootCmd.PersistentFlags().StringVar(&token, "token", "", requiredPrefix+"Terraform Cloud token")
	if err := viper.BindPFlag("token", rootCmd.PersistentFlags().Lookup("token")); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}

	var idp string
	rootCmd.PersistentFlags().StringVar(&idp, "idp", "", requiredPrefix+"IDP key (short name)")
	if err := viper.BindPFlag("idp", rootCmd.PersistentFlags().Lookup("idp")); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}

	setupStatusCmd(rootCmd)

	cobra.OnInitialize(initDefaults)

	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

// initDefaults reads in a Defaults file and ENV variables if set.
func initDefaults() {
	if defaultsFile != "" {
		// Use defaults file from the flag.
		viper.SetConfigFile(defaultsFile)
	} else {
		// Find home directory and add ~/.config/ to the config search path
		home, err := os.UserHomeDir()
		cobra.CheckErr(err)
		viper.AddConfigPath(home + "/.config")

		// Add the current directory to the search path
		viper.AddConfigPath(".")

		// Set the config file name to "idp", allowing any supported file extension, e.g. idp-cli.toml
		viper.SetConfigName("idp-cli")
	}

	// look for environment variables that match the uppercase of the viper key, prefixed with "IDP_"
	viper.SetEnvPrefix("IDP")
	viper.AutomaticEnv()

	// If a defaults file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		_, err = fmt.Fprintln(os.Stderr, "Using defaults file:", viper.ConfigFileUsed())
		if err != nil {
			panic(err.Error())
		}
	} else {
		var vErr viper.ConfigFileNotFoundError
		if !errors.As(err, &vErr) {
			_, err = fmt.Fprintf(os.Stderr, "Problem with defaults file: %s %T\n", err, err)
			if err != nil {
				panic(err.Error())
			}
		}
	}
}

type PersistentFlags struct {
	idp   string
	org   string
	token string
}

func getPersistentFlags() PersistentFlags {
	idp := viper.GetString("idp")
	if idp == "" {
		log.Fatalln("no IdP key is set, use --idp to set the IdP key")
	}

	org := viper.GetString("org")
	if org == "" {
		log.Fatalln("no Org is set, use --org to set the Terraform Cloud org")
	}

	token := viper.GetString("token")
	if token == "" {
		log.Fatalln("no Token is set, use --token to set the Terraform Cloud API token")
	}

	return PersistentFlags{
		idp:   idp,
		org:   org,
		token: token,
	}
}
