#! /bin/sh

#���ԵĿ��Ź����ʱʱ��ֻ��65�룬������sonia����ǰ��ιһ�ι�
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
while [ 1 ] #�ȿ��ų�ʱ����
do
	busybox sleep 60
done
