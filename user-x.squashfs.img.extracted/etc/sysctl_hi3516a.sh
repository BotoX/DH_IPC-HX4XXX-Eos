#!/bin/sh

# This is a sample, you should rewrite it according to your chip #

# mddrc pri&timeout setting

#########################################################################################
# param $1=1 --- online
# param $1=0 --- offline
vi_vpss_online_config()
{
	# -------------vi vpss online open
	if [ $b_vpss_online -eq 1 ]; then
		echo "==============vi_vpss_online==============";
		himm 0x20120004 0x40000000;			# online
		
		#pri config
		himm 0x20120058 0x26666400			# each module 4bit£ºvedu       ddrt_md  ive  aio    jpge    tde   vicap  vdp
		himm 0x2012005c 0x66666103			# each module 4bit£ºsfc_nand   sfc_nor  nfc  sdio1  sdio0   a7    vpss   vgs 
		himm 0x20120060 0x66266666			# each module 4bit£ºreserve    reserve  avc  usb    cipher  dma2  dma1   gsf
		
		#timeout config                
		himm 0x20120064 0x00000011			# each module 4bit£ºvedu       ddrt_md  ive  aio    jpge    tde   vicap  vdp
		himm 0x20120068 0x00000020			# each module 4bit£ºsfc_nand   sfc_nor  nfc  sdio1  sdio0   a7    vpss   vgs 
		himm 0x2012006c 0x00000000			# each module 4bit£ºreserve    reserve  avc  usb    cipher  dma2  dma1   gsf 
	else
		echo "==============vi_vpss_offline==============";
		himm 0x20120004 0x101a00;			# offline, mipi phy lvds mode;
		# pri config
		himm 0x20120058 0x26666401     		# each module 4bit£ºvedu       ddrt_md  ive  aio    jpge    tde   vicap  vdp
		himm 0x2012005c 0x66666112     		# each module 4bit£ºsfc_nand   sfc_nor  nfc  sdio1  sdio0   a7    vpss   vgs 
		himm 0x20120060 0x66266666    		# each module 4bit£ºreserve    reserve  avc  usb    cipher  dma2  dma1   gsf
		# timeout config              		
		himm 0x20120064 0x00000011    		# each module 4bit£ºvedu       ddrt_md  ive  aio    jpge    tde   vicap  vdp
		himm 0x20120068 0x00000000    		# each module 4bit£ºsfc_nand   sfc_nor  nfc  sdio1  sdio0   a7    vpss   vgs 
		himm 0x2012006c 0x00000000    		# each module 4bit£ºreserve    reserve  avc  usb    cipher  dma2  dma1   gsf 
	fi  
}
#########################################################################################

# msic config
himm 0x201200E0 0xd					# internal codec£¬AIO MCLK out, CODEC AIO TX MCLK 
#himm 0x201200E0 0xe				# external codec: AIC31/AK7756£¬AIO MCLK out, CODEC AIO TX MCLK 

# mddrc pri&timeout setting
himm 0x201100c0 0x76543210     # ports0         
himm 0x201100c4 0x76543210     # ports1         
himm 0x201100c8 0x76543210     # ports2
himm 0x201100cc 0x76543210     # ports3
himm 0x201100d0 0x76543210     # ports4
himm 0x201100d4 0x76543210     # ports5
himm 0x201100d8 0x76543210     # ports6

# read pri              
himm 0x20110100 0x76543210     # ports0         
himm 0x20110104 0x76543210     # ports1         
himm 0x20110108 0x76543210     # ports2
himm 0x2011010c 0x76543210     # ports3
himm 0x20110110 0x76543210     # ports4
himm 0x20110114 0x76543210     # ports5
himm 0x20110118 0x76543210     # ports6

#write timeout
himm 0x20110140 0x08040200     # ports0 
himm 0x20110144 0x08040100     # ports1 
himm 0x20110148 0x08040200     # ports2 
himm 0x2011014c 0x08040200     # ports3 
himm 0x20110150 0x08040200     # ports4 
himm 0x20110154 0x08040200     # ports5 
himm 0x20110158 0x08040200     # ports6 

# read timeout                 
himm 0x20110180 0x08040200     # ports0 
himm 0x20110184 0x08040200     # ports1 
himm 0x20110188 0x08040200     # port2 
himm 0x2011018c 0x08040200     # ports3 
himm 0x20110190 0x08040200     # ports4 
himm 0x20110194 0x08040200     # ports5 
himm 0x20110198 0x08040200     # ports6

# map mode
himm  0x20110040  0x01001000   # ports0 
himm  0x20110044  0x01001000   # ports1 
himm  0x20110048  0x01001000   # ports2 
himm  0x2011004c  0x01001000   # ports3 
himm  0x20110050  0x01001000   # ports4 
himm  0x20110054  0x01001000   # ports5 
himm  0x20110058  0x01001000   # ports6

echo "++++++++++++++++++++++++++++++++++++++++++++++"
b_vpss_online=1

if [ $# -ge 1 ]; then
    b_vpss_online=$1
fi

vi_vpss_online_config;

#outstanding
cfg_outstanding()
{
	himm 0x20580010 0x00003030		# VICAP outstanding r/w 3, rw 
	himm 0x205c0034 0x00000003		# VDP outstanding 3
	himm 0x20600314 0x00000033		# VPSS outstanding[r0:3, w4:7]
	#himm 0x2061002c 0x00444010  	# TDE  w:[24:21];r:[20:17];r[16:13]
	himm 0x20620040 0x3				# AVC
	himm 0x20640040 0x00000055		# VEDU
	himm 0x206600A4 0x3				# JPEG
}


