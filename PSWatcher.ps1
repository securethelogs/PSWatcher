   <#
	.SYNOPSIS
		Scan Network Devices

	.DESCRIPTION
		Simple Light Weight Network Scanner For Monitoring Resource

	.NOTES
		Aurthor: https://securethelogs.com
		
#>

      
    # ---------------- Set Variables and Arrays --------------------------------

    $waittime = 400

    $ScanAll = ""  # If you wish to scan all ports, enter True inbetween the ""
        
    $liveports = @()
   
    $destip = @() 
    $usesingle = "securethelogs.com" # Fill this in if you want to do a single scan
    $usetxt = ""    # Fill this in with the location of your text file for multiple scans   
    
      
    $Portarray = @(20,21,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)

    


    #----------------------- Get Destination -----------------------------------------

    if ($usetxt -eq "" -and $usesingle -ne "") {
    
    $destip += $usesingle

    }

    else {
    
    $Listofips = Get-Content $usetxt
    
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

    # If you wish to use Test-Connection instead, remove the # below
    # Test-NetConnection -ComputerName $i -Port $p -InformationLevel Quiet

    
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
    
    $setlog = @{
    LogName = 'Windows PowerShell'
    Source = 'PowerShell'
    EntryType = 'Information'
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

    

    } # For Each $i in DestIP



   


    


    

