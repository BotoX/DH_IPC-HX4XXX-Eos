--   "$Id: PTZCtrl.lua 1136 2008-08-02 06:05:52Z yang_bin $"
--   (c) Copyright 1992-2005, ZheJiang Dahua Information Technology Stock CO.LTD.
--                            All Rights Reserved
--
--	�� �� ���� PTZCtrl.lua
--	��    ��:  ��̨���ƽű�
--	�޸ļ�¼�� 2006-5-22 ������ <wang_hengwen@dahuatech.com> ��Ԭʿ�´���Ļ�������������
--   
local AllPTZProtocol = {}; 		-- �������кźͶ�Ӧ���ļ���
local SelectedPTZ = {}; 		-- ���潫Ҫ������Э��
local CamAddr = nil; 			-- ����Э�����̨��ַ
local MonAddr = nil; 			-- ������ӵ�ַ

local PTZCtrl = {};
PTZCtrl.PathSet = {};


-- �������е���̨����Э��
local function buildPtzList(PathSet)
	local PTZProtocols = {};

	-- ���ڼ��ص�������̨����Э���ļ�
	local function loadPtzFile(filename)
		local f,err = loadfile(filename);
		if f then
			local ret, protocol;
			ret, protocol = pcall(f);
			if( ret ) then
				PTZProtocols[protocol.Attr.Name] = protocol;
			else 
				err = protocol;
			end
		end
		
		if err then
			print(
				string.format("Error while loading PTZ protocol:%s",err)
			);
		end;
	end

	-- ���ڼ���ָ��Ŀ¼�µ��ļ�
	local function LoadPtzProtocol(ptzPath)
		local ret, iter = pcall(lfs.dir, ptzPath);
		if ret then
			for filename in iter do
				if string.find(filename, ".lua") then
					loadPtzFile(ptzPath .. '/' .. filename);
				end;
			end;
		end;
	end	
	
	-- ����·�������µ������ļ�
	for _, path in pairs(PathSet) do 
		LoadPtzProtocol(path);
	end

	-- ������̨����Э������ƽ�������
	local t1 = {};
	for k,_ in pairs(PTZProtocols) do 
		table.insert(t1, k);
	end
	
	table.sort(t1);
	
	-- �Ѱ���ĸ�������̨����Э��ŵ�AllPTZProtocol����ӡЭ���嵥
	
	local ptzList = '';
	for k, v in pairs(t1) do 
		AllPTZProtocol[k] = PTZProtocols[v];
		if(ptzList ~= '') then
			ptzList = ptzList .. ',';
		end
		ptzList = ptzList .. v ;
	end
	print(string.format("The following PTZ protocols have been loaded:\n\t%s", ptzList));
	
	-- �����ܵ���̨����Э�����
	PTZCtrl.ProtocolCount = table.getn(AllPTZProtocol);
end


--[[
local function printstr(str)
		-- ��ӡ������
	local printstr = "";
	for i = 1, string.len(str) do
		printstr = printstr .. string.format("0x%02X ",string.byte(str,i));
	end;
	print(printstr);
end;

local function printtable(tab)
	local printtab = "";
	for i = 1, table.getn(tab) do
		printtab = printtab .. string.format("0x%02x ",tab[i]);
	end;
	print(printtab);
end;
--]]

-- �����ַ��������ַ������16����ת�����ַ����飬
local function str2chr(str)
	local retStr = "";

	-- �����ַ��Ļ�����ת����16����
	str = string.gsub(str, "'(.)'+", function(h)	return string.format("0x%02X", string.byte(h))end);
	
	-- ��16����ת�����ַ�
	for w in string.gfind(str, "(%w+)(,?)") do
		retStr = retStr .. string.char(tonumber(w, 16));		
	end;
	--printstr(retStr);
	return retStr;
end;



-- ���ַ������ֽ�ת���ɱ������Ҫ��Ϊ�������±�ֱ��ʹ�ã�ִ��У�鴦��
local function str2table(str)
	local RetTable = {};
	if string.len(str) <= 0 then
		return nil;
	end;
	
	str = str2chr(str);
	for i = 1, string.len(str) do
		RetTable[i] = string.byte(string.sub(str, i, i + 1));
	end;
	
	return RetTable;	
