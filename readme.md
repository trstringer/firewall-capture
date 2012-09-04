#Firewall Capture

## Description

    This PowerShell Script can be used to show the ongoing
    LogEntries of the standard Windows Firewall located in:
    'C:\Windows\System32\LogFiles\Firewall\pfirewall.log'
    The LogEntries can be reloaded every 2 seconds,
    to get a live reading.
    The user can alternatively select another directory through
    parameters.

## Example

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
    
## Documentation

    Documentation for the Script can be found in 'FirewallCapture.ps1' file itself.