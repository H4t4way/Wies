#!/bin/bash

echo "                           "
echo "  __        ___            "
echo "  \ \      / (_) ___  ___  "
echo "   \ \ /\ / /| |/ _ \/ __| "
echo "    \ V  V / | |  __/\__ \ "
echo "     \_/\_/  |_|\___||___/ "
echo "                           "

domain=$1
RED='\033[0;31m'
NC='\033[0m'
printf "\n${RED}Searching with Sublister${NC}"
python3 ~/tools/Sublist3r/sublist3r.py -d $domain -o domainsublister.txt &>/dev/null
printf "\n${RED}Searching with Assetfinder${NC}"
assetfinder --subs-only $domain > domainasset.txt &>/dev/null
printf "\n${RED}Searching with Subfinder${NC}"
subfinder -d $domain -o domainsubfinder.txt &>/dev/null
printf "\n${RED}Searching with Turbolister${NC}"
python3 ~/tools/Turbolist3r/turbolist3r.py  -d $domain -o domainturbo.txt &>/dev/null
sleep 1
printf "\n${RED}Mergin the Results${NC}\n\n"
sleep 2
cat domainsublister.txt >domainp.txt
cat domainasset.txt  >> domainp.txt
cat domainsubfinder.txt >>domainp.txt
cat domainturbo.txt >> domainp.txt
sort domainp.txt | uniq -u >> domain1
rm -r domainsublister.txt | rm -r domainasset.txt | rm -r domainsubfinder.txt | rm -r domainturbo.txt | rm -r domainp.txt
printf "\n${RED}Running Httprobe...${NC}\n\n"
cat domain1 | httprobe -t 2000 | tee domain  &>/dev/null
printf "\n\n${RED}Skimming....${NC}\n\n"
sleep 2
CUR_PATH=$(pwd)
mkdir accepted
mkdir denied
mkdir notfound
mkdir  mixt
mkdir -p accepted/javascriptfiles
while read line; do
        code=$( curl --write-out "%{http_code}\n" --output /dev/null --silent --insecure $protocollo$line )
        if [[ "$code" == "200"  || "$code" == "202" || "$code" == "204" || "$code" == "301" || "$code" == "302" ]]; then
                echo "$protocollo$line : HTTP $code"
                echo "$protocollo$line" >> $CUR_PATH/accepted/hosts
                filename=$(echo "$line" | md5sum | awk '{print $1}')
                filename="accepted/javascriptfiles/$filename"
                curl -s -X GET -L  $line | grep -Eoi "src=\"[^>]+></script>" | cut -d '"' -f  2  >> "$filename"
                echo "$filename $line : HTTP $code " >> accepted/javascriptfiles/index
        fi
        if [[ "$code" = "400"  || "$code" == "401" || "$code" == "405"  || "$code" == "406" ]]; then
                echo "$protocollo$line : HTTP $code"
                echo "$protocollo$line" >> $CUR_PATH/denied/hosts
        fi
        if [ $code = "404" ];then
                echo "$protocollo$line : HTTP $code"
                echo "$protocollo$line" >> $CUR_PATH/notfound/hosts
        fi
        if [[  "$code" != "200" &&  "$code" != "204" && "$code" != "202" && "$code" != "301" && "$code" != "302" && "$code" != "400" && "$code" != "401" && "$code" != "403" && "$code" != "404"  ]]; then
                echo "$protocollo$line" >> $CUR_PATH/mixt/hosts
        fi

done < domain
rm -r domain1
printf "\n${RED}Extracting the Js files from all Subdomains${NC}\n"
mkdir -p javascriptfiles
CUR_PATH=$(pwd)
while read line1; do
        filename=$(echo "$line1" | md5sum | awk '{print $1}')
        filename="javascriptfiles/$filename"
        curl -s -X GET -L  $line1 | grep -Eoi "src=\"[^>]+></script>" | cut -d '"' -f  2  >> "$filename"
        echo "$filename $line1 : HTTP $codice " >> javascriptfiles/index

done < domain

printf "\n${RED}End...${NC}\n"
sleep 1
