#! /bin/sh

count=1

while [ $count -lt 10 ]
do
	fpga_status=$(spi 0 0x10000010)
	fpga_status=${fpga_status##*Value: 0x}

	if [ "$fpga_status" == "a5a5" ]; then
		build_date=$(spi 0 0x10000014)
		build_date=${build_date##*Value: 0x}
		echo "FPGA Build Date :" $build_date
		echo "FPGA loading done!"
		break
	fi
	busybox sleep 1
	count=$(($count+1))
	echo "Wait for FPGA loading" $count"s"
done
echo "Check FPGA status end!"
