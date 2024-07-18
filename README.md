# Summary


### Purpose
The purpose of this tool is to perform our general easy day 1 scans in an automated way.These tools are used to make pentesting a little more automatic and easy. Verify  what the client has provided to determine which OSINT tool you use. Then move to vulnerability scanning and identification.

#### File Structure
We have the Testing_Template.sh, this is what we use to test our initial integrations. Its a stripped version of the code that allows us to test features and functions.


#### Future Integrations
Add additional tools
Recursively perform scans so it uses results to continue more scanning
The outputs are exported into specific folders/files for review so for example: Nmap exports results to HTTP Folder, etc and feeds into eyewitness.
Idk how do we automate our lives.


-----------------------------------------
**TO ADD**
1. ALSO NEED TO ADD THE PREREQS so it installs
2. Add a check that its run as sudo
3. Add the tools below
### Dnsrecon zone transfer
	- dnsrecon zone transfer  with dnsrecond -d URL -t axfr
	- dns bruteforce to find domains and hosts dnsrecon -d URL -D DICTIONARY -t brt
	 - dig -t AXFR DOMAIN_NAME @DNS_SERVER
	- The -t AXFR indicates that we are requesting a zone transfer, while @ precedes the DNS_SERVER that we want to query regarding the records related to the specified DOMAIN_NAME.

### Dig
	- Dig website,com@X.X.X.X
	
## Eyewitness
	- Run  eyewitness to capture screenshots of login pages for IP's that have port 80/443/8080/8443 open. This list will be uses in login attacks. This needs to be done manually as I cant get bash to work.
	-  CMD eyewitness --web -F /home/kali/Desktop/NAME/assetFinderOutput.txt
	
### SSLYZE
	- ssylyze URL
	- This tool has a lot of functionality with its flags, review them with -h.The syntax I provide tests for everything.

## Wpscan
- Wordpress specific scanner, wpscan URL

## Scan for a WAF
- wafw00f <URL>

## Assetfinder
### Find subdomains
	- assetfinder $url >> /home/kali/Desktop/Engagement-<NAME>/assetFinderOutput.txt
## Amass
### ABOUT: This identifies sudomains
	- amass enum -active -d <URL>  -src -ip -dir <PATHWAY> -o <OUTPUTPATH>

## Grep Out Amass IPs
- ABOUT: This will take the Amass IPs and  pull out the unique IP addresses for the NMAP scans.
	grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" $path/$Name/AmassSubDomains.txt | sort -u >> $path/$Name/UniqueIps.txt
	
