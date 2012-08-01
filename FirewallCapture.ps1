param (
	[string] $logPath = "C:\Development\FirewallCapture\pfirewall.log",
	[switch] $monitor
)

function Get-FirewallLog {
param (
	[string] $firewallLogPath
)
	$logArray = Get-Content -Path $logPath |
		ForEach-Object {
			$_.TrimStart()
		} |
		Where-Object {
			($_ -notlike "#*") -and
			($_.TrimStart() -notlike "")
		}
		
	$logArray
}
function Out-FirewallLog {
param (
	[String[]] $firewallLog
)
	Clear-Host
	$allItems = @()

	foreach ($line in $firewallLog) {
		$lineElements = $line.Split(" ")
		$lineObj = New-Object System.Object
		$lineObj | Add-Member -MemberType NoteProperty -Name "Date" -Value $lineElements[0]
		$lineObj | Add-Member -MemberType NoteProperty -Name "Time" -Value $lineElements[1]
		$lineObj | Add-Member -MemberType NoteProperty -Name "Action" -Value $lineElements[2]
		$lineObj | Add-Member -MemberType NoteProperty -Name "Protocol" -Value $lineElements[3]
		$lineObj | Add-Member -MemberType NoteProperty -Name "SrcIp" -Value $lineElements[4]
		$lineObj | Add-Member -MemberType NoteProperty -Name "DstIp" -Value $lineElements[5]
		$lineObj | Add-Member -MemberType NoteProperty -Name "SrcPort" -Value $lineElements[6]
		$lineObj | Add-Member -MemberType NoteProperty -Name "DstPort" -Value $lineElements[7]
		$allItems += $lineObj
	}

	$allItems | 
		Sort-Object -Property Date, Time | 
		Format-Table -AutoSize
}

if ($monitor) {
	while ($true) {
		$myLog = Get-FirewallLog -firewallLogPath $logPath
		Out-FirewallLog -firewallLog $myLog

		Start-Sleep -Seconds 2
	}
}
else {
	$myLog = Get-FirewallLog -firewallLogPath $logPath
	Out-FirewallLog -firewallLog $myLog
}