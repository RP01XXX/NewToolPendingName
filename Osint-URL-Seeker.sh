#!/bin/bash

echo "Enter Your url"
read url

echo "Company Name"
read Name

echo "Save Path"
read Path

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

echo "[+] NSLOOKUP is running....."
nslookup $url >> $path/$Name/NSLOOKUP.txt
echo "NSLOOKUP is Done..."

echo "[+] Assetfinder is running....."
assetfinder $url >> $path/$Name/assetFinderOutput.txt
echo "Assetfinder is Done..."

echo "[+]  Whatweb is running......."
whatweb $url --aggression 3 -v --no-errors --log-verbose=$path/$Name/WWebResults.txt

#Amass Finds all Subdomains and IP addresses, not unique and is grepped out later
echo "[+] Amass is running, take a breather ;)....."
amass enum -active -d $url -src -ip -dir $path/$Name/ -o $path/$Name/AmassSubDomains.txt
rm $path/$Name/amass.log
rm $path/$Name/amass.json
rm $path/$Name/indexes.bolt
echo "Amass is Done..."

#Nikto Vulnerability Scan
echo "[+]Nikto is running....."
nikto -h $url >> $path/$Name/niktoOutput.txt
echo "Nikto is Done..."

#We need to now grep out all IP addresses from an NMAP scan, then use eyewitness to scan the IP folder

#aquatone?


#THIS IS IN PROGRESS
#CRT.SH searching for interesting subdomain Locations, I would like to take the outputs of Amass and play here more as an input.
#curl -s https://crt.sh/?q=$url > /home/kali/Desktop/Engagement-$Name/crtfirst.txt
#cat /home/kali/Desktop/Engagement-$Name/crtfirst.txt | grep $TARGET | grep TD | sed -e 's/<//g' | sed -e 's/>//g' | sed -e 's/TD//g' | sed -e 's/\///g' | sed -e 's/ //g' | sed -n '1!p' | sort -u > /home/kali/Desktop/Engagement-$Name/$TARGET-crt.txt
#curl -s https://crt.sh/?q=*.$url > /home/kali/Desktop/Engagement-$Name/crtsecond.txt
#cat /home/kali/Desktop/Engagement-$Name/crtsecond.txt | grep $TARGET | grep TD | sed -e 's/<//g' | sed -e 's/>//g' | sed -e 's/TD//g' | sed -e 's/\///g' | sed -e 's/ //g' | sed -n '1!p' | sort -u > /home/kali/Desktop/Engagement-$Name/$TARGET-crt2.txt

#Can I copy all file data and place into 1 file and then delete the file left over to have 1 file?
#rm /home/kali/Desktop/Engagement-$Name/crtfirst.txt 
#rm /home/kali/Desktop/Engagement-$Name/crtsecond.txt 

echo "Directory Permissions setting..."
chmod 777 $path/$Name/*
cd $path/$Name/
echo "Directory Permissions Done..."

