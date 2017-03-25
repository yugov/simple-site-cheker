#!/bin/bash

HOST=$1
URI=$2

NAME=`echo "$HOST$URI" | sed 's/[^a-zA-Z0-9]/_/g'`

RC=0

wget "$HOST$URI" -O /tmp/$NAME -q

sed -i -e 's/></>\n</g' /tmp/$NAME
sed -i -e 's/> </>\n</g' /tmp/$NAME

if [ -f /tmp/$NAME.old ]; then
    diff /tmp/$NAME.old /tmp/$NAME > /tmp/$NAME.difference
    if [[ $? != 0 ]]; then
        sed -i -e 's/^</Deleted -> /g' /tmp/$NAME.difference
        sed -i -e 's/^>/Added -> /g' /tmp/$NAME.difference
        sed -i -e 's/^---/~~~~~~~~~~~~~~~~/g' /tmp/$NAME.difference
        cat /tmp/$NAME.difference
        RC=2
    else
        echo "no changes" 
        RC=0
    fi
else
    echo "old page is not exists" 
    RC=1
fi

mv /tmp/$NAME /tmp/$NAME.old

exit $RC
