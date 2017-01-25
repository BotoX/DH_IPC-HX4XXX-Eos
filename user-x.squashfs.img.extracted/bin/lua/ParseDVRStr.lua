-- �������ļ����¼���ͣ����ʹ�õĽű�

local COM = {};

local RetInfo = 
{
	cardno = 1, serialno = 2, transaction_type = 3, 
	transaction_amount = 4, transaction_time = 5, machineno = 6,
	emendtime = 0xa0, clear = 0xfd, startrec = 0xfe, stoprec=0xff
};

local stx = "\02"; -- ��ʼ�ַ�
local etx = "\03"; -- �����ַ�
local receivedata = {"01", "03", "05"};
local responcedata = {"02", "04", "06"};

local DataLength = 1;
local unsettledstr = "";

local channel = 0xff;
local cardnumber = "";

-- ����ͷ�ĳ����ж��ǲ���ͷ���ǵĻ�Ӧ�ó�����������ݣ����ǵĻ�����ͷ���
local function ParseHead(szStr)
	-- ���ﲻ�жϣ�ֱ�ӷŽ������������ж�
	return 1;
end;

local function FormatTime(s)
	-- ��ʱ��ת��ΪC�ĸ�ʽ����ASCII���ʾ��YYYYMMDDHHMMSS+�������SΪ��λ, û����Ļ���0��ʾ
	local str = "";
	for number in string.gfind(s, "(%d+)") do
		str = str .. number;
	end;
	if str == "" then
		str = s;
	end;
	str = str.."300";
	print(str);
	return str;
end;

local function ClearCardNo()
	cardnumber = "";
end;

local function DataProcess(str)
	print(str);
	local writestr = stx;
	if string.len(str) < 2 then
		return;
	end;
	local result = true;
	
	local cmd = string.sub(str, 1, 2);
	if cmd == receivedata[1] then
		writestr = writestr .. responcedata[1];
		result = true;
	elseif cmd == receivedata[2] then
		local systemtime;
		for systemtime in string.gfind(str, "|(.+)(|?)") do
			systemtime = FormatTime(systemtime);
			result  = COM.ExtraProcess(RetInfo.emendtime, channel, systemtime);	
		end;		
		 writestr = writestr .. responcedata[2];	
	elseif cmd ==  receivedata[3] then
		local opt = {"id", "number", "time"};
		local id, number, time;

		local tmptable = {};
		local i = 0;
		while true do
			i = string.find(str, "|", i+1)
			if i == nil then
				table.insert(tmptable,string.len(str)+1);
				break;
			end;
			table.insert(tmptable,i);
		end;
		
		local index = 0;
		for j = 1, table.getn(tmptable)-1 do
			index = index + 1;
			local w = string.sub(str, tmptable[j]+1, tmptable[j+1]-1);
			if opt[index] == "id" then
				id = w;
			elseif opt[index] == "number" then
				number = w;
			elseif opt[index] == "time" then
				time = w;
			else 
				return;
			end;
		end;
		
		if number then
			if number ~= cardnumber then
				if COM.ExtraProcess(RetInfo.startrec, channel, " ") then
				 	cardnumber = number;
				end;
			end;
			result = result and COM.AppendCard(RetInfo.cardno, channel, number);
		end;
		
		if id then
			result = result and COM.AppendCard(RetInfo.machineno, channel, id);	
		end;
		
		if time then
			result = result and COM.AppendCard(RetInfo.transaction_time, channel, time);
		end;	

		writestr = writestr .. responcedata[3];	
	
		if writestr ~= stx then
			if result == true then
				writestr = writestr .. "|OK";
			else
				writestr = writestr .. "|ER";
			end;
			writestr = writestr .. etx;
			local checksum = 0;
			for i = 2, string.len(writestr) do
				checksum = bits.bxor(checksum, string.byte(string.sub(writestr, i, i)));
			end;
			writestr = writestr .. string.char(checksum);
			COM.ComWrite(writestr);
		end;
	end;
end;

--[[
	�������ݣ�ע����ʹ��AppendCard��ExtraProcessʱ����COM.����Ϊ������������Cע��������
--]]
local function ParseData(szStr)
	if (string.len(szStr) ~= DataLength) then	
		return;
	end;
	
	local str = unsettledstr .. szStr;
	
	if string.sub(str, 1, 1) ~= stx then
		unsettledstr = "";
	end;
	
	if string.len(str) >= 3 then
		if string.sub(str, -2, -2) == etx then
			-- ����У����
			local checksum = 0;
			for i = 2, string.len(str) - 1 do
				checksum = bits.bxor(checksum, string.byte(string.sub(str, i, i)));
			end;
			if checksum == string.byte(string.sub(str, -1, -1)) then
				DataProcess(string.sub(str, 2, -3));
			end;
			--print(checksum, string.byte(string.sub(str, -1, -1)));			
			unsettledstr = "";
			return;
		end;
	end;
	
	unsettledstr = str;

end;

COM = 
{
	HeadLength	= 1,
	DataLength 	= DataLength,
	ParseHead	= ParseHead,	
	ParseData	= ParseData,
	ClearCardNo	= ClearCardNo,
	AlarmTime	= 20,	
}

local function test(str)
	ParseData("\02")
	for i = 1, string.len(str) do
		ParseData(string.sub(str, i, i));
	end;
end;



--test("01\03\02");

--test("03|2004-12-17 10:00:01\03\95");

--test("05|01|1025241819|2004-12-17 15:32:48\03\80");

return COM;