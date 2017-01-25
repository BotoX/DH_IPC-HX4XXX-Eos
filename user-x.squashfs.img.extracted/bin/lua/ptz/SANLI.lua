-- ���Ǵ�Э�飬�Ѿ����ã����ø���
local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr = 
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "SANLI",	
		
	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "PTZ",
	
	-- ��msΪ��λ
	Internal = 200,
				
	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {0x01, 0xFF}, 
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x00, 0xFF},	
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x01, 80},
	-- �Զ�Ѳ����·��Χ
	TourRange			= {0x00, 7},
	-- �켣��·��Χ
	PatternRange		= {0x00, 4},
	-- ��ֱ�ٶȷ�Χ
	TileSpeedRange 		= {0x01, 0x0f},
	-- ˮƽ�ٶȷ�Χ
	PanSpeedRange 		= {0x01, 0x0f},
	-- �Զ�ɨ�跶Χ
	ScanRange 			= {0x01, 0xff},
	
	-- ������Χ
	AuxRange 			= {0x01, 0x34},
}

Protocol.CommandAttr =
{
	-- Э������Ҫ���ĵ�λ�ã���LUA�±��ʾ�����±�ӣ���ʼ,��10���Ʊ�ʾ
	AddrPos 		= 1, 
	PresetPos 		= 4, 
	TileSpeedPos 	= 4,
	PanSpeedPos 	= 4,
	AuxPos 			= 3,
}

Protocol.Command = 
{
	-- д����Э��ʱֻ����16���ƻ��ַ���ʾ,û�еĻ���ע�͵�
	Start= 
	{
		--д��������, ���ϣ����£����ϣ�����
		TileUp 		= "0x00, 0x00, 0x50, 0x00, 0x00,",
		TileDown 	= "0x00, 0x00, 0x51, 0x00, 0x00,",
		PanLeft 	= "0x00, 0x00, 0x52, 0x00, 0x00,",
		PanRight 	= "0x00, 0x00, 0x53, 0x00, 0x00,",


		ZoomWide 	= "0xA5, 0x00, 0x0c, 0x00",
		ZoomTele 	= "0xA5, 0x00, 0x0d, 0x00",
		FocusNear	= "0xA5, 0x00, 0x0A, 0x00",
		FocusFar 	= "0xA5, 0x00, 0x0B, 0x00",
		IrisSmall 	= "0xA5, 0x00, 0x09, 0x00",
		IrisLarge 	= "0xA5, 0x00, 0x08, 0x00",
			
		-- �ƹ�
		LightOn		= "0x00, 0x00, 0x1c, 0x00",
		LightOff  	= "0x00, 0x01, 0x1d, 0x00",
			
		-- Ԥ�õ���������ã������ת��)
		SetPreset 	= "0x00, 0x00, 0x58, 0x00, 0x00",
		ClearPreset	= "0x00, 0x00, 0x5a, 0x00, 0x00",
		GoToPreset 	= "0x00, 0x00, 0x59, 0x00, 0x00",			
			
		AutoPanOn		= "0x00, 0x00, 0x34, 0x00",
		AutoPanOff		= "0x00, 0x00, 0x31, 0x00",


			
		-- �켣Ѳ��, һ��ָģʽ(���ÿ�ʼ�����ý��������У�ֹͣ�����ģʽ
		SetPatternStart = "0x00, 0x00, 0x64, 0x00, 0x00",
		SetPatternStop 	= "0x00, 0x00, 0x21, 0x00, 0x00, 0x00, 0x22,0x00",
		StartPattern 	= "0x00, 0x00, 0x60, 0x00, 0x00",
		StopPattern	= "0x00, 0x00, 0x62, 0x00, 0x00",
		ClearPattern 	= "0x00, 0x00, 0x63, 0x00, 0x00",
		
		AuxOn 	= "0x00, 0x00, 0x00, 0x00",
		AuxOff 	= "0x00, 0x00, 0x00, 0x00",

	},
	Stop = 
	{
		TileUp 		= "0x00, 0x00, 0x01, 0x00",
		TileDown 	= "0x00, 0x00, 0x01, 0x00",
		PanLeft 	= "0x00, 0x00, 0x02, 0x00",
		PanRight 	= "0x00, 0x00, 0x02, 0x00,",
		
		ZoomWide 	= "0x00, 0x00, 0x05, 0x00,",
		ZoomTele 	= "0x00, 0x00, 0x05, 0x00,",
		FocusNear 	= "0x00, 0x00, 0x04, 0x00,",
		FocusFar 	= "0x00, 0x00, 0x04, 0x00,",
		IrisSmall 	= "0x00, 0x00, 0x03, 0x00,",
		IrisLarge 	= "0x00, 0x00, 0x03, 0x00,",
	},
}

Protocol.Checksum = function (s)

	if table.getn(s) == 5 then
		local sum = math.mod(0xFFFF - (s[1] + s[2] + s[3] + s[4] ),256);
		s[5] = math.mod(sum ,128);
	elseif table.getn(s) == 4 then
		local sum = math.mod(0xFFFF - (s[1] + s[2] + s[3] ),256);
		s[4] = math.mod(sum ,128);
	else
		local sum1 = math.mod(0xFFFF - (s[1] + s[2] + s[3] ),256);
		s[4] =  math.mod(sum1 ,128);
		local sum2 = math.mod(0xFFFF - (s[5] + s[6] + s[7] ),256);
		s[8] =  math.mod(sum2 ,128);
	end;

	return s;
end;


Protocol.CamAddrProcess = function(s, addr)
	if table.getn(s) == 4 or table.getn(s) == 5 then
		local addr = math.mod(addr,256);
		s[1] = 0xc0 + math.floor(addr/64)
		s[2] = math.mod(addr,64) + 128;
	else
		local addr = math.mod(addr,256);
		s[1] = 0xc0 + math.floor(addr/64);
		s[5] = 0xc0 + math.floor(addr/64);
		s[2] = math.mod(addr,64) + 128;
		s[6] = math.mod(addr,64) + 128;
	end;
	return s;
end;


Protocol.SpeedProcess = function(s, arg1, arg2)
	if arg1 ~= 0x00 then
		s[4] = arg1;
	end;
	if arg2 ~= 0x00 then
		s[4] = arg2;
	end;
	return s;
end;
Protocol.PatternProcess = function(s, num)
	s[4] = num;
	return s;	
end;





return Protocol;