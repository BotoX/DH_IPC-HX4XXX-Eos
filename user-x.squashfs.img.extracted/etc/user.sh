#! /bin/sh
echo 100 > /proc/sys/vm/dirty_writeback_centisecs # cacheˢ�����ڸ�Ϊ1s
echo 500 > /proc/sys/vm/dirty_expire_centisecs # cache��ʱʱ���Ϊ5s
echo 50 > /proc/sys/vm/vfs_cache_pressure # �����ڱ���directory��inode cache
echo 30 > /proc/sys/vm/swappiness # ���ʹ��̽����̶�
echo 10 > /proc/sys/vm/dirty_ratio # ���������ݴﵽ10%����ʱ������д������
echo 4096 > /proc/sys/vm/min_free_kbytes
#echo 2 > /proc/cpu/alignment # ��ֹ����Alignment trap�Ĵ���
echo "/home/core-%e-%p-%t" > /proc/sys/kernel/core_pattern # ����coredump�ļ�·��
echo 1048576 > /proc/sys/vm/dirty_bytes 			# ��д��ֵ����Ϊ1M
echo 1048576 > /proc/sys/vm/dirty_background_bytes 	# ��д��ֵ����Ϊ1M
