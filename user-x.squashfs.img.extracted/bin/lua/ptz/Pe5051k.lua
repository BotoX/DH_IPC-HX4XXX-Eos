-- ��ƻ����PE5130Э��
local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr = 
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "PE5051K",	
		
	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "MATRIX",
	
	-- ��msΪ��λ
	Internal = 200,
				
	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {0x01, 999}, 
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x01, 999},	
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x01, 999},
	-- �Զ�Ѳ����·��Χ
	TourRange			= {0x01, 0xff},
	-- �켣��·��Χ
	PatternRange		= {0x01, 0xff},
	-- ��ֱ�ٶȷ�Χ
	TileSpeedRange 		= {0x01, 124},
	-- ˮƽ�ٶȷ�Χ
	PanSpeedRange 		= {0x01, 124},
	-- �Զ�ɨ�跶Χ
	ScanRange 			= {0x01, 0xff},
	
	-- ������Χ
	AuxRange 			= {0x01, 0x03},
}

Protocol.CommandAttr =
{
	-- Э������Ҫ���ĵ�λ�ã���LUA�±��ʾ�����±�ӣ���ʼ,��10���Ʊ�ʾ
	AddrPos 		= 2, 
	PresetPos 		= 6, 
	TileSpeedPos 	= 6,
	PanSpeedPos 	= 5,
	AuxPos 			= 6,
}

Protocol.Command = 
{
	-- д����Э��ʱֻ����16���ƻ��ַ���ʾ,û�еĻ���ע�͵�
	Start= 
	{
		TileUp 		= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '4','0','0','0','1','3','1','B',",
		TileDown 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '3','0','0','0','1','2','3','B',",
		PanLeft 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '1','1','2','3','0','8','0','B',", 
		PanRight 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '2','0','0','0','1','3','1','B',",
		LeftUp 		= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '6','1','2','3','1','3','1','B',",
		LeftDown 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '5','1','2','3','1','2','3','B',",
		RightUp		= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '8','1','3','1','1','3','1','B',",
		RightDown 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '7','1','3','1','1','2','3','B',",

		ZoomWide 	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '3','0','0','0','1','5','5','B',",
		ZoomTele 	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '4','0','0','0','1','5','5','B',",
		FocusNear	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '0','0','0','0','1','5','5','B',",
		FocusFar 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '9','0','0','0','1','5','5','B',",
		IrisSmall 	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '1','0','0','0','1','5','5','B',",
		IrisLarge 	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '2','0','0','0','1','5','5','B',",
			
		
		SetPreset 	= "'A', '0', '0', '1', '0', '0', '0', '0', '5', '5','0','0','0','1','5','5','B',",
		ClearPreset	= "'A', '0', '0', '1', '0', '0', '0', '0', '5', '6','0','0','0','1','5','5','B',",
		GoToPreset 	= "'A', '0', '0', '1', '0', '0', '0', '0', '5', '7','0','0','0','1','5','5','B',",			
			
		AutoPanOn		= "'A', '0', '0', '1', '0', '0', '0', '0', '2', '3','0','0','0','1','5','5','B',",
		AutoPanOff		= "'A', '0', '0', '1', '0', '0', '0', '0', '2', '4','0','0','0','1','5','5','B',",
			
		SetLeftLimit 	= "'A', '0', '0', '1', '0', '0', '0', '0', '2', '5','0','0','0','1','5','5','B',",
		SetRightLimit	= "'A', '0', '0', '1', '0', '0', '0', '0', '2', '6','0','0','0','1','5','5','B',", 
		AutoScanOn		= "'A', '0', '0', '1', '0', '0', '0', '0', '2', '8','0','0','0','1','5','5','B',", 
		AutoScanOff		= "'A', '0', '0', '1', '0', '0', '0', '0', '2', '7','0','0','0','1','5','5','B',", 

		SetPatternStart = "'A', '0', '0', '1', '0', '0', '0', '0', '5', '8','0','0','0','1','5','5','B',",
		SetPatternStop 	= "'A', '0', '0', '1', '0', '0', '0', '0', '6', '0','0','0','0','1','5','5','B',",
		StartPattern 	= "'A', '0', '0', '1', '0', '0', '0', '0', '6', '1','0','0','0','1','5','5','B',",
		StopPattern		= "'A', '0', '0', '1', '0', '0', '0', '0', '6', '2','0','0','0','1','5','5','B',",
		
		AuxOn 	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '1','0','0','0','1','5','5','B',",
		AuxOff 	= "'A', '0', '0', '1', '0', '0', '0', '0', '1', '0','0','0','0','1','5','5','B',",
			
		-- �˵���ز���
		Menu = "'A', '0', '0', '1', '0', '0', '0', '1', '0', '1','0','0','0','1','5','5','B',",
		MenuExit = "'A', '0', '0', '1', '0', '0', '0', '0', '2', '8','0','0','0','1','5','5','B',",
		MenuEnter = "'A', '0', '0', '1', '0', '0', '0', '0', '2', '8','0','0','0','1','5','5','B',",
		MenuEsc = "'A', '0', '0', '1', '0', '0', '0', '0', '3', '0','0','0','0','1','5','5','B',",
		MenuUp = "'A', '0', '0', '1', '0', '0', '0', '0', '2', '6','0','0','0','1','5','5','B',",
		MenuDown = "'A', '0', '0', '1', '0', '0', '0', '0', '2', '4','0','0','0','1','5','5','B',",
		MenuLeft = "'A', '0', '0', '1', '0', '0', '0', '0', '2', '5','0','0','0','1','5','5','B',",
		MenuRight = "'A', '0', '0', '1', '0', '0', '0', '0', '2', '7','0','0','0','1','5','5','B',",
		
		MatrixSwitch="'A', '0', '0', '1', '0', '0', '0', '0', '3', '1', '0', '0', '0', '0', '0', '0','B',";
		

	},
	Stop = 
	{
		TileUp 		= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		TileDown 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		PanLeft 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		PanRight 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		LeftUp 		= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		LeftDown 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		RightUp		= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		RightDown 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		
		ZoomWide 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		ZoomTele 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		FocusNear 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		FocusFar 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		IrisSmall 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
		IrisLarge 	= "'A', '0', '0', '1', '0', '0', '0', '0', '0', '0','0','0','0','1','5','5','B',",
	},
}

