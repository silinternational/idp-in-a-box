/*
Copyright © 2023 SIL International
*/

package multiregion

import (
	"fmt"
	"log"
	"strings"

	"github.com/silinternational/tfc-ops/v3/lib"
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

	lib.SetToken(pFlags.tfcToken)

	createSecondaryWorkspaces(pFlags)
	setMultiregionVariables(pFlags)
	deleteUnusedVariables(pFlags)
	setSensitiveVariables(pFlags)

	if err := setRemoteConsumers(pFlags); err != nil {
		log.Fatalf("Error: " + err.Error())
	}

	err := setRunTriggers(pFlags)
	if err != nil {
		log.Fatalf("Error: " + err.Error())
	}
}

// createSecondaryWorkspaces creates new secondary workspaces by cloning the corresponding primary workspace
func createSecondaryWorkspaces(pFlags PersistentFlags) {
	fmt.Println("\nCreating secondary workspaces...")

	createSecondaryWorkspace(pFlags, clusterWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, databaseWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, pmaWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, emailWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, brokerWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, pwWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, sspWorkspace(pFlags))
	createSecondaryWorkspace(pFlags, syncWorkspace(pFlags))
}

// createSecondaryWorkspace creates a new secondary workspace by cloning the corresponding primary workspace. It also
// changes workspace properties as necessary.
func createSecondaryWorkspace(pFlags PersistentFlags, workspace string) {
	newWorkspace := workspace + "-secondary"
	wsList := lib.FindWorkspaces(pFlags.org, newWorkspace)

	if len(wsList) == 0 && !pFlags.readOnlyMode {
		cloneWorkspace(pFlags, workspace, newWorkspace)
	}

	setWorkspaceProperties(pFlags, newWorkspace)
}

// cloneWorkspace clones a workspace
func cloneWorkspace(pFlags PersistentFlags, workspace, newWorkspace string) {
	fmt.Printf("Cloning %s to %s\n", workspace, newWorkspace)

	config := lib.CloneConfig{
		Organization:      pFlags.org,
		SourceWorkspace:   workspace,
		NewWorkspace:      newWorkspace,
		CopyVariables:     true,
		ApplyVariableSets: true,
	}
	sensitiveVars, err := lib.CloneWorkspace(config)
	if err != nil {
		log.Fatalf("Error: failed to clone workspace %s: %s", workspace, err)
		return
	}

	if len(sensitiveVars) > 0 {
		fmt.Printf("%s - these sensitive variables must be set manually:\n", workspace)
		for _, v := range sensitiveVars {
			fmt.Printf("  %s\n", v)
		}
	}
}

// setWorkspaceProperties
func setWorkspaceProperties(pFlags PersistentFlags, workspace string) {
	fmt.Printf("Setting %s properties\n", workspace)

	wsProperties, err := lib.GetWorkspaceData(pFlags.org, workspace)
	if err != nil {
		if pFlags.readOnlyMode {
			// In read-only mode, ignore the error since the workspace creation was skipped. The query is still
			// useful, though, since the workspace may have been created previously.
			wsProperties = lib.WorkspaceJSON{}
		} else {
			log.Fatalf("Error: failed to get workspace details for %q: %s", workspace, err)
		}
	}

	// strip the "idp-name-env-" from the front of "idp-name-env-000-workspace-name"
	newWorkingDir := strings.SplitN(workspace, "-", 4)[3]

	if wsProperties.Data.Attributes.WorkingDirectory == newWorkingDir {
		fmt.Printf("%s - working-directory is already set to %s\n", workspace, newWorkingDir)
	} else {
		if pFlags.readOnlyMode {
			return
		}
		params := lib.WorkspaceUpdateParams{
			Organization:    pFlags.org,
			WorkspaceFilter: workspace,
			Attribute:       "working-directory",
			Value:           newWorkingDir,
		}
		if err = lib.UpdateWorkspace(params); err != nil {
			log.Fatalf("Error: failed to update workspace %s: %s", workspace, err)
			return
		}

	}
}