end;

-- ��̨֧�ֵ�ȫ������
local SupportedCommand = 
{
		--��׼����
		"Direction", "Zoom", "Focus", "Iris",
		
		--��չ����	
		-- ��ת
		"AlarmSearch",
		
		-- �ƹ�
		"Light",
		
		-- Ԥ�õ���������ã������ת��)
		"SetPreset", "ClearPreset", "GoToPreset",
		
		-- ˮƽ�Զ�
		"AutoPanOn", "AutoPanOff",
		 
		-- �Զ�ɨ�裬��Ԥ�����õı߽��м�ת��
		"SetLimit","AutoScanOn","AutoScanOff",		
			
		-- �Զ�Ѳ����һ��ָ��Ԥ�õ�֮��Ѳ��
		"AddTour", "DeleteTour", "StartTour", "StopTour", "ClearTour",
			
		-- �켣Ѳ��, һ��ָģʽ(���ÿ�ʼ�����ý��������У�ֹͣ�����ģʽ
		"SetPattern", "StartPattern", "StopPattern", "ClearPattern",
		
		-- ���ٶ�λ����
		"Position",	
		
		-- ��������
		"Aux",
			
		-- �˵���ز���
		"Menu", "MenuExit", "MenuEnter", "MenuEsc", "MenuUpDown", "MenuLeftRight",		
		
		-- �����л�
		"MatrixSwitch",
		
		-- ��ͷ��ת����̨��λ
		"Flip", "Reset",
		
		
		--�ƹ������
		"LightController",
		
		--���վ������궨λ
		"PositionAbs",
		
		
		--��̨�����ƶ���ʼ
		"ContinueStart",
		
		--��̨�����ƶ�ֹͣ
		"ContinueStop",	

		--��̨�����ƶ���ʼ
		"AbsoluteStart",
		
		--��̨�����ƶ�ֹͣ
		"AbsoluteStop",
		
}

local PTZOperateCommand =
{
	"LeftUp", "TileUp", "RightUp", "PanLeft", "PanRight", "LeftDown", "TileDown", "RightDown",		--1~8
	"ZoomWide", "ZoomTele", "FocusFar", "FocusNear", "IrisLarge", "IrisSmall", "AlarmSearch", "LightOn", "LightOff",	--9~17
	"SetPreset", "ClearPreset", "GoToPreset", "AutoPanOn", "AutoPanOff",		--18~22
	"SetLeftLimit", "SetRightLimit", "AutoScanOn", "AutoScanOff", 			--23~26
	"AddTour", "DeleteTour", "StartTour", "StopTour", "ClearTour",			--27~31
	"SetPatternStart", "SetPatternStop", "StartPattern", "StopPattern", "ClearPattern",		--32~36
	"Position",		--37
	"AuxOn", "AuxOff",	--38~39
	"Menu", "MenuExit", "MenuEnter", "MenuEsc", "MenuUp", "MenuDown", "MenuLeft", "MenuRight",	--40~47
	"MatrixSwitch",			--48
	"Flip", "Reset",		--49~50
	"MATRIX_SWITCH", "LIGHT_CONTROLLER", "SETPRESETNAME", "ALARMPTZ", 		--51~54
	"STANDARD", "AutoFocus", "AutoIris",			--55~57
	" ", " ",					--58~59
	"PositionAbs",				--60
	" ", " ", " ", " ", " ", " ", " ", " ",											--61~68
	" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",											--69~78
	" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",											--79~88
	" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",											--89~98
	" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",											--99~108
	" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",											--109~118	
	" ", " ", " ", " ", " ", " ", " ", " ", " ", "ContinueStart",								--119~128
	"ContinueStop", "AbsoluteStart", "AbsoluteStop",											--129~131
}

-- ȡ��SupportedCommand���ñ�
local RevCommand = {};
for i,v in ipairs(SupportedCommand) do
	RevCommand[v] = i;
end; 

local RevOperateCommand ={};
for i,v in ipairs(PTZOperateCommand) do
	RevOperateCommand[v] = i;
end; 

