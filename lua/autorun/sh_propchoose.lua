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