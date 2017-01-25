#! /bin/sh
echo 100 > /proc/sys/vm/dirty_writeback_centisecs # cache刷新周期改为1s
echo 500 > /proc/sys/vm/dirty_expire_centisecs # cache超时时间改为5s
echo 50 > /proc/sys/vm/vfs_cache_pressure # 倾向于保留directory和inode cache
echo 30 > /proc/sys/vm/swappiness # 降低磁盘交换程度
echo 10 > /proc/sys/vm/dirty_ratio # 进程脏数据达到10%以上时，自行写回数据
echo 4096 > /proc/sys/vm/min_free_kbytes
#echo 2 > /proc/cpu/alignment # 防止出现Alignment trap的错误
echo "/home/core-%e-%p-%t" > /proc/sys/kernel/core_pattern # 设置coredump文件路径
echo 1048576 > /proc/sys/vm/dirty_bytes 			# 回写阈值设置为1M
echo 1048576 > /proc/sys/vm/dirty_background_bytes 	# 回写阈值设置为1M
