<#

.SYNOPSIS
    Captures the LogEntries of the standard Windows Firewall

.DESCRIPTION
    This PowerShell Script can be used to show the ongoing
    LogEntries of the standard Windows Firewall located in:
    'C:\Windows\System32\LogFiles\Firewall\pfirewall.log'
    Alternatively the LogEntries can be reloaded every 2 seconds,
    to get a live reading.
    
.PARAMETER logPath
    Alternate Path to the Windows Firewall LogFile
    Default :: C:\Windows\System32\LogFiles\Firewall\pfirewall.log

.PARAMETER monitor
    boolean value (true/false) if LogEntries should be reloaded every
    2 seconds
    Default :: false

.EXAMPLE
    .\FirewallCapture.ps1 C:\Windows\System32\LogFiles\Firewall\pfirewall.log true
    Date       Time     Action           Protocol   SrcIp         DstIp           Src Port
    ----       ----     ------           --------    -----         -----           ---
    2005-04-11 08:05:57 DROP             UDP      123.45.678.90 255.255.255.255     163
    2005-04-11 08:05:57 DROP             UDP      123.45.678.90 123.456.78.255      137
    2005-04-11 08:05:58 DROP             UDP      123.45.678.90 123.456.78.255      138
    2005-04-11 08:05:58 OPEN             UDP      123.45.678.90 123.456.78.90       500
    2005-04-11 08:06:02 CLOSE            UDP      123.45.678.90 123.456.78.90       137
    2005-04-11 08:06:02 CLOSE            UDP      123.45.678.90 123.456.78.90       102
    2005-04-11 08:06:05 DROP             UDP      0.0.0.0       255.255.255.255     68
    2005-04-11 08:06:26 DROP             TCP      123.45.678.90 123.456.78.90       80
    2005-04-11 08:06:27 DROP             TCP      123.45.678    90                  123
    2005-04-11 08:08:58 DROP             ICMP     123.45.678.90 123.456.78.90       7
    2005-04-11 08:09:29 OPEN             TCP      123.45.678.90 123.456.78.90       160
    2005-04-11 08:09:30 CLOSE            TCP      123.45.678.90 123.456.78.90       160
    2005-04-11 08:48:46 DROP             TCP      123.45.678.90 123.456.78.90       80
    2005-04-11 08:48:46 DROP             TCP      123.45.678.90 123.456.78.90       80
    2005-04-11 08:52:26 INFO-EVENTS-LOST -        -             -                   -

    Example LogFile taken from: http://technet.microsoft.com/en-us/library/cc758040(v=ws.10).aspx
    
.NOTES
    File Name: FirewallCapture.ps1
    Creation Date: 05.08.2012
    
    Author: Ritchie 'Xenplex' Flick
    Github Page: https://github.com/Xenplex
    Repository:  https://github.com/Xenplex/FirewallCapture
    
    Original Author: Thomas 'trstringer' Stringer
    Github Page: https://github.com/trstringer
    Forked from: https://github.com/trstringer/FirewallCapture
#>

<#
 *
 * SCRIPT PARAMETERS *
 *
#>
param (
	[string] $logPath = "C:\Windows\System32\LogFiles\Firewall\pfirewall.log",
	[switch] $monitor
)

<#
 *
 * FUNCTION DEFINITIONS *
 *
#>
<#
	Name:'Get-FirewallLog'
	Creation date: 05.08.2012
	Description: This function is used to filter out comment lines inside the log File
    as for example: '#Software: Microsoft Windows Firewall'
#>
function Get-FirewallLog {
param (
	[string] $firewallLogPath
)
    <#
        Get-Content gets the content of the LogFile
        ->
        The ForEach-Object goes over all elements(objects) and removes with TrimStart() all
        whitespace from the beginning of a string
        ->
        The Where-Object goes over all elements(objects) (which it gets from ForEach-Object) and
        if at the beginning of a line there isn't a # or * (Which would indicate a comment line)
        and if TrimStart() doesn't return an empty line, then the element gets saved in $logArray
    #>
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

<#
	Name:'Out-FirewallLog'
	Creation date: 05.08.2012
	Description: This function takes the elements from its parameter and
    seperates each element after a whitespace.
    Every element becomes a Noteproperty and gets a name and gets saved into a
    temp variable
    All temp variables are getting saved together into $allItems and then displayed
#>
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

<#
	Name:'Check-LogFile'
	Creation date: 05.08.2012
	Description: Check-LogFile checks if LogFile is at the specified path and if it's empty or not
#>
function Check-LogFile {
param (
    [String[]] $logFile
    )
    
    $existence = Test-Path $logFile
    if ($existence) {
        $result = (Get-Content $logFile) -eq $Null
    }
    else {
        $result = $true
    }
    $result
}

<#
 *
 * MAIN EXECUTION *
 *
#>
$Check = Check-LogFile -logFile $logPath
if ($Check) {
    "Log File is empty or doesn't exist, can't check LogFile"
    "Closing script"
    exit
}
else {
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
}