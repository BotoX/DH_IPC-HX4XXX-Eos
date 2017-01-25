--[[
Instructions:
	WV-CS850 supports two different protocols. One is Panasonic conventional camera protocol, 
	which is compatible with CS600, CS650 etc. The other is Panasonic new camera protocol, 
	which enables faster PTZF operations. Panasonic new camera protocol is automatically selected 
	when CS850 is connected to a Panasonic controller/switcher, which supports the new protocol
	such as CU161, MP204 with CU360. Panasonic conventional protocol is applicable for general 
	commands such as AGC, ALC, shutter etc even when connected to CU161 or MP204 with CU360.
Note : 	
	Only address 01 �C 96 is available for CSR camera series. 
  Only address 01 �C 16 is available for WV-RM70. 
version INsturction:
  This lua text supports the new protocol for WV-CS Series.The differences between WV-CS850II and
  WV-CS950 is that a new function --pattern is added.
  
author:yangbin  2007.1.23

--]]

local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr = 
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "WV-CS950",	
		
	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "PTZ",
	
	-- ��msΪ��λ
	Internal = 350,
				
	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {1, 99}, 
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x00, 0xFF},	
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x01, 64},
	-- �Զ�Ѳ����·��Χ
	TourRange			= {0xff, 0xff},
	-- �켣��·��Χ
	PatternRange		= {0x01, 0x04},
	-- ��ֱ�ٶȷ�Χ
	TileSpeedRange 		= {0x00, 0x0F},
	-- ˮƽ�ٶȷ�Χ
	PanSpeedRange 		= {0x00, 0x0F},
	-- �Զ�ɨ�跶Χ
	ScanRange 			= {0x01, 0xff},
	
	-- ������Χ
	AuxRange 		= {0x01, 0x08},
}

Protocol.CommandAttr =
{
	-- Э������Ҫ���ĵ�λ�ã���LUA�±��ʾ�����±�ӣ���ʼ,��10���Ʊ�ʾ
	AddrPos 		= 4, 
	PresetPos 		= 16, 
	TileSpeedPos 		= 17,
	PanSpeedPos 		= 16,
	--AuxPos 		= 6,
}

Protocol.Command = 
{
	-- д����Э��ʱֻ����16���ƻ��ַ���ʾ,û�еĻ���ע�͵�
	Start= 
	{
		--д��������, ���ϣ����£����ϣ�����; ��16 17λ�ֱ��ʾ����������ٶ�.
		TileUp 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', 'A', '0', '0', 0x03",
		TileDown 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', 'E', '0', '0', 0x03",
		PanLeft 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '8', '0', '0', 0x03",
		PanRight 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', 'C', '0', '0', 0x03",
		LeftUp 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '9', '0', '0', 0x03",
		LeftDown 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', 'F', '0', '0', 0x03",
		RightUp		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', 'B', '0', '0', 0x03",
		RightDown = "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', 'D', '0', '0', 0x03",

		--��14λ�ĺ�2bit��ʾ�ٶ�
		ZoomWide 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', 0x04, '0', '0', '0', 0x03",
		ZoomTele 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', 0x00, '0', '0', '0', 0x03",
		
		--��17λ�ĺ�2bit��ʾ�ٶ�
		FocusNear	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '4', '0', '0', 0x00, 0x03",
		FocusFar 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '4', '0', '0', 0x04, 0x03",
		
		IrisSmall 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 'A', '9', 0x03",
		IrisLarge 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 'A', '8', 0x03",
			
	
		-- Ԥ�õ���������ã������ת��)
		--����Ԥ�õ��ŵ�16 17λ, ��6 4��ʼһֱ��A 3, ��64��
		SetPreset 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 0x64, 0x00, 0x03",
		--ClearPreset	= 
		--����Ԥ�õ�, ��16 17λΪ�����ʵ�Ԥ�õ���, ��0 0 ��3 F, ��64��
		GoToPreset 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 0x00, 0x00, 0x03",			
		
		-- �Զ�ɨ�裬��Ԥ�����õı߽��м�ת��
		SetLeftLimit 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', '4', '4', 0x03",
		SetRightLimit	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', '4', '5', 0x03", 
		AutoScanOn 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', '4', '0', 0x03",
		AutoScanOff	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', '4', '1', 0x03",
		
		--Ѱ�����ܵ�����,��ֹͣ��������
		SetPatternStart = "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 'A', '6', 0x03",
		StartPattern =	"0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 'A', '4', 0x03",
		StopPattern = "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '0', '0', 'A', '5', 0x03",
		
	},
	Stop = 
	{
		TileUp 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		TileDown 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		PanLeft 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		PanRight 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		LeftUp 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		LeftDown 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		RightUp		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		RightDown 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		
		ZoomWide 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '0', '0', '0', 0x03",
		ZoomTele 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '0', '0', '0', 0x03",
		
		FocusNear 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '4', '0', '0', '8', 0x03",
		FocusFar 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '4', '0', '0', '8', 0x03",
		
		IrisSmall 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		IrisLarge 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
	},
}



