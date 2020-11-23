#!/bin/bash

##Script to generate, push and connect using SSH Keys.

##Usage:
## ss generate --> generate Keys
## ss push {target} --> push Keys
## ss connect {target} --> connect using SSH Keys
## ss install --> install script to /usr/bin to allow you to connect without ./ or pointing location.

## To add domain.

#user = `whoami`
echo "This script is run as $USER"
echo "Please note, that keys are being generated for ROOT user on target server"
case $1 in
  "generate")
      echo "Generating SSH Keys. Please answer for few questions, DO NOT CHANGE the SSH Keys location"
      /usr/bin/ssh-keygen -t rsa
      read -p "Keys have been generated, do you want to push them to the first server? (y/n):   " pushdecision
      case $pushdecision in
        "y")  read -p  "Please enter IP or FQDN of Server/Machine" host
              echo "Pushing Keys. Please provide password when prompted"
              /usr/bin/ssh-copy-id -i /home/$USER/.ssh/id_rsa.pub root@$host
              echo "Keys pushed successfully, testing connection. Hostname in output below means connection is fiine"
              for srv in $host; do echo $host:; ssh -i /home/$USER/.ssh/id_rsa root@$srv hostname; done
              echo "Action completed, exiting. "
              exit 1;;
        "n")  exit 1;;
        "*")  echo "Unknown option, exiting"
              exit 1;;
      esac ;;

  "push")
    if [ -f /home/$USER/.ssh/id_rsa ];
      then
          echo "Please enter IP or FQDN of Server/Machine"
          read -p host
          echo "Pushing Keys. Please provide password when prompted"
          /usr/bin/ssh-copy-id -i /home/$USER/.ssh/id_rsa.pub root@$host
          echo "Keys pushed successfully, testing connection."
          for srv in $host; do echo $host:; ssh -i /home/$USER/.ssh/id_rsa root@$srv hostname; done
          echo "Action completed, exiting. "
          exit 1
        else
          echo "Keys not found. Please run this script with parameter GENERATE"
    fi
    exit 1;;
  "connect")
      /usr/bin/ssh -i /home/$USER/.ssh/id_rsa root@$2
      exit 1;;
  "install")
      echo "Checking if SSH Keys are installed. "
        if [ -f /home/$USER/.ssh/id_rsa ];
          then
            echo "If you have a DNS Zone, script will use subdomains for your DNS Zone, for example dns.homenet2.pl, git.homenet2.pl"
            read -p "Do you want to use only a DNS Zone in your network? If yes, write it down, for example homenet2.pl. Otherwise, leave it empty:  " zone
       
            if [ -z "$zone" ]; then #if zone is empty - no dns
              ###Create script
              read -p  "Enter IP Address of target Server" srvip
              
              echo " #!/bin/bash
              /usr/bin/ssh -i /home/$USER/.ssh/id_rsa root@$srvip" >> /home/$USER/ss
              echo "Now you will be asked for root privileged (if not root). This is required to copy script to /usr/bin"
              sudo mv /home/$USER/ss /usr/bin
              sudo chmod +x /usr/bin/ss
              echo "Script installed."
            else #if DNS Zone provided
              echo "Enter FQDN without domain"
              read -p  "Example: if your subdomain is cloud.homenet2.pl, enter cloud:  " subfqdn
              echo " #!/bin/bash
              /usr/bin/ssh -i /home/$USER/.ssh/id_rsa root@$subfqdn.$zone" >> /home/$USER/ss
              echo "Now you will be asked for root privileged (if not root). This is required to copy script to /usr/bin"
              sudo mv /home/$USER/ss /usr/bin
              sudo chmod +x /usr/bin/ss
              echo "Script installed."
            fi
          else echo "No Keys Found. To generate keys, please run this script with generate parameter. "
          fi
          exit 1;;

  *) echo "Unknown Option. USAGE:"
        echo "ss <generate|push|connect>"
        echo "ss <connect> <host>"
        exit 1;;
  esac
