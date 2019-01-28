#!/bin/bash

if [ ! -e cow.txt ]; then
	echo "Grabbing banner"
	curl -k https://gist.githubusercontent.com/piratemoo/0caed777e210efc5a65a10574e8be0bd/raw/8b20973ccca7c9abf998aa60294044d2a4450ee7/cow.txt -o ./moo.txt
fi

cat cow.txt

if [ ! -e oui.txt ]; then
echo "No oui.txt found: Creating copy"
curl -k https://linuxnet.ca/ieee/oui.txt -o ./oui.txt
fi

options=(
	"Lookup by oui"
	"Lookup by vendor"
	"Update oui file"
    "Quit"
    )

select option in "${options[@]}"
do
	case "$REPLY" in
		
		1) echo "Enter first octet of oui:"
    	read input;
    	processed=$(echo $input | sed  -e 's/:/-/g')
    	cat oui.txt | grep $processed ;;
        
        2) echo "Enter vendor name:"
    	read input;
    	cat oui.txt | grep $input ;;
        
        3) echo "Update oui file"
    	oldTxt=$(wc -c < oui.txt)
    	newTxt=$(curl -sI https://linuxnet.ca/ieee/oui.txt | awk '/Content-Length/ {sub("\r",""); print $2}')
        
        if [ $oldTxt != $newTxt ]; then
            rm oui.txt
            curl -k https://linuxnet.ca/ieee/oui.txt -o ./oui.txt
        	echo "it's lit fam"
		else
			echo "oui up to date fam"
		fi ;;

        4) break ;;
        *) echo "Please select a valid option"; continue ;;
    esac
done
