#! /bin/sh
path='/mnt/mtd/MultiSensor/'				#算法生成文件存放路径
files=""                    			#算法生成文件
distfile='/mnt/mtd/MultiSensor/dist.dat'
spi='/usr/bin/spi'

sensor_rect_info="/mnt/mtd/sensor_rect_info"

base_addr=0x10018000

getPara(){
	para=$(cat $1 | grep $2)
	para=$(echo $para | cut -d ":" -f 2)
	para=${para:0:$((${#para}-1))}		#去掉最后一个换行
	echo $para
}

getHexStr()
{
	value=$1
	bitshift=$((($2-1)*4))
	str='0x'
	while [ $bitshift -ge 0 ]
	do
		v=$((($value>>$bitshift)&0xF))
		if [[ $v -le 9 ]]; then
			str=$str$v
		else
			case $v in
				10)str=$str"a";;
				11)str=$str"b";;
				12)str=$str"c";;
				13)str=$str"d";;
				14)str=$str"e";;
				15)str=$str"f";;
				*);;
			esac
		fi
		bitshift=$(($bitshift-4))
	done
	echo $str
}

printcmd(){
	cmdstring=$spi' 1 '$(getHexStr $1 8)' '$(getHexStr $2 $3)
	echo $cmdstring
}

count='0'

for file in $(ls $path)
do
if [ "${file##*.}" = "dat" ] && [ "${file%%_*}" = "pano" ]; then
        files="$files $file"
		count=$(($count+1))
fi  
done

myhwid=$(gethwid 0)
mydevver=${myhwid##*-}

if [ "${mydevver:0:1}" != "E" ]; then
echo "dev type err"
exit 1
fi

ipcnum=${mydevver:1-1}
if [ $ipcnum != $count ]; then
echo "count is wrong"
exit 1
fi

addr=$(($base_addr+4))
filename=$(echo $files | cut -d " " -f 1)
filename=$path$filename
if [ ! -f "$filename" ];then
	echo "$filename not exist"
	exit 1
fi
scale=$(getPara $filename 'm_scale:')

if [ "3" = $ipcnum ]; then
	printcmd $addr $((($scale<<16)|1)) 8 #最低位1表示水平拼接
	echo "sensor_num=3" > $sensor_rect_info
	echo "montage_type=3x1" >> $sensor_rect_info
elif [ "4" = $ipcnum ]; then
	printcmd $addr $((($scale<<16)|0)) 8 #最低位0表示水平拼接
	echo "sensor_num=4" > $sensor_rect_info
	echo "montage_type=1x4" >> $sensor_rect_info
fi

index=0

for file in $files
do
	filename=$path$file

	if [ ! -f $filename ];then
		echo "$filename not exist"
		exit 1
	fi

	addr=$(($addr+4))
	offsetx=$(getPara $filename 'dst_offset_x:')
	offsety=$(getPara $filename 'dst_offset_y:')
	printcmd $addr $((($offsetx&0xFFFF)|(($offsety&0xFFFF)<<16))) 8

	addr=$(($addr+4))
	height=$(getPara $filename 'm_height:')
	width=$(getPara $filename 'm_width:')
	printcmd $addr $((($width&0xFFFF)|(($height&0xFFFF)<<16))) 8

	echo "rect["$index"]={width:"$(($width&0xFFFF))",height:"$(($height&0xFFFF))"}" >> $sensor_rect_info
	index=$(($index+1))
	
	j=0
	while [ $j -le 8 ]
	do
		addr=$(($addr+4))
		k_rinv=$(getPara $filename "k_rinv\[$j\]:")
		#echo $k_rinv
		mask=0xFFFFF
		printcmd $addr $(($k_rinv&$mask)) 5
		j=$(($j+1))
	done

done


if [ -f $distfile ];then

	addr=$(($base_addr+0x00b8))
	mask=0xFFFFF
	kk="kk_inv_0 kk_inv_2 kk_inv_4 kk_inv_5"
	for parameter in $kk
	do
	kk_inv=$(getPara $distfile $parameter":")
	printcmd $addr $((($kk_inv&$mask))) 6
	addr=$(($addr+4))
	done

	kc0=$(getPara $distfile 'kc0:')
	kc1=$(getPara $distfile 'kc1:')
	kc2=$(getPara $distfile 'kc2:')
	kc3=$(getPara $distfile 'kc3:')
	printcmd $addr $((($kc0&0xFFFF)|(($kc1&0xFFFF)<<16))) 8
	addr=$(($addr+4))
	printcmd $addr $((($kc2&0xFFFF)|(($kc3&0xFFFF)<<16))) 8
	addr=$(($addr+4))

	mf=$(getPara $distfile 'f:')
	printcmd $addr $((($mf&0xFFFF))) 4
	addr=$(($addr+4))

	cc0=$(getPara $distfile 'cc0:')
	cc1=$(getPara $distfile 'cc1:')
	printcmd $addr $((($cc0&0xFFFF)|(($cc1&0xFFFF)<<16))) 8
	addr=$(($addr+4))

	exp=$(getPara $distfile 'exp:')
	printcmd $addr $((($exp&$mask))) 4

fi

echo $spi" 1 0x10000004 0x0" 
echo $spi" 1 0x10000004 0x1" 
echo $spi" 1 0x10000004 0x0"
#fpga裁剪输出4096*900=（h'1000）*(h'384)分辨率" 
#echo $spi" 1 0x10010000 0x10000384"            使用默认的参数，不需要修改-----Li,Xianglin

exit 0
