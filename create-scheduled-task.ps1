param(
    [String]$environment,
    [string]$username,
    [string]$password
)

$scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "network-monitor.ps1"

$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-ExecutionPolicy Bypass `"$scriptPath`" '$environment'";
$Trigger = New-ScheduledTaskTrigger -Once -At '8AM' -RepetitionInterval (New-TimeSpan -minutes 10) -RepetitionDuration ([TimeSpan]::MaxValue);
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings (New-ScheduledTaskSettingsSet);
$Task | Register-ScheduledTask -TaskName "Network Monitor" -User $username -Password $password;