Protocol.Checksum = function (s)
	return s;
end;

Protocol.CamAddrProcess = function(s, addr)
	local newaddr = math.mod(addr, 100);
	local i    = math.floor(newaddr/10);
	local j    = math.mod(newaddr, 10);
	s[Protocol.CommandAttr.AddrPos] = i + 0x30;
	s[Protocol.CommandAttr.AddrPos + 1] = j + 0x30;

	return s;
end;

Protocol.SpeedProcess = function(s, ver, hor)

	if s[15] ~= string.byte('1') then
		local hex_table = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
		ver = math.mod(ver, 16);
		hor = math.mod(hor, 16);
		if ver ~= 0 then
			s[Protocol.CommandAttr.TileSpeedPos] = string.byte(hex_table[ver + 1]);
			s[Protocol.CommandAttr.PanSpeedPos] = string.byte(hex_table[ver + 1]);
		end;
		if hor ~= 0 then
			s[Protocol.CommandAttr.TileSpeedPos] = string.byte(hex_table[hor + 1]);
			s[Protocol.CommandAttr.PanSpeedPos] = string.byte(hex_table[hor + 1]);		
		end;
	end;
	
	return s;
end;

Protocol.MultipleProcess = function(s, multiple)
	-- ����multiple�ǣ�������ʾ�ٶȣ�����ת��
	local speed = math.floor((multiple - 1) / 2);
	
	if s[14] ~= string.byte('8') and s[17] ~= string.byte('8') and s[17] ~= string.byte('9') then
			print("test");
			if s[13] == 0x32 then
				s[14] = s[14] + speed + 0x30;
			elseif s[13] == 0x33 then
				s[17] = s[17] + speed +0x30;
			end; 
	end;
	
	return s;
end;

Protocol.PresetProcess = function(s, arg)
	
	local number = 0;
	if arg < 1 then
		number = 1;
	elseif arg > 64 then
		number = 64;
	else
		number = arg;
	end;

	local hex_table = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
	
	local preset = number + s[16] - 1;
	local i = math.floor(preset / 16);
	local j = math.mod(preset, 16);

	s[Protocol.CommandAttr.PresetPos] = string.byte(hex_table[i + 1]);
	s[Protocol.CommandAttr.PresetPos + 1] = string.byte(hex_table[j + 1]);

	return s;
end;

Protocol.PatternProcess = function(s,pattern_num)
	local pattern_play_table1 = {'A','C','C','C'};
	local pattern_play_table2 = {'4','1','2','3'};
	local pattern_learn_table = {'6','4','5','6'};
	if pattern_num <= 0x00 then
		return s;
	end;
	
	if s[17] == 0x36 then --����ǿ�ʼ����Ѱ������
		s[16] = string.byte(pattern_play_table1[pattern_num]);
		s[17] = string.byte(pattern_learn_table[pattern_num]);
		return s;
	end;

	if s[17] == 0x34 then --����ǿ�ʼѰ��
		s[16] = string.byte(pattern_play_table1[pattern_num]);
		s[17] = string.byte(pattern_play_table2[pattern_num]);
		return s;
	end;

	if s[17] == 0x35 then --�����ֹͣѲ��
		return s;
	end;

	return s;
end;

return Protocol;