-- �õ�֧�ֵ�Э�����
local function GetProtocolNum()
	return table.getn(AllPTZProtocol);
end;

--[[
�õ�ָ��Э�������
param:
	index:Э������������±�1��ʼ
--]]
local function GetProtocolAttr(index)
	local tmpPTZ = {};
	local Attr = {}; 
	if (index > 0) and (index <= table.getn(AllPTZProtocol)) then
		tmpPTZ = AllPTZProtocol[index];
		Attr = tmpPTZ.Attr;
	end;
	
	--[[ �������C�����ݽṹȡֵʱ�ã����������������
	local RetSeq = {"HighMask", "LowMask", "Name",  "CamAddrMin", "CamAddrMax", 
		"MonAddrMin", "MonAddrMax", 	"PresetMin", "PresetMax", "TourMin", "TourMax", "PatternMin", "PatternMax",
		"TileSpeedMin", "TileSpeedMax", "PanSpeedMin", "PanSpeedMax",
		"AuxMin","AuxMax", "Internal", "Type", "AlarmLen"};		
	--]]
		
	-- ˳�򲻸���
	local ptztype = {"PTZ","MATRIX"};
	local revtype ={};
	for k, v in pairs(ptztype) do
		revtype[v] = k;
	end;
	
	local RetAttr = {};	

	RetAttr["Name"] 			= string.sub(Attr.Name, 1, 15);
	RetAttr["Type"] 			= revtype[Attr.Type];
	RetAttr["Internal"]			= Attr.Internal;
	RetAttr["CamAddrMin"] 		= Attr.CamAddrRange[1];
	RetAttr["CamAddrMax"] 		= Attr.CamAddrRange[2];
	RetAttr["MonAddrMin"] 		= Attr.MonAddrRange[1];
	RetAttr["MonAddrMax"] 		= Attr.MonAddrRange[2];
	RetAttr["PresetMin"]	 	= Attr.PresetRange[1];
	RetAttr["PresetMax"]	 	= Attr.PresetRange[2];
	RetAttr["TourMin"] 			= Attr.TourRange[1];
	RetAttr["TourMax"]			= Attr.TourRange[2];
	RetAttr["PatternMin"]		= Attr.PatternRange[1];
	RetAttr["PatternMax"]		= Attr.PatternRange[2];
	RetAttr["TileSpeedMin"]		= Attr.TileSpeedRange[1];
	RetAttr["TileSpeedMax"]		= Attr.TileSpeedRange[2];
	RetAttr["PanSpeedMin"] 		= Attr.PanSpeedRange[1];
	RetAttr["PanSpeedMax"] 		= Attr.PanSpeedRange[2];
	RetAttr["AutoScanMin"] 		= Attr.ScanRange[1];
	RetAttr["AutoScanMax"] 		= Attr.ScanRange[2];
	RetAttr["AuxMin"] 			= Attr.AuxRange[1];
	RetAttr["AuxMax"] 			= Attr.AuxRange[2];
	RetAttr["AlarmLen"]     = Attr.AlarmLen or 0;

	-- �������������룬����ǰ��4���Ǳ�׼���һ��֧��
	local highmask = 0;
	local lowmask = 0xf;
	local hexbit = 0x8;
	local operatemask = lowmask;
	for i = 5, table.getn(SupportedCommand) do
		hexbit = hexbit * 2;
		if i == 33 then 
			hexbit = 1;	
			operatemask = 0;		
		end;
		local tmpTable = tmpPTZ.Command.Start;
		if i == RevCommand["Light"] then
			if tmpTable["LightOn"] or tmpTable["LightOff"] then
				operatemask = operatemask + hexbit;
			end;
		elseif i == RevCommand["SetLimit"] then
			if tmpTable["SetLeftLimit"] or tmpTable["SetRightLimit"] then
				operatemask = operatemask + hexbit;
			end;
		elseif i == RevCommand["SetPattern"] then
			if tmpTable["SetPatternStart"] or tmpTable["SetPatternStop"] then
				operatemask = operatemask + hexbit;
			end;
		elseif i == RevCommand["Aux"] then
			if tmpTable["AuxOn"] or tmpTable["AuxOff"] then
				operatemask = operatemask + hexbit;
			end;
		elseif i == RevCommand["MenuUpDown"] then
			if tmpTable["MenuUp"] or tmpTable["MenuDown"] then
				operatemask = operatemask + hexbit;
			end;	
		elseif i == RevCommand["MenuLeftRight"] then
			if tmpTable["MenuLeft"]	or tmpTable["MenuRight"] then
				operatemask = operatemask + hexbit;
			end;	
		else
				if tmpTable[SupportedCommand[i]] then
					operatemask = operatemask + hexbit;
				end;
			end;
		if i <= 32 then
			lowmask = operatemask;
			--print(string.format("for lowmask = %x", lowmask));
		else
			highmask = operatemask;
			--print("highmask = ", highmask);
		end;
	end
	--print(string.format("supported Operate %x",operatemask));	
	RetAttr["HighMask"] 					= highmask;
	RetAttr["LowMask"]						= lowmask;
	-- print(string.format("lowmask = %x", lowmask));
	-- print(string.format("lowmask = %x", highmask));
		
	return RetAttr;
