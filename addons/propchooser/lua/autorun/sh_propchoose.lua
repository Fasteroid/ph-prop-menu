local function CheckGamemodeName(name, GameMode)
	local gm = string.lower(GameMode.Name)
	
	if (string.find(gm, name)) then
		return true
	end
	
	return false
end

local path = {
	["prop_hunt"] 			= true,
	["prop_hunt_reborn"]	= true -- placeholder. I'm not even making this gamemode.
}
local function CheckGamemodePath()
	if path[engine.ActiveGamemode()] then
		return true
	end
	
	return false
end

hook.Add("Initialize","CheckPHEifExists",function()
	if ( CheckGamemodePath() and CheckGamemodeName( "enhanced", GAMEMODE ) ) then
		if SERVER then
			AddCSLuaFile("propchoose/sh_propchoose.lua")
			AddCSLuaFile("propchoose/sh_meta.lua")
			AddCSLuaFile("propchoose/cl_propchoose.lua")
			AddCSLuaFile("propchoose/sh_cmd.lua")
			
			include("propchoose/sh_propchoose.lua")
			include("propchoose/sh_meta.lua")
			include("propchoose/sv_propchoose.lua")
			include("propchoose/sh_cmd.lua")
			
			print("[Prop Chooser] [*] Serverside Functions Successfully Initialized.")
		else
			include("propchoose/sh_propchoose.lua")
			include("propchoose/sh_meta.lua")
			include("propchoose/cl_propchoose.lua")
			include("propchoose/sh_cmd.lua")
			print("[Prop Chooser] [*] Successfully Initialized.")
		end
	else
		print("[Prop Chooser] !!Cannot initialize Prop Chooser because it's currently not running on Prop Hunt: Enhanced!")
		print("[Prop Chooser] Make sure the following gamemode path must be named as 'prop_hunt'. DO NOT RENAME ANY OTHER GAEMMODES INTO 'prop_hunt' OR THIS WONT WORK!")
		print("[Prop Chooser] This addon currently may not supported with any other prop hunt versions!")
	end
end)