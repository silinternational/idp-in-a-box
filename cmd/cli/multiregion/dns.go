/*
Copyright © 2023 SIL International
*/

package multiregion

import (
	"context"
	"fmt"
	"log"

	"github.com/cloudflare/cloudflare-go"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

type DnsCommand struct {
	cfClient   *cloudflare.API
	cfZone     *cloudflare.ResourceContainer
	domainName string
	testMode   bool
}

func InitDnsCmd(parentCmd *cobra.Command) {
	parentCmd.AddCommand(&cobra.Command{
		Use:   "dns",
		Short: "DNS Failover and Failback",
		Long:  `Configure DNS CNAME values for primary or secondary region hostnames`,
		Run: func(cmd *cobra.Command, args []string) {
			runDnsCommand()
		},
	})
}

func runDnsCommand() {
	pFlags := getPersistentFlags()

	f := newDnsCommand(pFlags)

	f.setDnsToSecondary()
}

func newDnsCommand(pFlags PersistentFlags) *DnsCommand {
	d := DnsCommand{
		testMode:   pFlags.readOnlyMode,
		domainName: viper.GetString("domain-name"),
	}

	if d.domainName == "" {
		log.Fatalln("Cloudflare Domain Name is not configured. Use 'domain-name' parameter.")
	}

	cfToken := viper.GetString("cloudflare-token")
	if cfToken == "" {
		log.Fatalln("Cloudflare Token is not configured. Use 'cloudflare-token' parameter.")
	}

	api, err := cloudflare.NewWithAPIToken(cfToken)
	if err != nil {
		log.Fatal("failed to initialize the Cloudflare API:", err)
	}
	d.cfClient = api

	zoneID, err := d.cfClient.ZoneIDByName(d.domainName)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Using domain name %s with ID %s\n", d.domainName, zoneID)
	d.cfZone = cloudflare.ZoneIdentifier(zoneID)

	return &d
}

func (d *DnsCommand) setDnsToSecondary() {
	fmt.Println("Setting DNS records to secondary...")

	// "mfa-api" is the TOTP API, also known as serverless-mfa-api
	mfaApiName := getOption("mfa-api-name", "mfa-api")
	mfaApiValue := getOption("mfa-api-value", "")
	d.setCloudflareCname(mfaApiName, mfaApiValue)

	// "twosv-api" is the Webauthn API, also known as serverless-mfa-api-go
	twosvApiName := getOption("twosv-api-name", "twosv-api")
	twosvApiValue := getOption("twosv-api-value", "")
	d.setCloudflareCname(twosvApiName, twosvApiValue)

	// "support-bot" is the idp-support-bot API that is configured in the Slack API dashboard
	supportBotName := getOption("support-bot-name", "sherlock")
	supportBotValue := getOption("support-bot-value", "")
	d.setCloudflareCname(supportBotName, supportBotValue)
}

func (d *DnsCommand) setCloudflareCname(name, value string) {
	if value == "" {
		fmt.Printf("  skipping %s (no value provided)\n", name)
		return
	}

	fmt.Printf("  %s.%s --> %s\n", name, d.domainName, value)

	ctx := context.Background()

	r, _, err := d.cfClient.ListDNSRecords(ctx, d.cfZone, cloudflare.ListDNSRecordsParams{Name: name})
	if err != nil {
		log.Fatalf("error finding DNS record %s: %s", name, err)
	}
	if len(r) != 1 {
		log.Fatalf("did not find DNS record %s", name)
	}

	if r[0].Content == value {
		fmt.Printf("CNAME %s is already set to %s\n", name, value)
		return
	}

	if d.testMode {
		fmt.Println("  test mode: skipping API call")
		return
	}

	answer := simplePrompt(`Type "yes" to set this DNS record`)
	if answer != "yes" {
		return
	}

	_, err = d.cfClient.UpdateDNSRecord(ctx, d.cfZone, cloudflare.UpdateDNSRecordParams{
		ID:      r[0].ID,
		Type:    "CNAME",
		Name:    name,
		Content: value,
	})
	if err != nil {
		log.Fatalf("error updating DNS record %s: %s", name, err)
	}
}
