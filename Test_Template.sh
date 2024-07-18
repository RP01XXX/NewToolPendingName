#!/bin/bash
# Define color codes for output
RED='\e[31m'
PURPLE='\e[1;95m'
CYAN='\e[1;96m'
WHITE='\e[1;97m'
NC='\033[0m' # No color

#Get Time
current_time=$(date "+%m.%d.%Y")

function flag_usage(){
 echo -e "Usage: Credential_Enumeration.sh -f <${CYAN}Hosts_File>${NC} -c <${CYAN}Client_Name${NC}> -d <${CYAN}Domain Name${NC}>"
 echo # Add a blank line after each function output bash
 echo -e "	${PURPLE}Options:${NC}"
 echo -e "	-f		File of the IP's you want to scan"
 echo -e "	-d		Output Directory"
 echo -e "	-c		Client name to create the directory"
 echo -e "	-d		Organizations Domain"
 echo # Add a blank line after each function output bash
  echo -e " ${WHITE}All options are required for the scan to run${NC}"
}


# Flag Function
while getopts "f:c:h:d:" option; do
  case $option in
    f)
      file_name="$OPTARG"
      ;;
    c)
      client_name="$OPTARG"
      ;; 
    d)
      domain_name="$OPTARG"
      ;;
  esac
done


# Setting the Foldername to an easier variable
FOLDERNAME=$client_name-$current_time

# MAKE THE LOT FOLDER
function make_loot_folder(){
	mkdir $FOLDERNAME
}


function check_required_flags() {
    if [ -z "$file_name" ] || [ -z "$client_name" ] ; then
        echo -e "${RED}Error: Missing required options.${NC}"
        usage
        exit 1
    fi
}

# -------------------------------TEST FUNCTIONS HERE


# -------------------------------SECTION:Function Execution
check_required_flags
echo # Add a blank line after each function output bash
echo # Add a blank line after each function output bash
echo # Add a blank line after each function output bash
flag_usage
echo # Add a blank line after each function output bash
echo # Add a blank line after each function output bash
echo # Add a blank line after each function output bash
make_loot_folder
echo # Add a blank line after each function output bash
echo # Add a blank line after each function output bash
echo # Add a blank line after each function output bash