end;

--[[
�����ַ��Ϣ
��ִ�������ַ����û�еĻ�����ͨ�÷�ʽ����
--]]
local function CamAddrProcess(opttable, addr)
	if not opttable then
		print("opttable is nill");
	end;
	-- �ȳ������⴦��
	if SelectedPTZ.CamAddrProcess then
		return SelectedPTZ.CamAddrProcess(opttable, addr);
	else
		-- ��ʼͨ������
		local addr = math.mod(addr,256);
		opttable[SelectedPTZ.CommandAttr.AddrPos] = addr;
		--printtable(OperateTable[key][k]);
		return opttable;
	end;
end;

--[[
�����������ַ�������⴦��Ŀǰ��û��ͨ�ð취
--]]
local function MonAddrProcess(opttable,addr)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.MonAddrProcess then
		return SelectedPTZ.MonAddrProcess(opttable, addr);
	else
		return opttable;
	end;
end;

--[[
����Э����Ϣ������Ӧ��Э������
param:
	index��ָ���ĸ�Э�飬���±�1��ʼ
	addr:	���õĵ�ַ����,ֱ����16����ֵ
--]]
local function SetProtocol(index, camaddr, monaddr)
	-- ���Э��
	if (index <= 0) or (index > table.getn(AllPTZProtocol)) or not camaddr then
		print("the Procotol isn't exist or the Camera's addr isn't exist");
		SelectedPTZ = nil;
		return;
	end;
		
	SelectedPTZ = AllPTZProtocol[index];

	
	-- �õ�������
	OperateTable = SelectedPTZ.Command;	
	
	CamAddr = math.abs(camaddr);
	if monaddr then
		MonAddr = math.abs(monaddr);
	end;

end;

--[[
�����������ֵ
--]]
local function GetCMDTable(cmd)
	local RetTable = {};
	--print(cmd);
	if type(cmd) == "string" then
		RetTable = str2table(cmd);
	elseif type(cmd) == "table" then
		RetTable = cmd;
	else
		return nil;
	end;
	
	-- ������̨��ַ��Ϣ
	RetTable = CamAddrProcess(RetTable, CamAddr);

	-- �����������ַ
	if MonAddr then
		RetTable = MonAddrProcess(RetTable, MonAddr);
	end;

	return RetTable;
	
end;

--[[
�����ٶ�,�����⴦���ʹ�����⴦��û�еĻ�ʹ��ͨ�ô���
arg1: ��ֱ�����ٶ�
arg2: ˮƽ�����ٶ�
--]]
local function SpeedProcess(opttable, arg1, arg2)
	if not opttable then
		print("opttable is nil");
	end;
	local res = SelectedPTZ.SpeedProcess;
	if res then
		return SelectedPTZ.SpeedProcess(opttable, arg1, arg2);
	else
		opttable[SelectedPTZ.CommandAttr.TileSpeedPos] = math.abs(arg1);
		opttable[SelectedPTZ.CommandAttr.PanSpeedPos] = math.abs(arg2);
		return opttable;
	end;
