

$logo = @('
__________  _________                __         .__                  
\______   \/   _____/_  _  _______ _/  |_  ____ |  |__   ___________ 
 |     ___/\_____  \\ \/ \/ /\__  \\   __\/ ___\|  |  \_/ __ \_  __ \
 |    |    /        \\     /  / __ \|  | \  \___|   Y  \  ___/|  | \/
 |____|   /_______  / \/\_/  (____  /__|  \___  >___|  /\___  >__|   
                  \/              \/          \/     \/     \/       
                  
Creator: https://securethelogs.com / @securethelogs
                  ')

$logo


Write-Output ""

# ------ Get What We Are Scanning --------------

Write-Output "What are we scanning? "
Write-Output ""

Write-Output "Option 1: Single host"
Write-Output "Option 2: Multiple hosts"
Write-Output ""

$cmps = Read-Host -Prompt "Option"

$cmpsingle = $null
$cmplist = $null
$d = "$" 

if ($cmps -eq "1"){$cmpsingle = @(Read-Host -Prompt "Enter IP/URL")}
if ($cmps -eq "2"){$cmplist = @(Read-Host -Prompt "Enter File Location (C:\Temp\scan_list.txt) ")}else{}




# ------ Get What Ports We Are Scanning -----------------


Write-Output ""
Write-Output "Should we scan all ports or most common?"
Write-Output ""

Write-Output "Option 1: All ports"
Write-Output "Option 2: Common ports"
Write-Output ""

$ports = Read-Host -Prompt "Option"

if ($ports -eq "1"){$ScanAll = "True"}else{$ScanAll = $null}



# ------------ pass values to scripts -------

Write-Output ""
Write-Output "Please select a location to run and store PSwatcher "

$scriptloc = Read-Host -Prompt "Location to save files"

if ($scriptloc.EndsWith("\") -eq "True"){$scriptloc = $scriptloc + "PSWatcher.ps1"}else{$scriptloc = $scriptloc + "\PSWatcher.ps1"}

$tp = Test-Path -Path $scriptloc


if ($tp -eq "True"){Remove-Item -Path $scriptloc}


New-Item -Path $scriptloc.Replace("\PSWatcher.ps1","") -Name "PSWatcher.ps1" -ItemType "file"


Add-Content -Path $scriptloc -Value ($d + "cmplist" + " = " + '"' + $cmplist + '"')
Add-Content -Path $scriptloc -Value ($d + "cmpsingle" + " = " + '"' + $cmpsingle + '"')
Add-Content -Path $scriptloc -Value ($d + "ScanAll" + " = " + '"' + $ScanAll + '"')






$pswatcher = @('


    $waittime = 400

            
    $liveports = @()
   
    $destip = @() 
    
    
      
    $Portarray = @(20,21,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
      

    #----------------------- Get Destination -----------------------------------------

    if ($cmplist -eq "" -and $cmpsingle -ne "") {
    
    $destip += $cmpsingle

    }

    if ($cmplist -ne "" -and $cmpsingle -eq "") {
    
        
    $Listofips = Get-Content $cmplist
    
    foreach ($ip in $Listofips) {

    $destip += $ip 

    }

    }

    #----------------------- Get Ports -----------------------------------------

    if ($ScanAll -eq "True") {
    
    $Portarray = 1..65535 

    }


    #----------------------- SCAN -----------------------------------------

    foreach ($i in $destip){ # Scan every destination


    foreach ($p in $Portarray){ # .... and each port


    $TCPObject = new-Object system.Net.Sockets.TcpClient

    $Result = $TCPObject.ConnectAsync($i,$p).Wait($waittime)

     
    if ($Result -eq "True") {
    
    $liveports += $p  

    }


    } # For each Array

    # --------------- Show Known Ports ------------------------------


    $Knownservices = @("")
    
    $ftp = "     Port: 20,21     Service: FTP"
    $http = "     Port: 80     Service: HTTP"
    $https = "     Port: 443     Service: HTTPS"
    $ssh = "     Port: 22     Service: SSH"
    $telnet = "     Port: 23     Service: Telnet"
    $smtp = "     Port: 25     Service: SMTP"
    $ipsec = "     Port: 50,51     Service: IPSec"
    $dns = "     Port: 53     Service: DNS"
    $pop3 = "     Port: 110     Service: POP3"
    $netbios = "     Port: 135-139     Service: NetBIOS"
    $imap4 = "     Port: 143     Service: IMAP4"
    $snmp = "     Port: 161,162     Service: SNMP"
    $ldap = "     Port: 389     Service: LDAP"
    $smb = "     Port: 445     Service: SMB"
    $ldaps = "     Port: 636     Service: LDAPS"
    $rpc = "     Port: 1025     Service: Microsoft RPC"
    $sql = "     Port: 1433     Service: SQL"
    $rdp = "     Port: 3389     Service: RDP"
    $winrm = "     Port: 5985,5986     Service: WinRM"
    $proxy = "     Port: 8080     Service: HTTP Proxy"
    $webmin = "     Port: 10000     Service: Webmin"
        

    if ($liveports -contains "20" -or $liveports -contains "21"){$knownservices += $ftp}
    if ($liveports -contains "22"){$knownservices += $ssh}
    if ($liveports -contains "23"){$knownservices += $telnet}
    if ($liveports -contains "50" -or $liveports -contains "51"){$knownservices += $ipsec}
    if ($liveports -contains "53"){$knownservices += $dns}
    if ($liveports -contains "80"){$knownservices += $http}
    if ($liveports -contains "110"){$knownservices += $pop3}
    if ($liveports -contains "135" -or $liveports -contains "136" -or $liveports -contains "137" -or $liveports -contains "138" -or $liveports -contains "139"){$knownservices += $netbios}
    if ($liveports -contains "143"){$knownservices += $IMAP4}
    if ($liveports -contains "161"-or $liveports -contains "162"){$knownservices += $snmp}
    if ($liveports -contains "389"){$knownservices += $ldap}
    if ($liveports -contains "443"){$knownservices += $https}
    if ($liveports -contains "445"){$knownservices += $smb}
    if ($liveports -contains "636"){$knownservices += $ldaps}
    if ($liveports -contains "1025"){$knownservices += $rpc}
    if ($liveports -contains "1433"){$knownservices += $sql}
    if ($liveports -contains "3389"){$knownservices += $rdp}
    if ($liveports -contains "5985" -or $liveports -contains "5986"){$knownservices += $winrm}
    if ($liveports -contains "8080"){$knownservices += $proxy}
    if ($liveports -contains "10000"){$knownservices += $webmin}
    

    # Get services and time of scan

    $foundservices = $Knownservices | Out-String 
    $time = Get-Date -Format "dddd MM/dd/yyyy HH:mm"


    

    #------------------------------------ Create Windows Event --------------------------------------------------

    $logname = "Windows PowerShell"
    $source = "PowerShell"
    $entryType = "Information"
    
    $setlog = @{
    LogName = $logname
    Source = $source
    EntryType = $entryType
    EventId = 1111 
    Message = "

     Event Created By PSWatcher! 

     Creator: https://securethelogs.com / @securethelogs

     -----------------------

     Destination: $i 
     Scan Time: $time
                    
     -----------------------

     The Following Known Services Are Reachable:
                $foundservices
               
     Ports Open: $liveports
    
      
    "
}


Write-EventLog @setlog

    
    #Clear Array for next
    $liveports = @()

    

    }  


')


Add-Content -Path $scriptloc -Value $pswatcher



# ---------- Add the task ----------------



Write-Output ""
Write-Output "Let's setup the task to run.... Remember to change after completion."
Write-Output ""

 

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $scriptloc

$trigger =  New-ScheduledTaskTrigger -Daily -At "9am"


try{Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "PSWatcher" -Description "PSWatcher"}catch{echo "Failed to add task"}
 


Write-Output "Running initial report....."
Write-Output "Scanning hosts....."





    $intscan = @()
    $destip = @() 
    
   
      
    $Portarray = @(20,21,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
      

    #----------------------- Get Destination -----------------------------------------

    if ($cmplist -eq $null -and $cmpsingle -ne "") {
     
    $destip += $cmpsingle

    }

    if ($cmplist -ne "" -and $cmpsingle -eq $null) {
            
    $Listofips = Get-Content $cmplist
    
    foreach ($ip in $Listofips) {

    $destip += $ip 

    }

    }


    #----------------------- SCAN -----------------------------------------

    foreach ($i in $destip){ # Scan every destination

    $intscan += "Hostname: " + "<b>" + $i + "</b>"


    foreach ($p in $Portarray){ # .... and each port


    $TCPObject = new-Object system.Net.Sockets.TcpClient

    $Result = $TCPObject.ConnectAsync($i,$p).Wait("400")

     
    if ($Result -eq "True") {
    
    $intscan += "Port: " + $p  
    

    }


    } # For each port


    $intscan += " "





    } # For each ip


Write-Output "Generating the report....."

 
 $scriptloc = $scriptloc.Replace("\PSWatcher.ps1","\reports.html")
 $nscriptloc = $scriptloc.Replace("reports.html","")

 $isfile = Get-Item -Path $scriptloc -ErrorAction SilentlyContinue

 if ($isfile -ne $null){Remove-Item -Path $scriptloc -Force}



 New-Item -Path $nscriptloc -Name "reports.html"

   $htmlstart = @('

<!DOCTYPE html>
<html lang="en">
<head>
<title>PSWatcher Report</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
/* Style the body */
body {
  font-family: Arial;
  margin: 0;
}

/* Header/Logo Title */
.header {
  padding: 60px;
  text-align: center;
  background: #1abc9c;
  color: white;
  font-size: 30px;
}

/* Page Content */
.content {padding:20px;}

.scan {
    padding:20px;
    line-height: normal;
}

</style>
</head>
<body>

<div class="header">
  <h1>PSWatcher Report</h1>

</div>

<div class="content">
  <h1>Your Results</h1>
  <p><b>What Am I Seeing?</b></p>
  <p>Below are the hosts that have been scanned and the ports which are open.</p>
  

  <p>

    
   ')

   

   Add-Content -Path $scriptloc -Value $htmlstart


   
   foreach ($l in $intscan){

   $l = "<br>"+ $l
   Add-Content -Path $scriptloc -Value $l
   }
    
    $htmlend = @('
    </p>

    <p>For more information, visit: <a href="https://securethelogs.com">Securethelogs.com</a></p>

    </div>
    
    
    </body>
    </html>

    ')
    
    Add-Content -Path $scriptloc -Value $htmlend

    Invoke-Item $scriptloc

