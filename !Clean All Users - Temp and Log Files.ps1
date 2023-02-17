(Measure-Command {
###########################################
### Server & Workstation Cleanup Script ###
###              Written by: Brett Webb ###
###                 Created: 23/09/2020 ###
###           Last Modified: 17/02/2023 ###
###########################################
$defaultPath = "C:\Users"
$path = @()
if (($result = Read-Host "Enter the User Profile Path (Default Path: $defaultPath)") -eq '') {$path = $defaultPath} else {$path = $result}
$users = Get-ChildItem $path
$limit = (Get-Date).AddDays(-15)
$output = @()
Write-Host ""
Write-Host -foregroundcolor Yellow  "Clearing local GoToMeeting"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Local\GoToMeeting\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Local\GoToMeeting\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow  "Local Profile Temp Files"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Local\Temp\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow  "Roaming Cookies"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Roaming\Microsoft\Windows\Cookies\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Roaming\Microsoft\Windows\Cookies\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow  "Local Windows Error Reports"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow  "Google Chrome Clean-up"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Roaming\Google\Chrome\User Data\Default\Media Cache\f_*","$path\$user\AppData\Roaming\Google\Chrome\User Data\Default\Cache\f_*","$path\$user\AppData\Local\Google\Chrome\User Data\Default\Cache\f_*","$path\$user\AppData\Local\Google\Chrome\User Data\Default\Media Cache\f_*","$path\$user\AppData\Local\Google\Chrome\User Data\Default\Cookies*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Roaming\Google\Chrome\User Data\Default\Media Cache\f_*","$path\$user\AppData\Roaming\Google\Chrome\User Data\Default\Cache\f_*","$path\$user\AppData\Local\Google\Chrome\User Data\Default\Cache\f_*","$path\$user\AppData\Local\Google\Chrome\User Data\Default\Media Cache\f_*","$path\$user\AppData\Local\Google\Chrome\User Data\Default\Cookies*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow  "Firefox Update Clean-up"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Local\Mozilla\Firefox\updates" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Local\Mozilla\Firefox\updates" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow "Internet Explorers Temporary Internet Files"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($user in $users) {
    $subFolderItems = (Get-ChildItem "$path\$user\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$user" + ": " + ($sum) + " MB")
    Remove-Item -Path "$path\$user\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host -foregroundcolor Yellow "IIS (Inetpub) Logs - 15+ Days"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($i in (Get-ChildItem C:\inetpub\logs\LogFiles\ -ErrorAction SilentlyContinue)) {
    $subFolderItems = (Get-ChildItem C:\inetpub\logs\LogFiles\ -include *.log -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {!($_.PSIsContainer -and $_.CreationTime -lt $limit)} | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$i"  + ": " + ($subFolderItems) + " MB")
}
Write-Host ""
Write-Host -foregroundcolor Yellow "Clearing Windows SBS Monitoring Service Log - Greater than 15 Days"
Write-Host -foregroundcolor Yellow "======================================================================="
foreach ($i in (Get-ChildItem "C:\Program Files\Windows Small Business Server\Logs\MonitoringServiceLogs\" -ErrorAction SilentlyContinue)) {
    $subFolderItems = (Get-ChildItem "C:\Program Files\Windows Small Business Server\Logs\MonitoringServiceLogs\" -include *.log -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {!($_.PSIsContainer -and $_.CreationTime -lt $limit)} | Measure-Object -property length -sum -ErrorAction SilentlyContinue)
    $sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
    $output += $sum
    Write-Host -foregroundcolor Red ("$i" + ": " + ($subFolderItems) + " MB")
}
Write-Host ""
Write-Host -foregroundcolor Yellow "Cleaning C:\Temp"
Write-Host -foregroundcolor Yellow "======================================================================="
$subFolderItems = Get-ChildItem -Path "C:\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue
$sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
Write-Host -foregroundcolor Red ("Temp: " + ($sum) + " MB")
$output += $sum
Remove-Item -Path "C:\Temp\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Write-Host ""
Write-Host -foregroundcolor Yellow "Cleaning C:\Windows\Temp"
Write-Host -foregroundcolor Yellow "======================================================================="
$subFolderItems = Get-ChildItem -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue
$sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
Write-Host -foregroundcolor Red ("Windows Temp: " + ($sum) + " MB")
$output += $sum
#Get-ChildItem -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Write-Host ""
Write-Host -foregroundcolor Yellow "Clearing Windows Prefetch"
Write-Host -foregroundcolor Yellow "======================================================================="
$subFolderItems = Get-ChildItem -Path "Cleaning C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue | Measure-Object -property length -sum -ErrorAction SilentlyContinue
$sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
Write-Host -foregroundcolor Red ("Prefetch: " + ($sum) + " MB")
$output += $sum
#Get-ChildItem -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Write-Host ""
Write-Host -foregroundcolor Yellow "Clearing Windows WER (ProgramData)"
Write-Host -foregroundcolor Yellow "======================================================================="
$subFolderItems = Get-ChildItem "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*" -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {!($_.PSIsContainer -and $_.CreationTime -lt $limit)}
$sum = ("{0:N2}" -f ($subFolderItems.sum / 1MB))
Write-Host -foregroundcolor Red ("Windows WER: " + ($sum) + " MB")
$output += $sum
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
Write-Host ""
#Clear Recycle Bins on all local drives.
Clear-RecycleBin -Force
Write-Host -foregroundcolor Yellow "======================================================================="
Write-Host -foregroundcolor Green ("Total Removed: " + "{0:N2}" -f ($output | Measure-Object -Sum).sum + " MB")
Write-Host Runtime:}).TotalSeconds ## End of Measure-Command.
Write-Host ""
Write-Host -foregroundcolor Yellow "======================================================================="
# DISM.exe /online /Cleanup-Image /spsuperseded