end;
--[[
��������Ŀǰ֧�ֵĲ��࣬�������⴦��
--]]
local function MultipleProcess(opttable, multiple)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.MultipleProcess then
		return SelectedPTZ.MultipleProcess(opttable, multiple);
	else
		return opttable;
	end;
end;


--[[
����Ԥ�õ㣬�����⴦���ʹ�����⴦��û�еĻ�ʹ��ͨ�ô���
param
	arg2:��ʱ����
--]]
local function PresetProcess(opttable, arg1)
	if not opttable then
		print("opttable is nil");
	end;
	local res = SelectedPTZ.PresetProcess;
	if res then
		return SelectedPTZ.PresetProcess(opttable, arg1);
	else
		opttable[SelectedPTZ.CommandAttr.PresetPos] = math.abs(arg1);
		return opttable;
	end;
end;

local function SetTourProcess(opttable, tour, preset)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.SetTourProcess then
		return SelectedPTZ.SetTourProcess(opttable, tour, preset);
	else
		return opttable;
	end;
end;
--[[
�����Զ�Ѳ��·��
--]]
local function TourProcess(opttable, tour)
	if not opttable then
		print("opttable is nill");
	end;
	if SelectedPTZ.TourProcess then
		return SelectedPTZ.TourProcess(opttable, tour);
	else
		return opttable;
	end;
end;

--[[
����켣
--]]
local function PatternProcess(opttable, num)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.PatternProcess then
		return SelectedPTZ.PatternProcess(opttable, num);
	else
		return opttable;
	end;
end;

--[[
������ٶ�λ
--]]
local function PositionProcess(opttable, hor, ver, zoom)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.PositionProcess then
		return SelectedPTZ.PositionProcess(opttable, hor, ver, zoom);
	else
		return opttable;
	end;
end;
 
 --[[
��̨�����ƶ�
arg1:ˮƽ�ٶ�
arg2����ֱ�ٶ�
arg3��ZOOM�ٶ�
T����ʱʱ��
--]]
local function ContinueStartProcess(opttable, arg1, arg2, arg3, T)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.ContinueStartProcess then
		return SelectedPTZ.ContinueStartProcess(opttable, arg1, arg2, arg3, T);
	else
		return opttable;
	end;
end;

--[[
��̨�����ƶ�
arg1:ˮƽ�ٶ�+ˮƽ����
arg2����ֱ�ٶ�+��ֱ����
arg3��ZOOM�ٶ�+ZOOM����
--]]
local function AbsoluteStartProcess(opttable, arg1, arg2, arg3)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.AbsoluteStartProcess then
		return SelectedPTZ.AbsoluteStartProcess(opttable, arg1, arg2, arg3);
	else
		return opttable;
	end;
end;

--[[
��̨��ȷ��λ
--]]
local function PositionAbsProcess(opttable, arg1, arg2, arg3, T)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.PositionAbsProcess then
		return SelectedPTZ.PositionAbsProcess(opttable, arg1, arg2, arg3, T);
	else
		return opttable;
	end;
end;

--[[
������ɨ��߽�
--]]
local function SetLeftLimitProcess(opttable, arg1)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.SetLeftLimitProcess then
		return SelectedPTZ.SetLeftLimitProcess(opttable, arg1);
	else
		return opttable;
	end;
end;

--[[
������ɨ�ұ߽�
--]]
local function SetRightLimitProcess(opttable, arg1)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.SetRightLimitProcess then
		return SelectedPTZ.SetRightLimitProcess(opttable, arg1);
	else
		return opttable;
	end;
end;

--[[
��ʼ�Զ���ɨ
--]]
local function AutoScanOnProcess(opttable, arg1)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.AutoScanOnProcess then
		return SelectedPTZ.AutoScanOnProcess(opttable, arg1);
	else
		return opttable;
	end;
end;

--[[
��ֹ̨ͣ�ƶ�
style:ֹͣ���ͣ�1��ֹͣˮƽ/��ֱ 2��ֹͣZoom 3��ֹͣˮƽ/��ֱ/ZOOM
--]]
local function StopProcess(opttable,style)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.StopProcess then
		return SelectedPTZ.StopProcess(opttable, style);
	else
		return opttable;
	end;
