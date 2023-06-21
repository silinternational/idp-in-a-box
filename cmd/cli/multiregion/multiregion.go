/*
Copyright © 2023 SIL International
*/

package multiregion

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func SetupMultiregionCmd(parentCommand *cobra.Command) {
	multiregionCmd := &cobra.Command{
		Use:   "multiregion",
		Short: "Tools for multiregion operation",
		Long:  `Tools for multiregion setup, operation, fail-over, and fail-back`,
	}

	parentCommand.AddCommand(multiregionCmd)
	InitFailoverCmd(multiregionCmd)
	InitSetupCmd(multiregionCmd)
	InitStatusCmd(multiregionCmd)

	var cloudflareToken string
	multiregionCmd.PersistentFlags().StringVar(&cloudflareToken, "cloudflare-token", "", "Cloudflare API token")
	cfTokenFlag := multiregionCmd.PersistentFlags().Lookup("cloudflare-token")
	if err := viper.BindPFlag("cloudflare-token", cfTokenFlag); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}

	var domainName string
	multiregionCmd.PersistentFlags().StringVar(&domainName, "domain-name", "", "Domain name")
	if err := viper.BindPFlag("domain-name", multiregionCmd.PersistentFlags().Lookup("domain-name")); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}

	var env string
	multiregionCmd.PersistentFlags().StringVar(&env, "env", "prod", "Execution environment (default: prod)")
	if err := viper.BindPFlag("env", multiregionCmd.PersistentFlags().Lookup("env")); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}

	var region2 string
	multiregionCmd.PersistentFlags().StringVar(&region2, "region2", "", "Secondary AWS region")
	if err := viper.BindPFlag("region2", multiregionCmd.PersistentFlags().Lookup("region2")); err != nil {
		log.Fatalln("Error: unable to bind flag:", err)
	}
}

type PersistentFlags struct {
	env             string
	cloudflareToken string
	domainName      string
	idp             string
	org             string
	readOnlyMode    bool
	secondaryRegion string
	tfcToken        string
}

func getPersistentFlags() PersistentFlags {
	cloudflareToken := viper.GetString("cloudflare-token")
	if cloudflareToken == "" {
		log.Fatalln("no Cloudflare API Token is set, use --cloudflare-token parameter")
	}

	domainName := viper.GetString("domain-name")
	if domainName == "" {
		log.Fatalln("no domain name is set, use --domain-name parameter")
	}

	env := viper.GetString("env")
	if env == "" {
		log.Fatalln("no operating environment is set, use --env parameter")
	}

	idp := viper.GetString("idp")
	if idp == "" {
		log.Fatalln("no IdP key is set, use --idp parameter")
	}

	org := viper.GetString("org")
	if org == "" {
		log.Fatalln("no Terraform Cloud organization is set, use --org parameter")
	}

	tfcToken := viper.GetString("tfc-token")
	if tfcToken == "" {
		log.Fatalln("no Terraform Cloud Token is set, use --tfc-token parameter")
	}

	secondaryRegion := viper.GetString("region2")
	if secondaryRegion == "" {
		log.Fatalln("no secondary region is set, use --region2 parameter")
	}

	readOnlyMode := viper.GetBool("read-only-mode")

	return PersistentFlags{
		cloudflareToken: cloudflareToken,
		env:             env,
		idp:             idp,
		org:             org,
		tfcToken:        tfcToken,
		secondaryRegion: secondaryRegion,
		readOnlyMode:    readOnlyMode,
	}
}

func coreWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-000-core", pFlags.idp, pFlags.env)
}

func clusterWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-010-cluster", pFlags.idp, pFlags.env)
}

func clusterSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-010-cluster-secondary", pFlags.idp, pFlags.env)
}

func databaseWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-020-database", pFlags.idp, pFlags.env)
}

func databaseSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-020-database-secondary", pFlags.idp, pFlags.env)
}

func ecrWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-022-ecr", pFlags.idp, pFlags.env)
}

func pmaWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-030-phpmyadmin", pFlags.idp, pFlags.env)
}

func pmaSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-030-phpmyadmin-secondary", pFlags.idp, pFlags.env)
}

func emailWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-031-email-service", pFlags.idp, pFlags.env)
}

func emailSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-031-email-service-secondary", pFlags.idp, pFlags.env)
}

func backupWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-032-db-backup", pFlags.idp, pFlags.env)
}

func brokerWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-040-id-broker", pFlags.idp, pFlags.env)
}

func brokerSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-040-id-broker-secondary", pFlags.idp, pFlags.env)
}

func searchWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-041-id-broker-search", pFlags.idp, pFlags.env)
}

func pwWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-050-pw-manager", pFlags.idp, pFlags.env)
}

func pwSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-050-pw-manager-secondary", pFlags.idp, pFlags.env)
}

func sspWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-060-simplesamlphp", pFlags.idp, pFlags.env)
}

func sspSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-060-simplesamlphp-secondary", pFlags.idp, pFlags.env)
}

func syncWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-070-id-sync", pFlags.idp, pFlags.env)
}

func syncSecondaryWorkspace(pFlags PersistentFlags) string {
	return fmt.Sprintf("idp-%s-%s-070-id-sync-secondary", pFlags.idp, pFlags.env)
}
