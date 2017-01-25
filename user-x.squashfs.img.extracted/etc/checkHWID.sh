#! /bin/sh

HWID_CUR=`cat /proc/dahua/bootpara | grep -m 1 ^HWID:`

if [ -f /mnt/mtd/HWID.bak ];then
    HWID_BAK=`cat /mnt/mtd/HWID.bak | grep -m 1 HWID`
	if [ "$HWID_BAK" != "$HWID_CUR" ];then
		echo HWID was changed, remove all config!
		echo $HWID_CUR > /mnt/mtd/HWID.bak
		rm /mnt/mtd/Config/Config1 -f
		rm /mnt/backup/Config/Config2 -f
	fi
else
	echo $HWID_CUR > /mnt/mtd/HWID.bak
fi