// setMultiregionVariables sets variables in Terraform Cloud as needed for a multiregion IdP
func setMultiregionVariables(pFlags PersistentFlags) {
	fmt.Println("\nSetting variables...")

	tfRemoteClusterSecondary := lib.TFVar{Key: "tf_remote_cluster_secondary", Value: pFlags.org + "/" + clusterSecondaryWorkspace(pFlags)}
	tfRemoteDatabase := lib.TFVar{Key: "tf_remote_database", Value: pFlags.org + "/" + databaseWorkspace(pFlags)}
	tfRemoteDatabaseSecondary := lib.TFVar{Key: "tf_remote_database_secondary", Value: pFlags.org + "/" + databaseSecondaryWorkspace(pFlags)}
	tfRemoteEmailSecondary := lib.TFVar{Key: "tf_remote_email_secondary", Value: pFlags.org + "/" + emailSecondaryWorkspace(pFlags)}
	tfRemoteBrokerSecondary := lib.TFVar{Key: "tf_remote_broker_secondary", Value: pFlags.org + "/" + brokerSecondaryWorkspace(pFlags)}
	tfRemotePwManagerSecondary := lib.TFVar{Key: "tf_remote_pwmanager_secondary", Value: pFlags.org + "/" + pwSecondaryWorkspace(pFlags)}

	// Set variables in primary workspaces that also point to secondary workspaces

	coreVars := []lib.TFVar{
		{Key: "aws_create_secondary", Value: "true"},
		{Key: "aws_failover_active", Value: "false"},
		{Key: "aws_region_secondary", Value: pFlags.secondaryRegion},
	}
	setVars(pFlags, coreWorkspace(pFlags), coreVars)

	backupVars := []lib.TFVar{
		tfRemoteClusterSecondary,
		tfRemoteDatabaseSecondary,
	}
	setVars(pFlags, backupWorkspace(pFlags), backupVars)

	// Set variables in the new secondary workspaces

	clusterVars := []lib.TFVar{
		{Key: "aws_zones", Value: getZonesHCL(pFlags.secondaryRegion), Hcl: true},
	}
	setVars(pFlags, clusterSecondaryWorkspace(pFlags), clusterVars)

	databaseVars := []lib.TFVar{
		{Key: "availability_zone", Value: pFlags.secondaryRegion + "a"}, // TODO: make this work in all regions
		tfRemoteClusterSecondary,
		tfRemoteDatabase,
	}
	setVars(pFlags, databaseSecondaryWorkspace(pFlags), databaseVars)

	pmaVars := []lib.TFVar{
		{Key: "pma_subdomain", Value: pFlags.idp + "-pma-secondary"},
		tfRemoteClusterSecondary,
		tfRemoteDatabaseSecondary,
	}
	setVars(pFlags, pmaSecondaryWorkspace(pFlags), pmaVars)

	emailVars := []lib.TFVar{
		tfRemoteClusterSecondary,
		tfRemoteDatabaseSecondary,
	}
	setVars(pFlags, emailSecondaryWorkspace(pFlags), emailVars)

	brokerVars := []lib.TFVar{
		{Key: "mfa_totp_apibaseurl", Value: "TODO"},     // TODO: get this value
		{Key: "mfa_webauthn_apibaseurl", Value: "TODO"}, // TODO: get this value
		tfRemoteClusterSecondary,
		tfRemoteDatabaseSecondary,
		tfRemoteEmailSecondary,
	}
	setVars(pFlags, brokerSecondaryWorkspace(pFlags), brokerVars)

	pwVars := []lib.TFVar{
		tfRemoteClusterSecondary,
		tfRemoteDatabaseSecondary,
		tfRemoteEmailSecondary,
		tfRemoteBrokerSecondary,
	}
	setVars(pFlags, pwSecondaryWorkspace(pFlags), pwVars)

	sspVars := []lib.TFVar{
		tfRemoteClusterSecondary,
		tfRemoteDatabaseSecondary,
		tfRemoteBrokerSecondary,
		tfRemotePwManagerSecondary,
	}
	setVars(pFlags, sspSecondaryWorkspace(pFlags), sspVars)

	syncVars := []lib.TFVar{
		tfRemoteClusterSecondary,
		tfRemoteEmailSecondary,
		tfRemoteBrokerSecondary,
	}
	setVars(pFlags, syncSecondaryWorkspace(pFlags), syncVars)
}

