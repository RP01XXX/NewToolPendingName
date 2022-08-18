#!/bin/bash

url=$1
echo ""
echo ""
echo ""
echo ""
echo      "//////////   /////////          //////////    //////    //////////"
echo     "//     ///   //     //          //      //    //  //    //     ///"  
echo    "/////////    /////////  //////  //      //        //        //////"  
echo   "//       //  //                 //      //        //        ///"  
echo  "//       //  //                 //      //        //           "
echo "//       //  //                 //////////    /////////      ///"
echo "---------------------------------------------------------------------------------"
echo ""
echo ""
echo ""
echo ""
echo "This is your OSINT tool for gathering domain information and emails! Happy Hunting"

#This tool performs enumeration for your Penetration test on an external assessment. 
#The tool will create an Engagement-ORG folder, you need to edit it to match where you want it to save
#This will perform basic scans and export to documents. It will also NMAP scan all discovered IP addresses from Amass automatically.
#THIS TOOL IS CURRENTLY BEING BUILT and will eventually skip using other tools and perform it by itself. Please leave any recommendations below!
# Status NSLOOKUP, Assetfinder and Amass are tuned. Crosslinked isnt working nor is sublister.
# Need to add dirb or gobuster (metasploit maybe?, spiderfoot, harvester? Website enumeration like data from pages?

#Change this pathway to your personal location.
if [ ! -d "/home/kali/Desktop/Engagement-$url" ];then
	mkdir "/home/kali/Desktop/Engagement-$url" 
fi

echo "Directory Permissions setting..."
chmod 777 /home/kali/Desktop/Engagement-$url
echo "Directory Permissions Done..."

echo "[+] NSLOOKUP is running....."
nslookup $url >> /home/kali/Desktop/Engagement-$url/NSLOOKUP.txt
echo "NSLOOKUP is Done..."

echo "[+] Assetfinder is running....."
assetfinder $url >> /home/kali/Desktop/Engagement-$url/assetFinderOutput.txt
echo "Assetfinder is Done..."

echo "[+] Amass is running, take a breather ;)....."
amass enum -active -d $url -src -ip -dir /home/kali/Desktop/Engagement-$url -o /home/kali/Desktop/Engagement-$url/AmassSubDomains.txt
rm /home/kali/Desktop/Engagement-$url/amass.log
rm /home/kali/Desktop/Engagement-$url/amass.json
rm /home/kali/Desktop/Engagement-$url/indexes.bolt
echo "Amass is Done..."

echo "[+] Sublist3r is running....."
sublist3r -d $url >> /home/kali/Desktop/Engagement-$url/sublist3rOutput.txt
echo "Sublist3r is Done..."

echo "[+] Email gathering from LinkedIn is running....."
python3 crosslinked.py -f '{first}.{last}@domain.com' $url >> /home/kali/Desktop/Engagement-$url/LinkedInEmails.txt
echo "Crosslinked is Done..."

echo "[+]Nikto is running....."
nikto -h $url >> /home/kali/Desktop/Engagement-$url/niktoOutput.txt
echo "Nikto is Done..."

echo " The enumeration is done! Now the port scanning begins"
# NMAP will now grep out IPs from amass and export them to a file, that file will then be uploaded for a port scan in NMAP"
echo "Port Scanning is Done..."

grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" AmassSubDomains.txt | sort -u >>ips.txt

echo "NMAP is scanning  0...0   "
nmap -T4 -A -sV -iL /home/kali/Desktop/Engagement-$url/ips.txt >> /home/kali/Desktop/Engagement-$url/NMAP Results
echo "NMAP is Done..."

#THIS ISNT WORKING EVEN AS ROOT
sudo chmod 777 home/kali/Desktop/Engagement-$url
