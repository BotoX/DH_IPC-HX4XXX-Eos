local Protocol = {};

-- ��ʾ��ֵ������16��10����(��Сֵ�����ֵ)
Protocol.Attr =
{
	-- Э�����ʾ����,���ܳ���16�ַ���Ŀǰ�ݲ�֧������
	Name = "PELCOD-S",

	-- ָ������̨Э�黹�Ǿ���Э�飬ʹ��"PTZ", "MATRIX"��ʾ
	Type = "PTZ",

	-- ��msΪ��λ
	Internal = 200,

	-- û�ж�Ӧ�ĵ�ַ��Χ���붼���0xff
	-- ��̨��ַ��Χ
	CamAddrRange 		= {0x00, 0x1F},
	-- ���ӵ�ַ��Χ
	MonAddrRange		= {0x00, 0xFF},
	-- Ԥ�õ㷶Χ
	PresetRange 		= {0x01, 0xFF},
	-- �Զ�Ѳ����·��Χ
	TourRange		= {0x00, 0xff},
	-- �켣��·��Χ
	PatternRange		= {0x00, 0xff},
	-- ��ֱ�ٶȷ�Χ
	TileSpeedRange 		= {0x00, 0x3F},
	-- ˮƽ�ٶȷ�Χ
	PanSpeedRange 		= {0x00, 0x3F},
	-- �Զ�ɨ�跶Χ
	ScanRange 			= {0x01, 0xff},
	-- ������Χ
	AuxRange 		= {0x01, 0x08},
}

Protocol.CommandAttr =
{
	-- Э������Ҫ���ĵ�λ�ã���LUA�±��ʾ�����±�ӣ���ʼ,��10���Ʊ�ʾ
	AddrPos 		= 2,
	PresetPos 		= 6,
	TileSpeedPos 		= 6,
	PanSpeedPos 		= 5,
	AuxPos 			= 6,
        TileUp   = {bytePos = 4, bitPos = 3},
	TileDown = {bytePos = 4, bitPos = 4},
	PanLeft  = {bytePos = 4, bitPos = 2},
	PanRight = {bytePos = 4, bitPos = 1},
	ZoomWide = {bytePos = 4, bitPos = 6},
	ZoomTele = {bytePos = 4, bitPos = 5},
	FocusFar = {bytePos = 4, bitPos = 7},
	FocusNear = {bytePos = 3, bitPos = 0},
	IrisLarge = {bytePos = 3, bitPos = 1},
	IrisSmall = {bytePos = 3, bitPos = 2},
}

Protocol.Command =
{
	-- д����Э��ʱֻ����16���ƻ��ַ���ʾ,û�еĻ���ע�͵�
	Start=
	{
		--д��������, ���ϣ����£����ϣ�����
		STANDARD = "0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00",
	},
	Stop =
	{
		STANDARD = "0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00",
	},
}

Protocol.Checksum = function (s)
	s[7] = math.mod((s[2] + s[3] + s[4] + s[5] + s[6]), 256);

	return s;
end;

Protocol.CamAddrProcess = function(s, addr)
	local addr = math.mod(addr,256);
		s[2] = addr;
	return s;
end;

Protocol.SpeedProcess = function(s, ver, hor)
	if s[4] ~= 0x00 then
		s[6] = ver;
		s[5] = hor;
	end;

	return s;
end;

return Protocol;