func deleteUnusedVariables(pFlags PersistentFlags) {
	fmt.Println("\nDeleting unused variables...")
	fmt.Println("(This feature is not yet implemented.)")
	// TODO: implement this, i.e. delete unused remotes and aws_region
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

func setRemoteConsumers(pFlags PersistentFlags) error {
	fmt.Println("\nCreating workspace remote consumers ...")

	workspacesToUpdate := []string{
		coreWorkspace(pFlags),
		clusterSecondaryWorkspace(pFlags),
		databaseWorkspace(pFlags),
		databaseSecondaryWorkspace(pFlags),
		ecrWorkspace(pFlags),
		emailSecondaryWorkspace(pFlags),
		brokerSecondaryWorkspace(pFlags),
		pwSecondaryWorkspace(pFlags),
	}

	for _, workspace := range workspacesToUpdate {
		workspaceID, err := getWorkspaceID(pFlags.org, workspace)
		if err != nil {
			return fmt.Errorf("setRemoteConsumers: %w", err)
		}

		consumers := getWorkspaceConsumers(pFlags, workspace)
		consumerIDs := make([]string, len(consumers))
		for i, consumer := range consumers {
			data, err := lib.GetWorkspaceData(pFlags.org, consumer)
			if err != nil {
				return fmt.Errorf("setRemoteConsumers: %w", err)
			}
			consumerIDs[i] = data.Data.ID
		}

		if pFlags.readOnlyMode {
			fmt.Printf("  %s: %+v\n", workspaceID, consumers)
			continue
		}

		if err := lib.AddRemoteStateConsumers(workspaceID, consumerIDs); err != nil {
			return fmt.Errorf("setRemoteConsumers: %w", err)
		}
	}
	return nil
}

func getWorkspaceConsumers(pFlags PersistentFlags, workspace string) []string {
	consumers := map[string][]string{
		coreWorkspace(pFlags): {
			clusterSecondaryWorkspace(pFlags),
			databaseSecondaryWorkspace(pFlags),
			pmaSecondaryWorkspace(pFlags),
			emailSecondaryWorkspace(pFlags),
			brokerSecondaryWorkspace(pFlags),
			pwSecondaryWorkspace(pFlags),
			sspSecondaryWorkspace(pFlags),
			syncSecondaryWorkspace(pFlags),
		},
		clusterSecondaryWorkspace(pFlags): {
			databaseSecondaryWorkspace(pFlags),
			pmaSecondaryWorkspace(pFlags),
			emailSecondaryWorkspace(pFlags),
			brokerSecondaryWorkspace(pFlags),
			pwSecondaryWorkspace(pFlags),
			sspSecondaryWorkspace(pFlags),
			syncSecondaryWorkspace(pFlags),
		},
		databaseWorkspace(pFlags): {
			databaseSecondaryWorkspace(pFlags),
		},
		databaseSecondaryWorkspace(pFlags): {
			pmaSecondaryWorkspace(pFlags),
			emailSecondaryWorkspace(pFlags),
			brokerSecondaryWorkspace(pFlags),
			pwSecondaryWorkspace(pFlags),
			sspSecondaryWorkspace(pFlags),
		},
		ecrWorkspace(pFlags): {
			brokerSecondaryWorkspace(pFlags),
			pwSecondaryWorkspace(pFlags),
			sspSecondaryWorkspace(pFlags),
			syncSecondaryWorkspace(pFlags),
		},
		emailSecondaryWorkspace(pFlags): {
			brokerSecondaryWorkspace(pFlags),
			pwSecondaryWorkspace(pFlags),
			syncSecondaryWorkspace(pFlags),
		},
		brokerSecondaryWorkspace(pFlags): {
			pwSecondaryWorkspace(pFlags),
			sspSecondaryWorkspace(pFlags),
			syncSecondaryWorkspace(pFlags),
		},
		pwSecondaryWorkspace(pFlags): {
			sspSecondaryWorkspace(pFlags),
		},
	}
	return consumers[workspace]
}

func setRunTriggers(pFlags PersistentFlags) error {
	fmt.Println("\nSetting workspace run triggers ...")

	// map of workspaces (key) and source workspaces (value) for run triggers to be created
	runTriggers := map[string]string{
		clusterSecondaryWorkspace(pFlags):  coreWorkspace(pFlags),
		databaseSecondaryWorkspace(pFlags): coreWorkspace(pFlags),
		pmaSecondaryWorkspace(pFlags):      coreWorkspace(pFlags),
		emailSecondaryWorkspace(pFlags):    coreWorkspace(pFlags),
		brokerSecondaryWorkspace(pFlags):   coreWorkspace(pFlags),
		pwSecondaryWorkspace(pFlags):       coreWorkspace(pFlags),
		sspSecondaryWorkspace(pFlags):      coreWorkspace(pFlags),
		syncSecondaryWorkspace(pFlags):     coreWorkspace(pFlags),
		clusterSecondaryWorkspace(pFlags):  clusterSecondaryWorkspace(pFlags),
		databaseSecondaryWorkspace(pFlags): clusterSecondaryWorkspace(pFlags),
		pmaSecondaryWorkspace(pFlags):      clusterSecondaryWorkspace(pFlags),
		emailSecondaryWorkspace(pFlags):    clusterSecondaryWorkspace(pFlags),
		brokerSecondaryWorkspace(pFlags):   clusterSecondaryWorkspace(pFlags),
		pwSecondaryWorkspace(pFlags):       clusterSecondaryWorkspace(pFlags),
		sspSecondaryWorkspace(pFlags):      clusterSecondaryWorkspace(pFlags),
		syncSecondaryWorkspace(pFlags):     clusterSecondaryWorkspace(pFlags),
	}

	for workspace, source := range runTriggers {
		if err := createRunTrigger(pFlags, workspace, source); err != nil {
			return fmt.Errorf("failed to set run trigger from %s to %s: %w", source, workspace, err)
		}
	}
	return nil
}

func getWorkspaceID(org, workspaceName string) (string, error) {
	data, err := lib.GetWorkspaceData(org, workspaceName)
	if err != nil {
		return "", fmt.Errorf("failed to get workspace data: %w", err)
	}
	return data.Data.ID, nil
}

func createRunTrigger(pFlags PersistentFlags, workspaceName, sourceName string) error {
	workspaceID, err := getWorkspaceID(pFlags.org, workspaceName)
	if err != nil {
		return fmt.Errorf("failed to get workspace ID for run trigger: %w", err)
	}

	sourceID, err := getWorkspaceID(pFlags.org, sourceName)
	if err != nil {
		return fmt.Errorf("failed to get source workspace ID for run trigger: %w", err)
	}

	t, err := lib.FindRunTrigger(lib.FindRunTriggerConfig{
		WorkspaceID:       workspaceID,
		SourceWorkspaceID: sourceID,
	})
	if err != nil {
		return fmt.Errorf("failed to get run triggers for workspace %s: %w", workspaceName, err)
	}
	if t != nil {
		fmt.Printf("Run trigger %s -> %s is already set\n", sourceName, workspaceName)
		return nil
	}

	if pFlags.readOnlyMode {
		fmt.Printf("(Read-only Mode) Run trigger %s -> %s would be set\n", sourceName, workspaceName)
		return nil
	}

	if err := lib.CreateRunTrigger(lib.RunTriggerConfig{
		WorkspaceID:       workspaceID,
		SourceWorkspaceID: sourceID,
	}); err != nil {
		return fmt.Errorf("create run trigger API error: %w", err)
	}
	return nil
}
