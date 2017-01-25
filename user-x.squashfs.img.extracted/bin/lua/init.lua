--   "$Id: init.lua 1147 2008-08-04 00:50:34Z yang_bin $"
--   (c) Copyright 1992-2005, ZheJiang Dahua Information Technology Stock CO.LTD.
--                            All Rights Reserved
--
--	�� �� ���� init.lua
--	��    ��:  �����ű�
--	�޸ļ�¼�� 2005-10-11 ������ <wanghw@dhmail.com> ����ԭ���İ汾�Գ�����������,�ṹ����������
--             2008-08-01 ������ ɾ������Ľű�����
-- 
local basePath   = "/usr/bin/lua";
local user_config_path = "/mnt/mtd/Config";	-- ����û���������Ϣ��·��

LUA_PATH = basePath .. "/?.lua;";

require("compat-5.1");
pcall(require, "compat-5.1");
	   
Global = {};

--���ش��ڵĽ����ű�
local commCtrl = dofile(basePath .. "/COMMCtrl.lua");
commCtrl.PathSet = {basePath .. "/comm",
	user_config_path .. "/commPlugin",
}

Global.CommCtrl = commCtrl;

-- ���ش��ڵĽ����ű����¼���ͣ����ר�ã�
local ret, ParseCom = pcall(dofile, basePath .. "/ParseDVRStr.lua");
if ret then
	Global.ParseCom = ParseCom;
end;

-- ������̨�Ľ����ű�
local ptzCtrl = dofile(basePath .. "/PTZCtrl.lua");
ptzCtrl.PathSet = {basePath .. "/ptz", 
	user_config_path .. "/ptzPlugin",
}

Global.PtzCtrl= ptzCtrl; 

--
-- "$Id: init.lua 1147 2008-08-04 00:50:34Z yang_bin $"
--