end;
 
--[[
�������ش���
--]]
local function AuxProcess(opttable, num)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.AuxProcess then
		return SelectedPTZ.AuxProcess(opttable, num);
	else
		opttable[SelectedPTZ.CommandAttr.AuxPos] = num;
		return opttable;
	end;
end;

--[[
�����л�����
arg1: ��������ַ
arg2: ��̨��ַ
--]]
local function SwitchProcess(opttable, MonAddr, CamAddr)
	local rettable = {};
	rettable = MonAddrProcess(opttable, MonAddr);
	rettable = CamAddrProcess(rettable, CamAddr);
	return rettable;
end;

--[[
��ѯ����
arg:��ѯ����
searchtype:��ѯ����
--]]
local function SearchProcess(opttable, arg, searchtype)
	if not opttable then
		print("opttable is nil");
	end;
	if SelectedPTZ.SearchProcess then
		return SelectedPTZ.SearchProcess(opttable, arg);
	else
		return opttable;
	end;
end;

--[[
�������������ҳ���Ӧ������������ò���
param:
	OpeTable:���������
	cmd:	ָ���������±�
	arg1:
	arg2:���ĵ�
--]]
local function Parse(opttable, cmd, arg1, arg2, arg3, reserved)
	local PTZCommand = nil;
	if (cmd <= 0) or (cmd > table.getn(PTZOperateCommand)) then
		print("out of command\n");
		return nil;
	end;
	--print(PTZOperateCommand[cmd]);
	if not opttable[PTZOperateCommand[cmd]] then
		return nil;
	end;
	PTZCommand = GetCMDTable(opttable[PTZOperateCommand[cmd]]);	
	--printtable(PTZCommand);
	-- ������
	if cmd >= RevOperateCommand["LeftUp"] and cmd <= RevOperateCommand["RightDown"] then
		if cmd == RevOperateCommand["TileUp"] or cmd == RevOperateCommand["TileDown"] then
			PTZCommand = SpeedProcess(PTZCommand, arg1, 0);
		elseif cmd == RevOperateCommand["PanLeft"] or cmd == RevOperateCommand["PanRight"] then
			PTZCommand = SpeedProcess(PTZCommand, 0, arg1);
		else
			PTZCommand = SpeedProcess(PTZCommand, arg1, arg2);
		end;
	-- ������
	elseif cmd >= RevOperateCommand["ZoomWide"] and cmd <= RevOperateCommand["IrisSmall"] then
			PTZCommand = MultipleProcess(PTZCommand, arg1);
	-- �������ã������ת��Ԥ�õ�
	elseif cmd >= RevOperateCommand["SetPreset"] and cmd <= RevOperateCommand["GoToPreset"] then
		PTZCommand = PresetProcess(PTZCommand, arg1);
	-- �������Ԥ�õ㵽Ѳ������
	elseif cmd == RevOperateCommand["AddTour"] or cmd == RevOperateCommand["DeleteTour"] then
		PTZCommand = SetTourProcess(PTZCommand, arg1, arg2);
	elseif cmd == RevOperateCommand["StartTour"] or cmd == RevOperateCommand["ClearTour"] then
		PTZCommand = TourProcess(PTZCommand, arg1);
	-- ��������ģʽ
	elseif cmd >= RevOperateCommand["SetPatternStart"] and cmd <= RevOperateCommand["ClearPattern"] then
		PTZCommand = PatternProcess(PTZCommand, arg1);
	-- ������ٶ�λ
	elseif cmd == RevOperateCommand["Position"] then
		PTZCommand = PositionProcess(PTZCommand, arg1, arg2, arg3);
	--��ȷ��λ
	elseif cmd == RevOperateCommand["PositionAbs"] then
		PTZCommand = PositionAbsProcess(PTZCommand, arg1, arg2, arg3, reserved);
	--������ɨ��߽�
	elseif cmd == RevOperateCommand["SetLeftLimit"] then
		print("Run in LUA SetLeftLimit Operation");	
		PTZCommand = SetLeftLimitProcess(PTZCommand, arg1);
	--������ɨ�ұ߽�
	elseif cmd == RevOperateCommand["SetRightLimit"] then
		PTZCommand = SetRightLimitProcess(PTZCommand, arg1);
	--��ʼ�Զ���ɨ
	elseif cmd == RevOperateCommand["AutoScanOn"] then
		PTZCommand = AutoScanOnProcess(PTZCommand, arg1);
	-- ����������
	elseif cmd == RevOperateCommand["AuxOn"] or cmd == RevOperateCommand["AuxOff"] then
		PTZCommand = AuxProcess(PTZCommand, arg1);
	-- ��������л� 
	elseif cmd == RevOperateCommand["MatrixSwitch"] then
		PTZCommand = SwitchProcess(PTZCommand, arg1, arg2);
	elseif cmd == RevOperateCommand["AlarmSearch"] then
		PTZCommand = SearchProcess(PTZCommand, arg1, arg2);
	-- ��������ƶ�
	elseif cmd == RevOperateCommand["ContinueStart"] then
		PTZCommand = ContinueStartProcess(PTZCommand, arg1, arg2,arg3,reserved);
		return PTZCommand;
	-- ��������ƶ�
	elseif cmd == RevOperateCommand["AbsoluteStart"] then
		PTZCommand = AbsoluteStartProcess(PTZCommand, arg1, arg2,arg3);
		return PTZCommand;
	-- ��ֹ̨ͣ����
	elseif cmd == RevOperateCommand["ContinueStop"] or cmd == RevOperateCommand["AbsoluteStop"] then
		PTZCommand = StopProcess(PTZCommand, arg1);
		return PTZCommand;
	end;
	
	if PTZCommand then
		if SelectedPTZ.SpecialProcess then
			local cmd = SelectedPTZ.SpecialProcess(PTZCommand, arg1, arg2, arg3);
			if  cmd then
				return cmd;
			end;
		end;
			return SelectedPTZ.Checksum(PTZCommand);		
	end;

