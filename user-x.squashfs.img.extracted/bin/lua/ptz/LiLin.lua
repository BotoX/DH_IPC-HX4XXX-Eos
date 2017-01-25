-- ����̨������Э��
local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr = 
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "LILIN",	
		
	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "PTZ",
	
	-- ��msΪ��λ
	Internal = 200,
				
	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {0x01, 0x40}, 
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x01, 0xff},	
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x01, 0x80},
	-- �Զ�Ѳ����·��Χ
	TourRange			= {0x01, 0x04},
	-- �켣��·��Χ
	PatternRange		= {0x01, 0x80},
	-- ��ֱ�ٶȷ�Χ
	TileSpeedRange 		= {0x00, 0x07},
	-- ˮƽ�ٶȷ�Χ
	PanSpeedRange 		= {0x00, 0x07},
	-- �Զ�ɨ�跶Χ
	ScanRange 			= {0x01, 0xff},
	
	-- ������Χ
	AuxRange 			= {0x01, 0x02},
}

Protocol.CommandAttr =
{
	-- Э������Ҫ���ĵ�λ�ã���LUA�±��ʾ�����±�ӣ���ʼ,��10���Ʊ�ʾ
	AddrPos 		= 1, 
	PresetPos 		= 2, 
	TileSpeedPos 	= 3,
	PanSpeedPos 	= 3,
	AuxPos 			= 3,
}

Protocol.Command = 
{
	-- д����Э��ʱֻ����16���ƻ��ַ���ʾ,û�еĻ���ע�͵�
	Start= 
	{
		--д��������, ���ϣ����£����ϣ�����
		TileUp 		= "0x00, 0x04, 0x00",
		TileDown 	= "0x00, 0x08, 0x00",
		PanLeft 	= "0x00, 0x02, 0x00", 
		PanRight 	= "0x00, 0x01, 0x00",
		LeftUp 		= "0x00, 0x06, 0x00",
		LeftDown 	= "0x00, 0x0a, 0x00",
		RightUp		= "0x00, 0x05, 0x00",
		RightDown 	= "0x00, 0x09, 0x00",
		
		ZoomWide 	= "0x00, 0x20, 0xff",
		ZoomTele 	= "0x00, 0x10, 0xff",
		FocusNear	= "0x00, 0x80, 0xff",
		FocusFar 	= "0x00, 0x40, 0xff",
		IrisSmall 	= "0x00, 0x00, 0x01",
		IrisLarge 	= "0x00, 0x00, 0x00",
				
		-- Ԥ�õ���������ã������ת��)
		GoToPreset 	= "0x40, 0x00, 0x00",
		
		SetPatternStart = "0x40, 0x0f, 0x00",
		SetPatternStop  = "0x80, 0x0f, 0x0f",
			
		StartPattern = "0x00, 0x00, 0x0a",
		StopPattern	 = "0x00, 0x00, 0x0a",
	},
	Stop = 
	{
		TileUp 		= "0x00, 0x00, 0xff",
		TileDown 	= "0x00, 0x00, 0xff",
		PanLeft 	= "0x00, 0x00, 0xff",
		PanRight 	= "0x00, 0x00, 0xff",
		LeftUp 		= "0x00, 0x00, 0xff",
		LeftDown 	= "0x00, 0x00, 0xff",
		RightUp		= "0x00, 0x00, 0xff",
		RightDown 	= "0x00, 0x00, 0xff",
		
		ZoomWide 	= "0x00, 0x00, 0xff",
		ZoomTele 	= "0x00, 0x00, 0xff",
		FocusNear 	= "0x00, 0x00, 0xff",
		FocusFar 	= "0x00, 0x00, 0xff",
		IrisSmall 	= "0x00, 0x00, 0xff",
		IrisLarge 	= "0x00, 0x00, 0xff",
	},
}

Protocol.Checksum = function (s)
	return s;
end;

Protocol.CamAddrProcess = function(s, addr)
	s[1] = s[1] + addr;
	return s;
end;

Protocol.SpeedProcess = function(s, ver, hor)
	if s[2] ~= 0x00 then
		if s[2] == 0x04 or s[2] == 0x08 then
			s[3] = 128 + (ver * 8);
		elseif s[2] == 0x01 or s[2] == 0x02 then
			s[3] = 128 + hor;
		else
			s[3] = 128 + (ver * 8) + hor;
		end;
	end;
	return s;
end;

Protocol.PresetProcess = function(s, arg)
	if arg > 0 then
		s[Protocol.CommandAttr.PresetPos] = arg - 1;
	end;
	return s;
end;

Protocol.PatternProcess = function(s, num)
	print(num);
	if s[2] == 0x0f then
		if s[3] == 0x00 then
			s[2] = num;
		end;
	else
		s[1] = num;
	end;
	return s;
end;

return Protocol;