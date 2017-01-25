--   "$Id: PTZCtrl.lua 1136 2008-08-02 06:05:52Z yang_bin $"
--   (c) Copyright 1992-2005, ZheJiang Dahua Information Technology Stock CO.LTD.
--                            All Rights Reserved
--
--	�� �� ���� COMMCtrl.lua
--	��    ��:  RS��������RS 485����Э��ű�
--   
local AllCOMMProtocol = {}; 		-- �������кźͶ�Ӧ���ļ���
local SelectedCOMM = {}; 		-- ���潫Ҫ������Э��
local CamAddr = nil; 			-- ����Э��Ĵ��ڵ�ַ
local MonAddr = nil; 			-- ������ӵ�ַ

local COMMCtrl = {};
COMMCtrl.PathSet = {};

-- �������еĴ���Э��ű�
local function buildCommList(PathSet)
	local COMMProtocols = {};
	
	-- ���ڼ��ص����Ĵ���Э���ļ�
	local function loadCommFile(filename)
		local f,err = loadfile(filename);
		if f then
			local ret, protocol;
			ret, protocol = pcall(f);
			if( ret ) then
				COMMProtocols[protocol.Attr.Name] = protocol;
			else 
				err = protocol;
			end
		end
		
		if err then
			print(
				string.format("Error while loading COMM protocol:%s",err)
			);
		end;
	end	
	
	-- ���ڼ���ָ��Ŀ¼�µ��ļ�
	local function LoadCommProtocol(commPath)
		local ret, iter = pcall(lfs.dir, commPath);
		if ret then
			for filename in iter do
				if string.find(filename, ".lua") then
					loadCommFile(commPath .. '/' .. filename);
				end;
			end;
		end;
	end	
	
	-- ����·�������µ������ļ�
	for _, path in pairs(PathSet) do 
		LoadCommProtocol(path);
	end

	-- ���ݴ���Э������ƽ�������
	local t1 = {};
	for k,_ in pairs(COMMProtocols) do 
		table.insert(t1, k);
	end
	
	table.sort(t1);
	
	-- �Ѱ���ĸ����Ĵ���Э��ŵ�AllCOMMProtocol����ӡЭ���嵥
	
	local commList = '';
	for k, v in pairs(t1) do 
		AllCOMMProtocol[k] = COMMProtocols[v];
		if(commList ~= '') then
			commList = commList .. ',';
		end
		commList = commList .. v ;
	end
	print(string.format("The following COMM protocols have been loaded:\n\t%s", commList));
	
	-- �����ܵĴ���Э�����
	COMMCtrl.ProtocolCount = table.getn(AllCOMMProtocol);
end


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


-- �õ�֧�ֵ�Э�����
local function GetCommProtocolNum()
	return table.getn(AllCOMMProtocol);
end;

--[[
�õ�ָ��Э�������
param:
	index:Э������������±�1��ʼ
--]]
local function GetCommProtocolAttr(index)
	local tmpCOMM = {};
	local Attr = {}; 
	if (index > 0) and (index <= table.getn(AllCOMMProtocol)) then
		tmpCOMM = AllCOMMProtocol[index];
		Attr = tmpCOMM.Attr;
	end;
	
	--[[ �������C�����ݽṹȡֵʱ�ã����������������
	local RetSeq = {"Name", "Type"};		
	--]]
		
	-- ˳�򲻸���
	local commtype = {"RS232","RS485"};
	local revtype ={};
	for k, v in pairs(commtype) do
		revtype[v] = k;
	end;
	
	local RetAttr = {};	

	RetAttr["Name"] 			= string.sub(Attr.Name, 1, 15);
	RetAttr["Type"] 			= revtype[Attr.Type];
		
	return RetAttr;
end;

local function CamAddrProcess(opttable, addr)
	if not opttable then
		print("opttable is nill");
	end;
	-- �ȳ������⴦��
	if SelectedCOMM.CamAddrProcess then
		return SelectedCOMM.CamAddrProcess(opttable, addr);
	else
		-- ��ʼͨ������
		local addr = math.mod(addr,256);
		opttable[SelectedCOMM.CommandAttr.AddrPos] = addr;
		--printtable(OperateTable[key][k]);
		return opttable;
	end;
end;

--[[
����Э����Ϣ������Ӧ��Э������
param:
	index��ָ���ĸ�Э�飬���±�1��ʼ
	addr:	���õĵ�ַ����,ֱ����16����ֵ
--]]
local function SetCommProtocol(index, camaddr, monaddr)
	-- ���Э��
	if (index <= 0) or (index > table.getn(AllCOMMProtocol)) or not camaddr then
		print("the Procotol isn't exist or the Camera's addr isn't exist");
		SelectedCOMM = nil;
		return;
	end;
		
	SelectedCOMM = AllCOMMProtocol[index];

	
	-- �õ�������
	OperateTable = SelectedCOMM.Command;	
	
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
	
	-- �����ڵ�ַ��Ϣ
	RetTable = CamAddrProcess(RetTable, CamAddr);

	return RetTable;
	
end;


--[[
�������������ҳ���Ӧ������������ò���
param:
	OpeTable:���������
	cmd:	ָ���������±�
	arg1:
	arg2:���ĵ�
--]]
local function Parse(opttable, cmd, arg1, arg2, arg3)
	local COMMCommand = nil;
	if (cmd <= 0) or (cmd > table.getn(COMMOperateCommand)) then
		print("out of command\n");
		return nil;
	end;

	--print(COMMOperateCommand[cmd]);
	if not opttable[COMMOperateCommand[cmd]] then
		return nil;
	end;

local function test()
print("Protocol Num = " .. GetCommProtocolNum());
for i = 1, GetCommProtocolNum() do
	local attr = GetCommProtocolAttr(i);
--	SetCommProtocol(i,1);
	end;
end;
end;

local function LoadCommProtocols()
	buildCommList(COMMCtrl.PathSet);
end

COMMCtrl.LoadCommProtocols   = LoadCommProtocols;
COMMCtrl.GetCommProtocolNum  = GetCommProtocolNum;
COMMCtrl.GetCommProtocolAttr = GetCommProtocolAttr;
COMMCtrl.SetCommProtocol     = SetCommProtocol;
COMMCtrl.COMMProtocol     = AllCOMMProtocol;
COMMCtrl.buildCommList    = buildCommList;

return COMMCtrl;

--
-- "$Id: PTZCtrl.lua 1136 2008-08-02 06:05:52Z yang_bin $"
--

