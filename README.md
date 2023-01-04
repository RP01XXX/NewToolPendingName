# Summary
These tools are used to make pentesting a little more automatic and easy. Verify  what the client has provided to determine which OSINT tool you use. 
Then move to vulnerability scanning and identification.

1. OSINT-IP-Finder
  This is for tests that only provide IP ranges and you need to scan. This performs your enumeration phases. 
  This is considered done for now. This is run first and then you run OSINT seeker
  
2. OSINT Seeker
  This is for tests where you only have URLS.
  
3. External-Identification
  This performs vulnerability scans, identifies services and parses data, and captures webpages.

  
After tool  3, you would begin your manual work.
  
 
These are all in progress and I would love your opinion on this work to make it better!
# External-Pentest-Checklist
This is a cheat sheet to help teach pentesters how to perform external assessments. I am training and as I grow I will continue to change this document. Please send me input to add to this checklist! This is heavily under construction and I update it daily.

My Process:
Administrative
1. Kickoff ROE and Scoping with Client
2. Outline Scope in Scope Tab
3. Verify Customer Scope with Third Party Tool
4. Send Kickoff Email to client morning of the test

For Below - Step 1 or step 2 are performed in order based off the information the client provides (URL or IP)

# Discovery Step 1: -------------
## Identify all domains/IPs
- If client only provides IP addresses then we use OSINT-IP-Scanner to identify websites.
- Once all URL's are identified run OSINT-URL-Seeker
### NSLookup
- ABOUT: Run a simple nslookup and mxtoolbox scan  of URLs
- CMD: nslookup <url> >> /Desktop/Engagement-<NAME>/NSLOOKUP.txt
## Assetfinder
- Find subdomains
- CMD: assetfinder $url >> /home/kali/Desktop/Engagement-<NAME>/assetFinderOutput.txt
## Amass
- ABOUT: This identifies sudomains
- CMD: amass enum -active -d <URL>  -src -ip -dir <PATHWAY> -o <OUTPUTPATH>
## WhatWeb
- ABOUT: This tool finds HTTP headers, country of IP, HTTP server info, HTTPAPI info and more.
## CRT.sh
- ABOUT:  This tool is a web based domain tool that can be used with different syntax to enumerate  domains. Note you can  automate this tool.

## Grep Out Amass IPs
- ABOUT: This will take the Amass IPs and  pull out the unique IP addresses for the NMAP scans.
- grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $path/$Name/AmassSubDomains.txt | sort -u >> $path/$Name/UniqueIps.txt

# Discovery Step 2: ID ports -------------
## Nmap Work
- ABOUT: ping scan - Perform an NMAP ping scan to identify live hosts and export to a list. Then grep that list and perform a low hanging fruit and full NMAP scan.
- CMD:nmap -sP  $IP -oG - | grep Host | cut -d' ' -f 2 | sort -u > "/$path/Nmap-$Name/PingSweep.txt""
- CMD: Complete  Scan:nmap -A -O -Pn -p- -iL "/$path/Nmap-$Name/PingSweep.txt" -oA  "/$path/Nmap-$Name/NmapIPAll.txt"

### Parse this data to idenify ports, protocols etc.
- https://raw.githubusercontent.com/jasonjfrank/gnmap-parser

## Host resolution
- If you were only given IP addresses  we will want to resolve all IP addresses to websites
dnsrecon -r $IP -t rvl -c "path/Nmap-$Name/Hostnames.txt"
	
## DNS/Networking
### whois
- Either command line or just lookup.icann.org
- nslookup We can lok up the A records, AAA, CNAME, TXT ,SOA if we want.
- CNAME= nslookup -q=cname URL
- TXT = nslookup -q=txt URL
- SOA = nslookup -q=soa URL

###Try a DNS zone transfer
- dig -t AXFR DOMAIN_NAME @DNS_SERVER
- The -t AXFR indicates that we are requesting a zone transfer, while @ precedes the DNS_SERVER that we want to query regarding the records related to the specified DOMAIN_NAME.

### Windows CMD Prompt DNS Transfer
- type nslookup, hit enter
- server IP Address/URL
- ls -d URL

### Dnsrecon zone transfer
- Reverse of host resolution, we may need to get the IP addresses of the URL's by using dnsrecon -d URL   
- dnsrecon zone transfer  with dnsrecond -d URL -t axfr
- dns bruteforce to find domains and hosts dnsrecon -d URL -D DICTIONARY -t brt

### Dig
- Dig website,com@X.X.X.X

### Traceroute
- Run a traceroute to discover hops to identify devices.
	
## Eyewitness
- Run  eyewitness to capture screenshots of login pages for IP's that have port 80/443/8080/8443 open. This list will be uses in login attacks. This needs to be done manually as I cant get bash to work.
-  CMD eyewitness --web -F /home/kali/Desktop/NAME/assetFinderOutput.txt

# Discovery Step 3: Vulnerability Scans-------
## Nessus
- Look into Tenables tool
## Nikto
- Nikto -host <URL>
### wpscan
- Wordpress specific scanner, wpscan URL

What you should have  at this point:
- You should have a listing of all live IP addresses, all URLs, a screenshot of all HTTP(s) pages, subdomains, a port and protocol listing for each host. We want to find usernames/emails associated with the company  as well and then  we can  begin identifying the attack vectors.


# Discovery Step 4: Username and email discovery. THIS SECTION IS IN PROCESS NOW
## The Harvester
- b specifies where we look for the emails
- twitter, google, linkedin, all, dnsudmpsterp, crtsh,certspotter
- CMD: theHarvester -d website -b All
## Hunter.io
## Dehashed
## phonebook.cz
## javascript linkedin scraper
##python email scraper
	they have their own tool in the system. They have an if count ==  100, which goes through a url you specify  and then crawls out until it hits 100 websites and finds emails.
## sherlock
- We use this  tool to further inspect users found from above scans,may provide other usernames
- cmd: python3 sherlock.py <username>

## Office 365 User Identification
### o365spray (https://github.com/0xZDH/o365spray)
- We can use o365spray to test the domain if its real first
- o365spray --validate --domain website.com
- Next lets take any users we have found in OSINT and see if they are real
- o365spray --enum -U usernames.txt --domain domain.com
- Now its time to see if we can get into any accounts without MFA
- o365spray  --spray -U usernames.txt -P passwords.txt --count 2 --lockout 3 --domain test.com
- Flags
- count = how many tries of passwords before lockout
- lockout is the time for lockout time IE in minutes
- --spray-module = oauth, autodiscover, reporting, adfs, activesync
- --output   the file

### 0365enum
- https://github.com/gremwell/o365enum

### MSOLspray
- https://github.com/dafthack/MSOLSpray

### msspray.py


# What is to come	
## Port/Protocol Enumeration and Attacks

## Website Analysis
### Dorking Syntax
- "search phrase" Finds results with this exact phrase
- Words filetype:pdf = looks for PDFs with this term
- salary site:website.com = limits search to website
- pentest -site:website.com = excludes the term from the search
- walk intitle:Website = finds pages with specific term in page title
- challenge inurl:website = finds pages with specific term in URL



- Wappalyzer
- Dirbuster/Dirb/Gobuuster
- Directory Bust ffuf    (403 and 401) attack with /unauth_dir/FUZZ
- Wayback Machine
- Metasploit auxiliary/scanner/http/dir-scanner <DICTIONARY>  (opt/seclists/discovery/Web-content/common.txt)