end;

--[[
��̨����ָ��
param:
	cmd:��̨����,SupportedCommand���±�
	arg1:����1
	arg2:����2�������ľ��庬����ĵ�
	arg3:
--]]
local function StartPTZ(cmd, arg1, arg2, arg3, reserved)

	local PTZCommand = Parse(SelectedPTZ.Command.Start, cmd, arg1, arg2, arg3, reserved);	
	
	if PTZCommand then
		--printtable(PTZCommand);
		return PTZCommand, table.getn(PTZCommand);
	end;

end;

local function StopPTZ(cmd, arg1, arg2, arg3, reserved)
	local PTZCommand = Parse(SelectedPTZ.Command.Stop, cmd, arg1, arg2, arg3, reserved);
	
	if PTZCommand then
		-- д�����ݵ���̨����
		--printtable(PTZCommand);
		return PTZCommand, table.getn(PTZCommand);
	end;
end;

local function test()
print("Protocol Num = " .. GetProtocolNum());
for i = 1, GetProtocolNum() do
	local attr = GetProtocolAttr(i);
	SetProtocol(i,1);

	for j=1, table.getn(SupportedCommand) do
		if bits.band(attr.LowMask, bits.lshift(1, j-1)) == bits.lshift(1,j-1) then
		StartPTZ(j, 31, 0, 1);
	end;
--	StopPTZ(j, -63,63,1);
	end;
end;
end;

local function LoadProtocols()
	buildPtzList(PTZCtrl.PathSet);
end

PTZCtrl.LoadProtocols   = LoadProtocols;
PTZCtrl.GetProtocolNum  = GetProtocolNum;
PTZCtrl.GetProtocolAttr = GetProtocolAttr;
PTZCtrl.SetProtocol     = SetProtocol;
PTZCtrl.StartPTZ        = StartPTZ;
PTZCtrl.StopPTZ         = StopPTZ;
PTZCtrl.PTZProtocol     = AllPTZProtocol;
PTZCtrl.buildPtzList    = buildPtzList;

return PTZCtrl;

--
-- "$Id: PTZCtrl.lua 1136 2008-08-02 06:05:52Z yang_bin $"
--
