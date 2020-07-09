Param(
    [Parameter(Mandatory = $True)]
    [SecureString]
    $AzureAdB2cTenantPassword
)

Push-Location (Join-Path $PSScriptRoot '..')

# Create release pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.release --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/release.yaml
az pipelines variable create --name semVerMajor --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.release
az pipelines variable create --name semVerMinor --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.release
az pipelines variable create --name semVerPatch --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.release
az pipelines variable create --name semVerMetaSha --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.release
az pipelines variable create --name semVerMetaBuild --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.release

# Create test pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.ci.test --folder-path 3mcloud\azure-iot-platform-dotnet\ci --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/ci/test.yaml
az pipelines variable create --name azureAdB2cTenantPassword --allow-override false --secret true --pipeline-name azure-iot-platform-dotnet.ci.test --value (ConvertFrom-SecureString -SecureString $AzureAdB2cTenantPassword -AsPlainText)
az pipelines variable create --name runCleanupStage --allow-override true --pipeline-name azure-iot-platform-dotnet.ci.test --value true
az pipelines variable create --name runRecordVersionStage --allow-override true --pipeline-name azure-iot-platform-dotnet.ci.test --value false
az pipelines variable create --name runTagImagesStage --allow-override true --pipeline-name azure-iot-platform-dotnet.ci.test --value false
az pipelines variable create --name runTagRepositoryStage --allow-override true --pipeline-name azure-iot-platform-dotnet.ci.test --value false

# Create code pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.code --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/code.yaml
az pipelines variable create --name imageTag --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code
az pipelines variable create --name runCrslDevStage --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code --value true

# Create code-hotfix pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.code-hotfix --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/code-hotfix.yaml
az pipelines variable create --name applicationCode --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code-hotfix
az pipelines variable create --name applicationShortCode --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code-hotfix
az pipelines variable create --name environmentCategory --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code-hotfix
az pipelines variable create --name environmentName --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code-hotfix
az pipelines variable create --name imageTag --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code-hotfix
az pipelines variable create --name subscriptionName --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.code-hotfix

# # Create all-in-one infra pipeline
# az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.infra --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/infra.yaml
# az pipelines variable create --name runCrslDevStage --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra --value true

# Create CRSL infra pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.infra-crsl --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/infra-crsl.yaml
az pipelines variable create --name runCrslDevStage --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-crsl --value true
az pipelines variable create --name testPipelineRunId --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-crsl

# Create CHIM infra pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.infra-chim --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/infra-chim.yaml
az pipelines variable create --name testPipelineRunId --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-chim

# Create EMD infra pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.infra-emd --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/infra-emd.yaml
az pipelines variable create --name testPipelineRunId --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-emd

# Create PSD infra pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.infra-psd --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/infra-psd.yaml
az pipelines variable create --name testPipelineRunId --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-psd

# Create infra-hotfix pipeline
az pipelines create --service-connection 06f045e5-23e2-47b5-9c67-421a3d858ee9 --name azure-iot-platform-dotnet.cd.infra-hotfix --folder-path 3mcloud\azure-iot-platform-dotnet\cd --skip-run --repository https://github.com/3mcloud/azure-iot-platform-dotnet --yaml-path pipelines/cd/infra-hotfix.yaml
az pipelines variable create --name applicationCode --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name applicationShortCode --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name environmentCategory --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name environmentName --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name kubernetesVersion --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name locationName --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name sendGridEmail --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name subscriptionId --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name subscriptionName --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name sysAdmins --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix
az pipelines variable create --name testPipelineRunId --allow-override true --pipeline-name azure-iot-platform-dotnet.cd.infra-hotfix

Pop-Location