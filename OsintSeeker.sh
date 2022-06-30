#!/bin/bash

url=$1

echo "This is your OSINT tool for gathering domain information and emails! Happy Hunting"

if [ ! -d "/home/kali/Desktop/Engagement" ];then
	mkdir "/home/kali/Desktop/Engagement"
fi

echo "Directory Permissions set..."
chmod 777 /home/kali/Desktop/Engagement/

echo "[+] NSLOOKUP is running....."
nslookup $url >> home/kali/Desktop/Engagement/NSLOOKUP.txt

echo "[+] Assetfinder is running....."
assetfinder $url >> /home/kali/Desktop/Engagement/assetFinderOutput.txt


echo "[+] Amass is running, take a breather ;)....."
amass enum -active -d $url -src -ip -dir /home/kali/Desktop/Engagement/ -o /home/kali/Desktop/Engagement/amass_company_1.txt

echo "[+] Sublist3r is running....."
sublist3r -d $url >> /home/kali/Desktop/Engagement/sublist3rOutput.txt

echo "[+] Email gathering from LinkedIn is running....."
python3 crosslinked.py -f '{first}.{last}@domain.com' $url >> /home/kali/Desktop/Engagement/LinkedInEmails.txt

echo "[+]Nikto is running....."
nikto -h $url >> /home/kali/Desktop/Engagement/niktoOutput.txt

echo " The enumeration is done! Now the port scanning begins"
# NMAP will now grep out IPs from amass and export them to a file, that file will then be uploaded for a port scan in NMAP"

grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" amass_company_1.txt | sort -u >>ips.txt

echo "NMAP is scanning  0...0   "
nmap -T4 -A -sV -iL /home/kali/Desktop/Engagement/ips.txt >> /home/kali/Desktop/Engagement/NMAP Results
