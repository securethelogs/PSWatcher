# PSWatcher

![PSwatcher](https://ctrla1tdel.files.wordpress.com/2020/04/pswatcher.gif)

## About
PSWatcher is a free solution which can help monitor your network devices.

## To Run
Simple download the script and run. 
To execute remotely, run: iex(New-Object Net.Webclient).DownloadString("https://raw.githubusercontent.com/securethelogs/PSWatcher/master/PSWatcher.ps1")

The process is now automated and will run through the following: 

- How and what we are scanning
- Creating the PSWatcher script
- Creating the Scheduled Task to run the PSWatcher script
- Generate an initial report to show live ports
- Once the task has ran, it will also create Win events (ID:1111)

There is some manual input required. This is simply the scheduled task and how you wish to run it.

## Help
More information can be found here: https://securethelogs.com/pswatcher-3/


