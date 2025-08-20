$agentType = "2"
$agentVersion = "7.4"
$tempFilesDir = "C:\Temp"
$logFile = "$tempFilesDir\zabbix_agent2_install.log"
$agentUri = "https://cdn.zabbix.com/zabbix/binaries/stable/$agentVersion/latest/zabbix_agent$agentType-$agentVersion-latest-windows-amd64-openssl.msi"
$outFile = "$tempFilesDir\zabbix_agent$agentType-$agentVersion-latest-windows-amd64-openssl.msi"

$computerName=$env:COMPUTERNAME
$server = "SERVER=10.24.0.101,10.24.0.102"
$serverActive = "SERVERACTIVE=10.24.0.101;10.24.0.102"
$timeout = "TIMEOUT=30"
$hostname="HOSTNAME=$computerName"
$hostMetadata="HOSTMETADATA=SRV-WINDOWS"

function installZabbix {
    if (Get-Service -Name "Zabbix Agent","Zabbix Agent 2" -ErrorAction SilentlyContinue) {
        exit
    }
    
    else {
        if (-not (Test-Path "$tempFilesDir")) {
            New-Item -Path "$tempFilesDir" -ItemType Directory | Out-Null
        }

        try {
            Invoke-WebRequest -Uri $agentUri -OutFile $outFile
        }
        catch {
        exit 1
        }
        msiexec /i $outFile /quiet /norestart /l*v "$logFile" $server $serverActive $timeout $hostname $hostMetadata
    }
}

installZabbix