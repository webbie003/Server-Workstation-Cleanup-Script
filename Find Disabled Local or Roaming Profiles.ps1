####################################################
###                       Written by: webbie003  ###
###                          Created: 12/10/2020 ###
###                    Last Modified: 17/02/2023 ###
####################################################
$defaultPath = "C:\Users"
$path = @()
Write-Host "Enter the User Profile Path (Default Path:"$defaultPath"): " -ForegroundColor Yellow -NoNewline
if (($result = Read-Host) -eq '') {$path = $defaultPath} else {$path = $result}
$users = Get-ChildItem $path
$output = @()
$DisOutput = @()
Write-Host -ForegroundColor Yellow "The following users have a local/roaming profile on this server and have their AD account disabled:"
foreach ($user in $users)
 {
  $subFolderItems = (Get-ChildItem "$path\$user\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
  $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
  $output += $sum  
  $searcher = New-Object DirectoryServices.DirectorySearcher([ADSI]””)
  if ($user.Name -like '*.v2') {$user = $user.Name.Substring(0,$user.Name.Length-3)} #Accommodates for .V2 profiles.
  $searcher.filter = “(&(objectClass=user)(sAMAccountName= $user))”
  $founduser = $searcher.findOne()
  $value = $founduser.Properties.useraccountcontrol
  if ($Value -eq 514) #DISABLED_ACCOUNT 514 & NORMAL_ACCOUNT 512 (http://jackstromberg.com/2013/01/useraccountcontrol-attributeflag-values/)
   {
    $DisSubFolderItems = (Get-ChildItem "$path\$user\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)    
    $disSum = ("{0:N2}" -f ($DisSubFolderItems.sum / 1MB))
    $DisOutput += $disSum 
    $DisUserSum = ("$user " + "- {0:N2}" -f ($disSum | Measure-Object -Sum).sum + " MB")
    Write-Host $DisUserSum
    # Delete Option (Get-WmiObject Win32_UserProfile | Where {$_.LocalPath -like "*\"+ $user +"*"}).Delete()
   }
 }
$totalSum = ("Total Users Folder Size: " + "{0:N2}" -f ($output | Measure-Object -Sum).sum + " MB")
$totaldisSum = ("Total Disabled Users Folder Size: " + "{0:N2}" -f ($DisOutput | Measure-Object -Sum).sum + " MB")
Write-Host -ForegroundColor Yellow "======================================================================="
Write-Host -ForegroundColor Green ($totalSum)
Write-Host -ForegroundColor Red ($totaldisSum)
Write-Host ""
Write-Host -ForegroundColor Yellow "======================================================================="
