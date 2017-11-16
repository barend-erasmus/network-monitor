param(
    [String]$currentNetworkEnvironment
)

$dataPath = Join-Path -Path $PSScriptRoot -ChildPath "data.json" 

function Ping {
    
    param([string]$Server)
         
    $pingable = $false
    $pinger = New-Object System.Net.NetworkInformation.Ping
    
    $reply = $pinger.Send($Server)
    $pingable = $reply.Status -eq "Success"
           
    return $pingable
}


$networkEnvironments = @(
    @{Name = "Azure Mandrake"; Server = "172.16.193.8"; Active = $false; }
)

if (Test-Path $dataPath) {
    $networkEnvironments = Get-Content -Raw -Path $dataPath | ConvertFrom-Json
} else {
    $networkEnvironments | ConvertTo-Json -depth 100 | Out-File $dataPath
    $networkEnvironments = Get-Content -Raw -Path $dataPath | ConvertFrom-Json
}

foreach ($networkEnvironment in $networkEnvironments) {

    $name = $networkEnvironment.Name
    $result = Ping -Server $networkEnvironment.Server

    if ($result -eq $False) {
        if ($networkEnvironment.Active -eq $true) {
            Write-Output "$name is down from $currentNetworkEnvironment"
            $networkEnvironment.Active = $false
        }
    } else {
        if ($networkEnvironment.Active -eq $false) {
            Write-Output "$name is up from $currentNetworkEnvironment"
            $networkEnvironment.Active = $true
        }
    }
}

$networkEnvironments | ConvertTo-Json -depth 100 | Out-File $dataPath
    