## server_automation
## Script does not need to be run as root as all operations (except install) are being done in user home directory!
SS - shortcut of SuperuserShell. This is a bash script I use for connecting to servers in LAN/VPN with SSH Keys and DNS Zone. 

Script must be run with parameters provided below, otherwise <b>IT WILL NOT WORK</b>

<b>ss.sh generate </b>
Running script with this parameter will generate SSH Keys to the defalt location: /home/$user/.ssh/
<b> Please DO NOT change the default directory, otherwise all other functions WILL NOT work. </b>
Also, the script allows user to push first public key to the first server. This is the first, and the last (if it will go fine) time, when you will be using password. 

<b>ss.sh push </b>
Running script with this parameter will push SSH key to desired server. 
There is a pre-check if SSH Key is generated, or not. If not, you will be prompted, to run this script with "generate" parameter. 
Connection check will be done once SSH Key is installed.
<b>ToDo: bulk SSH Key Push for 1+ servers at once </b>

<b> ss.sh connect <IP/FQDN> </b>
Running with this parameter will allow you to connect to server. In this case, as the second parameter, IP Address or FQDN <b>MUST BE</b> given. 
Example: <i> ss.sh connect 10.54.22.3 </i>
If prompted for password - keys are not generated.

<b>ss.sh install </b>
This is a function to install connection script to /usr/bin as "ss". Thanks to it, from every place in the system, you will be able to execute connection script. 
<b>INSTALLED SCRIPT IS ONLY FOR CONNECTING TO SERVERS!!! </b>
There is also a pre-check if SSH Key is installed. 
User can choose if they want to use IP Address and DNS Zone, or DNS-Zone-Only. 
To use IP Address and/or DNS Zone together (if some hosts are not in DNS), DNS Zone query should be left blank. 
If you have a DNS Zone and you want to use ONLY a DNS Zone, you need to provide DNS Zone Name, for example <b> homenet2.pl </b>
In the next step, you will be asked to provide a subdomain. For example, if your host has a subdomain <b>cloud.homenet2.pl</b>, please input <b>cloud</b>.
In the last step, you will be prompted for sudo password, as install script will be created and moved to /usr/bin. Also, execute privileges will be granted. 

<b>NOTE: Installed script will work ONLY on account that run the script. If user is e.g. "bruce", then only bruce will be able to run this script with SSH Key! </b>
