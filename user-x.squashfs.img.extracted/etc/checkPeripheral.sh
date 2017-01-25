#! /bin/sh

peripheral_CUR=`cat /dev/mtdblock1 | grep -m 1 ^peripheral=`

if [ -f /mnt/mtd/peripheral.bak ];then
    peripheral_BAK=`cat /mnt/mtd/peripheral.bak | grep -m 1 peripheral`
	if [ "$peripheral_BAK" != "$peripheral_CUR" ];then
		echo peripheral was changed, remove all config!
		echo $peripheral_CUR > /mnt/mtd/peripheral.bak
		rm /mnt/mtd/Config/Config1 -f
		rm /mnt/backup/Config/Config2 -f
	fi
else
	echo $peripheral_CUR > /mnt/mtd/peripheral.bak
fi


