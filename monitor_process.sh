#!/bin/bash


param=$1

DIR="$(cd "$(dirname "$0")" && pwd)"
me=`basename "$0"`

scriptFile="$DIR/$me"

processFile=process
if [ ! -f $processFile ]; then
    touch $processFile
fi

cronFileRec=cron_recFile
if [ ! -f $cronFileRec ]; then
    touch $cronFileRec
fi

setTimeCheck(){
    
    echo "Time check [ min h d m y]"
    read timeCheck

    crontab -l | grep -v "no crontab" | awk '{ print $0 }' > $cronFileRec

    local args="-ck"

    echo "$timeCheck $scriptFile $args" >> $cronFileRec

    crontab $cronFileRec
    rm $cronFileRec
}

checkProcess(){

    local checkProcesse=`cat $processFile`
    
    while IFS='' read -r line || [[ -n "$line" ]]; do
        local proc="$line"
        local foundPs=ps al | grep "$proc" | grep -v grep | awk '{ print  $13 }'
        echo $proc
        if [ -z foundPs ]
        then
            $proc &>rec_file
        fi
    done < "$processFile"
    
}

removeAllChecks(){

    local cronTabRec= crontab -l | grep -v "$scriptFile" | awk '{ print $0 }'
    
    $cronTabRec > $cronFileRec

}

addProcess(){

    local proc=$@
    
    echo $proc >>$processFile
}

case $param in
    "-tc")
        setTimeCheck

        ;;
    "-ck")
        checkProcess

        ;;
    "-rm")
        removeAllChecks

        ;;
    "-pa")
        #BAD
        addProcess $2

        ;;
    *)
        ;;
esac

rec(){
 for proc in $checkProcesse
    do
        echo $proc
        local foundPs=ps al | grep proc | grep -v grep | awk '{ print  $13 }'
        if [ -z foundPs ]
        then
            $proc
            echo $proc
        fi
    done
}