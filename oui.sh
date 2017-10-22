!/bin/bash
 
if [ ! -e oui.txt ];then
    echo "oui.txt not found. Grabbing current copy."
    curl -k http://linuxnet.ca/ieee/oui.txt -o ./oui.txt
fi
 
if [ ! -e cow.txt ];then
    echo "Grabbing Banner"
    curl -k https://gist.githubusercontent.com/piratemoo/0caed777e210efc5a65a10574e8be0bd/raw/7d20aa7f8b02e0a0ec22373259e78b172e75cf84/cow.txt -o ./moo.txt
fi
 
cat cow.txt

options=(
    "Lookup by oui?"
    "Lookup by vendor?"
    "Update OUI?"
    "Quit"
    )
select option in "${options[@]}"
do
    case "$REPLY" in
        1) echo "Enter first octet of oui:"
    read input;
    processed=$(echo $input | sed  -e 's/:/-/g')
    cat oui.txt |grep $processed
    ;;
        2) echo "Enter the vendor name:"
    read input;
    cat oui.txt | grep $input ;;
    3) echo "Update OUI txt file"
    old=$(wc -c < oui.txt)
    new=$(curl -sI http://linuxnet.ca/ieee/oui.txt | awk '/Content-Length/ {sub("\r",""); print $2}')
        if [ $old != $new ]; then
    rm oui.txt
    curl -k http://linuxnet.ca/ieee/oui.txt -o ./oui.txt
        echo "It's lit fam"
    else
        echo "OUI is up to date fam."
    fi
    ;;
    4) break ;;
    *) echo "Please select a valid option" ;;
    esac
done
