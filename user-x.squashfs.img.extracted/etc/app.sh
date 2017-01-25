#! /bin/sh

#安霸的看门狗最大超时时间只有65秒，所以在sonia启动前先喂一次狗
echo f > /proc/osa_root/pdc/pdcWdt
echo 1048576 > /proc/sys/net/core/wmem_max
echo 6093 16384 1048576 > /proc/sys/net/ipv4/udp_mem 
echo 6093 16384 1048576 > /proc/sys/net/ipv4/tcp_mem 

oldDBFile="/mnt/mtd/Config/intell/numstathour.db"
if [ -e "$oldDBFile" ]
then
	echo "numstathour.db exist"
	mv /mnt/mtd/Config/intell/numstathour.db /mnt/mtd/Config/intell/intelli.db
fi

#VIDEOENV=`cat /var/tmp/videoEnv`
/usr/bin/sonia

state=$?
echo "####application exit:${state}, system will reboot!"
/usr/bin/exittime ${state}
while [ 1 ] #等看门超时重启
do
	busybox sleep 60
done
