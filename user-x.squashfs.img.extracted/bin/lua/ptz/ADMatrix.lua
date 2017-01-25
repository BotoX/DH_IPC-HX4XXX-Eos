-- AD����Э��
-- �޸ļ�¼
-- ������ͨһ����AD����Э��, ��P/T�ٶȿ���ɾȥ, ���Ҽ�����site addr, ���û��ṩ��Monitor addrд��site addr��λ��.
-- Monitor addr��λ��д��Ϊ15. Camera addr����. Ŀ����Ϊ�˽��P/T������Ч�Ĵ���.	JinJ 2006.7.13
local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr = 
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "ADMATRIX",	
		
	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "MATRIX",
	
	-- ��msΪ��λ
	Internal = 66,
				
	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {0x01, 0xff}, 
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x01, 0xff},	
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x00, 0xff},
	-- �Զ�Ѳ����·��Χ
	TourRange			= {0x01, 0xff},
	-- �켣��·��Χ
	PatternRange		= {0xff, 0xff},
	-- ��ֱ�ٶȷ�Χ
	TileSpeedRange 		= {0x01, 0x06},
	-- ˮƽ�ٶȷ�Χ
	PanSpeedRange 		= {0x01, 0x06},
	-- �Զ�ɨ�跶Χ
	ScanRange 			= {0x01, 0xff},
	
	-- ������Χ
	AuxRange 			= {0x01, 0xff},
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

local monitordata ={}
local cameradata = {};
local middletable= {};

Protocol.Command = 
{
	-- д����Э��ʱֻ����16���ƻ��ַ���ʾ,û�еĻ���ע�͵�
	Start= 
	{
		--д��������, ���ϣ����£����ϣ�����
		TileUp 		= "'U', 'a'",
		TileDown 	= "'D', 'a'",
		PanLeft 	= "'L', 'a'", 
		PanRight 	= "'R', 'a'",
		LeftUp 		= "'L', 'a', 'U', 'a'",
		LeftDown 	= "'L', 'a', 'D', 'a'",
		RightUp		= "'R', 'a', 'U', 'a'",
		RightDown 	= "'R', 'a', 'D', 'a'",

		ZoomWide 	= "'W', 'a'",
		ZoomTele 	= "'T', 'a'",
		FocusNear	= "'N', 'a'",
		FocusFar 	= "'F', 'a'",
		IrisSmall = "'C', 'a'",
		IrisLarge = "'O', 'a'",
			
			
		-- Ԥ�õ���������ã������ת��)
		SetPreset 	= "'^', 'a'",
		GoToPreset 	= "'\\', 'a'",			
			
		-- �Զ�Ѳ����һ��ָ��Ԥ�õ�֮��Ѳ��

		StartTour 	= "'S', 'a'",


		AuxOn 	= "'A', 'a'",
		AuxOff 	= "'B', 'a'",
		
		MatrixSwitch ="'M', 'a', '#', 'a'";
			
	},
	Stop = 
	{
		TileUp 		= "'s', 'a'",
		TileDown 	= "'s', 'a'",
		PanLeft 	= "'s', 'a'", 
		PanRight 	= "'s', 'a'",
		LeftUp 		= "'s', 'a'",
		LeftDown 	= "'s', 'a'",
		RightUp		= "'s', 'a'",
		RightDown = "'s', 'a'",

		ZoomWide 	= "'s', 'a'",
		ZoomTele 	= "'s', 'a'",
		FocusNear	= "'s', 'a'",
		FocusFar 	= "'s', 'a'",
		IrisSmall = "'s', 'a'",
		IrisLarge = "'s', 'a'",
	},
}
-- ע��opttable������ַ�
local function conver(opttable , value)
	local tmptable = {};
	middletable = {};
	if type(opttable) ~= "table" then
		return optable;
	end;
	
	local i = 1;
	
	while value > 0 do
		tmptable[i] = math.mod(value, 10);
		value = (value - tmptable[i])/10;
		i = i+1;		
	end;
	
	local len = table.getn(tmptable);
	for j = 1, len do
		middletable[j] = tmptable[len - j + 1] + 0x30;
	end;
	
	for j = 1, table.getn(opttable) do
		middletable[len + j] = opttable[j];
	end;
	
	return middletable;
end;
 
Protocol.Checksum = function (s)
	local restr = {};
	local i = 1;
	for j = 1, table.getn(monitordata) do
		restr[i] = monitordata[j];
		i = i + 1;
	end;
	
	for j = 1, table.getn(cameradata) do
		restr[i] = cameradata[j];
		i = i + 1;
	end;
	
	if s[1] ~= string.byte('M') then
		for j = 1, table.getn(s) do
			restr[i] = s[j];
			i = i + 1;
		end;
	end;
	return restr;
end;


Protocol.CamAddrProcess = function(s, addr)
	local addr = math.mod(addr,256);
	local tmptable = {string.byte('#'), string.byte('a')};
	cameradata = {};
  cameradata = conver(tmptable, addr);
 	
	return s;
end;

Protocol.MonAddrProcess = function(s, addr)
	local addr = math.mod(addr,256);
	-- local tmptable = {string.byte('M'), string.byte('a')};
	local tmptable = {string.byte(';'), string.byte('a'), string.byte('1'), string.byte('5'), string.byte('M'), string.byte('a')};
	monitordata = {};
	monitordata = conver(tmptable, addr);
	
	return s;
end;
--[[
Protocol.SpeedProcess = function(s, arg1, arg2)
	if table.getn(s) > 3 then
		s[1] = arg1 + 0x30;
		s[4] = arg2 + 0x30;
	elseif table.getn(s) == 3 then
		s[1] = math.max(arg1,arg2) + 0x30; 
	end;
	return s;
end;
--]]

Protocol.SpeedProcess = function(s, arg1, arg2)
	return s;
end;

Protocol.PresetProcess = function(s, preset)
	local retstr = {};
	retstr = conver(s, preset);
	return retstr; 
end;

Protocol.TourProcess = function(s, tour)
	local retstr = {};
	retstr = conver(s, tour);

	return retstr; 
end;

Protocol.AuxProcess = function(s, num)
	local retstr = {};
	retstr = conver(s, num);
		
	return retstr; 
end;

return Protocol;