#!/bin/bash

echo "Enter Your url, do NOT include TLD (www)"
read url

echo "Company Name"
read Name

echo "Location path to save files, this will create  an engagement folder"
read path

echo ""
echo ""
echo ""
echo "This Tools Name is Pending"
echo "---------------------------------------------------------------------------------"
echo "---------------------------------------------------------------------------------"
echo "This is your OSINT tool for gathering domain information and emails! Happy Hunting"

#This tool performs enumeration for your Penetration test on an external assessment. 
#The tool will create an Engagement-ORG folder, you need to edit it to match where you want it to save
#This will perform basic scans and export to documents. It will also NMAP scan all discovered IP addresses from Amass automatically.
#THIS TOOL IS CURRENTLY BEING BUILT and will eventually skip using other tools and perform it by itself. Please leave any recommendations below!
# Status NSLOOKUP, Assetfinder and Amass are tuned. Crosslinked isnt working nor is sublister.
# Need to add dirb or gobuster (metasploit maybe?, spiderfoot, harvester? Website enumeration like data from pages?

#Change this pathway to your personal location.
if [ ! -d "$path/$Name" ];then
	mkdir "$path/$Name/" 
fi

echo "[1/] NSLOOKUP is running....."
nslookup $url >> $path/$Name/NSLOOKUP.txt
echo "NSLOOKUP is Done..."

echo "[1/] Assetfinder is running....."
assetfinder $url >> $path/$Name/assetFinderOutput.txt
echo "Assetfinder is Done..."

echo "[1/]  Whatweb is running......."
whatweb $url --aggression 3 -v --no-errors --log-verbose=$path/$Name/WWebResults.txt

#SSL Scan 
echo "Scanning for SSL Vulnerabilities....."
sslyze $url >> $path/$Name/sslfindings.txt

#Amass Finds all Subdomains and IP addresses, not unique and is grepped out later
echo "[4/] Amass is running, take a breather ;)....."
amass enum -active -d $url -src -ip -dir $path/$Name/ -o $path/$Name/AmassSubDomains.txt
rm $path/$Name/amass.log
rm $path/$Name/amass.json
rm $path/$Name/indexes.bolt
amass viz -d3  -d $url
echo "Amass is Done..."

# DNS Recon Run
echo "[5/] DNS Recon is running.........."
dnsrecon -d $url -a -c $path/$Name/

# DIG
dig $url > $path/$Name/digResults.txt

# The Harvester
echo "[6/] TheHarvester is running............."
theHarvester -d <URL> -l 200 -b bing,bingapi,certspotter,dnsdumpster,sublist3r,urlscan,virustotal -f $path/$Name/Harvested.txt

echo "Cleaning up your results"

echo "identify unique IP's from  Amass"
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $path/$Name/AmassSubDomains.txt | sort -u >> $path/$Name/UniqueAmassIps.txt
rm $path/$Name/AmassSubDomains.txt

echo "identify unique IP's from  NSLOOKUP"
grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $path/$Name/NSLOOKUP.txt | sort -u >> $path/$Name/NSIPs.txt
rm $path/$Name/NSLOOKUP.txt


#This stops here as you need to verify if all IPs found are in scope or not.

echo "Directory Permissions setting..."
chmod 777 $path/$Name/*
cd $path/$Name/
echo "Directory Permissions Done..."
