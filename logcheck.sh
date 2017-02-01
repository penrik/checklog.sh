#!/bin/bash

LOGFILE=$1
WORD=$2

OLDSIZE=$(cat "bytes.db")

NEWSIZE=$(stat -c%s "$LOGFILE")
echo "$NEWSIZE" > bytes.db

if (("$NEWSIZE" >= "$OLDSIZE"));
then
        COUNT=`expr $NEWSIZE - $OLDSIZE`
else
        COUNT=$NEWSIZE
fi;

tail -c "$COUNT" "$LOGFILE" | grep --quiet "$WORD"
RES=$?



if [ "$RES" -eq "0" ]; then
        echo CRITICAL
        exit 2
else
        echo OK
        exit 0
fi
