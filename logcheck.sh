#!/bin/bash

LOGFILE=$1
WORD=$2

CHECKSUM=$(echo "$LOGFILE" | md5sum | cut -c 1-8)
OLDSIZE=$(cat $CHECKSUM.db)

NEWSIZE=$(stat -c%s "$LOGFILE")
echo "$NEWSIZE" > $CHECKSUM.db

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
