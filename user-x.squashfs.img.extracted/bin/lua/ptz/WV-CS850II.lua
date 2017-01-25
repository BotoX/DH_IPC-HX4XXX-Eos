local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr = 
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "WV-CS850II",	
		
	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "PTZ",
	
	-- ��msΪ��λ
	Internal = 200,
				
	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {1, 99}, 
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x00, 0xFF},	
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x00, 0xff},
	-- �Զ�Ѳ����·��Χ
	TourRange		= {0xff, 0xff},
	-- �켣��·��Χ
	PatternRange		= {0x01, 0x01},
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
		RightDown = "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		
		ZoomWide 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '0', '0', '0', 0x03",
		ZoomTele 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '0', '0', '0', 0x03",
		
		FocusNear 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '4', '0', '0', '8', 0x03",
		FocusFar 		= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '3', '4', '0', '0', '8', 0x03",
		
		IrisSmall 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
		IrisLarge 	= "0x02, 'A', 'D', '0', '0', ';', 'G', 'C', '7', ':', '9', '0', '2', '8', '1', '0', '0', 0x03",
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
	
	if s[14] ~= string.byte('8') and s[17] ~= string.byte('8')  and s[17] ~= string.byte('9') then
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

return Protocol;