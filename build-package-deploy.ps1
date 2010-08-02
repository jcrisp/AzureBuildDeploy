### CONFIGURE THESE ###
$projectName = "WcfAzure"
$serviceName = "twpoc" # the name you chose for your domain. Eg, my_chosen_name.cloudapp.net
$msBuild = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
#######################

$solutionPath = (Split-Path -Path $MyInvocation.MyCommand.Path -Parent) + "\" + $projectName

echo ========== BUILDING AND PACKAGING ===============
& $msBuild /t:CorePublish "$solutionPath\$projectName.ccproj"

echo ========== DEPLOYING ===============
./deploy.ps1 "$solutionPath\bin\Debug\Publish" "$projectName.cspkg" ServiceConfiguration.cscfg $serviceName
