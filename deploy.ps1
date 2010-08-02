######## CONFIGURE THESE ##########
# Find fingerprint for cert with dir cert:\currentUser\my| select *
$cert = Get-Item cert:\CurrentUser\My\07B5B9124CC29BF8F08$D3D9D388AC3FA1A84F7BF

# Get subscriptionId from Account tab in the web console
$subscriptionId = "13a5d54d-1852-4ec8-21da-59ec2d17ae72"
###################################

# usage: ./deploy.ps1 <path to package dir> <package file name> <service config file name> <service name - ie, service_name_here.cloudapp.net >
# eg, ./deploy.ps1 "C:\Users\James\dev\dotnet\BasicClassic\bin\Debug\Publish" BasicClassic.cspkg ServiceConfiguration.cscfg twpoc

# Other required set up
# install VS, IIS & powershell if you don't have it
# install azure sdk: http://download.microsoft.com/DOWNLOAD/1/F/9/1F96D60F-EBE9-44CB-BD58-88C2EC14929E/VSCLOUDSERVICE.EXE
# install azure cmdlets: http://code.msdn.microsoft.com/azurecmdlets/Release/ProjectReleases.aspx?ReleaseId=3912

# script modified from http://msdn.microsoft.com/en-us/library/ff803365.aspx

$buildPath = $args[0]
$packagename = $args[1]
$serviceconfig = $args[2]
$servicename = $args[3]
$package = join-path $buildPath $packageName
$config = join-path $buildPath $serviceconfig
$a = Get-Date
$buildLabel = $a.ToShortDateString() + "-" + $a.ToShortTimeString()

if ((Get-PSSnapin | ?{$_.Name -eq "AzureManagementToolsSnapIn"}) -eq $null)
{
  Add-PSSnapin AzureManagementToolsSnapIn
}

$hostedService = Get-HostedService $servicename -Certificate $cert -SubscriptionId $subscriptionId | Get-Deployment -Slot Staging

if ($hostedService.Status -ne $null)
{
    echo "Service already exists, suspending and removing it"
    $hostedService |
      Set-DeploymentStatus 'Suspended' |
      Get-OperationStatus -WaitToComplete
    $hostedService | 
      Remove-Deployment | 
      Get-OperationStatus -WaitToComplete
}

echo "Deploying new service"
Get-HostedService $servicename -Certificate $cert -SubscriptionId $subscriptionId |
    New-Deployment Staging -package $package -configuration $config -label $buildLabel -serviceName $servicename | 
    Get-OperationStatus -WaitToComplete

echo "Starting new service"
Get-HostedService $servicename -Certificate $cert -SubscriptionId $subscriptionId | 
    Get-Deployment -Slot Staging | 
    Set-DeploymentStatus 'Running' | 
    Get-OperationStatus -WaitToComplete

#    Move staging to production, this will actually swap them over
# Get-HostedService -serviceName $service -subscriptionId $subscriptionId -certificate $cert |
#    Get-Deployment -slot staging |
#    Move-Deployment |
#    Get-OperationStatus -WaitToComplete

