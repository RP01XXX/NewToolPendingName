#!/bin/bash

url=$1

echo "This is your OSINT tool for gathering domain information and emails! Happy Hunting"

#You need to customize the output locations of your directory below

if [ ! -d "/home/kali/Desktop/Engagement" ];then
	mkdir "/home/kali/Desktop/Engagement"
fi

echo "Directory Permissions set..."
chmod 777 /home/kali/Desktop/Engagement/


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