Protocol.Checksum = function (s)
	return s;
end;


Protocol.CamAddrProcess = function(s, addr)
	local low = math.mod(addr, 10);
	local middle = (addr - low)/10;
	local high = (addr - middle * 10 - low)/100;

	s[5] = string.byte(high);
	s[6] = string.byte(middle);
	s[7] = string.byte(low);
	return s;
end;

Protocol.MonAddrProcess = function(s, addr)
	local low = math.mod(addr, 10);
	local middle = (addr - low)/10;
	local high = (addr - middle * 10 - low)/100;

	s[2] = string.byte(high);
	s[3] = string.byte(middle);
	s[4] = string.byte(low);
	return s;
end;

Protocol.SpeedProcess = function(s, arg1, arg2)
	local num = tonumber(s[11]) * 100 + tonumber(s[12]) * 10 + tonumber(s[13]);
	if num == 123 then 
		num = num - arg2;
		local low = math.mod(num, 10);
		local middle = (num - low)/10;
		local high = (num - middle * 10 - low)/100;		
		s[11] = string.byte(high);
		s[12] = string.byte(middle);
		s[13] = string.byte(low);
	elseif num == 131 then
		num = num + arg2;
		local low = math.mod(num, 10);
		local middle = (num - low)/10;
		local high = (num - middle * 10 - low)/100;
		s[11] = string.byte(high);
		s[12] = string.byte(middle);
		s[13] = string.byte(low);
	end;
	
	local num = tonumber(s[14]) * 100 + tonumber(s[15]) * 10 + tonumber(s[16]);
	if num == 123 then 
		num = num - arg1;
		local low = math.mod(num, 10);
		local middle = (num - low)/10;
		local high = (num - middle * 10 - low)/100;
		s[14] = string.byte(high);
		s[15] = string.byte(middle);
		s[16] = string.byte(low);
	elseif num == 131 then
		num = num + arg1;
		local low = math.mod(num, 10);
		local middle = (num - low)/10;
		local high = (num - middle * 10 - low)/100;
		s[14] = string.byte(high);
		s[15] = string.byte(middle);
		s[16] = string.byte(low);
	end;
		
	return s;
end;

Protocol.PresetProcess = function(s, arg)
	local low = math.mod(arg, 10);
	local middle = (arg - low)/10;
	local high = (arg - middle * 10 - low)/100;
	s[2] = string.byte(high);
	s[3] = string.byte(middle);
	s[4] = string.byte(low);
	return s;
end;

Protocol.PatternProcess = function(s, num)
	local low = math.mod(num, 10);
	local middle = (num - low)/10;
	local high = (num - middle * 10 - low)/100;
	s[11] = string.byte(high);
	s[12] = string.byte(middle);
	s[13] = string.byte(low);
	return s;	
end;

Protocol.AuxProcess = function(s, aux)
	if s[10] == 0x31 then
	-- ��
		if aux == 1 then
			s[10] = 0x35;
		elseif aux == 2 then
			s[10] = 0x37;
		elseif aux == 3 then
			s[10] = 0x39;
		end;
	elseif s[10] == 0x30 then
		if aux == 1 then
			s[10] = 0x36;
		elseif aux == 2 then
			s[10] = 0x38;
		elseif aux == 3 then
			s[9] = 0x32;
			s[10] = 0x30;
		end;
	end;
	return s;
end;

return Protocol;