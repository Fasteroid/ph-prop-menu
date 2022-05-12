function PCR.ReadBannedProps()
	local path = "phe_config/prop_model_bans"
	
	if !file.Exists(path,"DATA") then
		print("[Prop Chooser] !!WARNING : Prop Hunt: Enhanced's Prop Ban Data does not exists. Did you forgot to install Prop Hunt: Enhanced? Creating the folder anyway...")
		file.CreateDir(path)
	end
	
	if file.Exists(path.."/model_bans.txt","DATA") then
		local read = util.JSONToTable(file.Read(path.."/model_bans.txt"))
		for _,mdl in pairs(read) do
			table.insert(PCR.BannedProp, mdl)
		end
	else
		print("[Prop Chooser] !!WARNING: Prop Hunt: Enhanced's Prop Ban Data does not exists, Ignoring...")
	end
	
	if file.Exists(path.."/pcr_bans.txt","DATA") then
		local read = util.JSONToTable(file.Read(path.."/pcr_bans.txt"))
		for _,mdl in pairs(read) do
			table.insert(PCR.BannedProp, mdl)
		end
	else
		print("[Prop Chooser] !!WARNING: Prop Chooser additional prop bans data does not exists, Creating new one...")
		
		local proplist = { "models/player.mdl", "models/player/kleiner.mdl" }
		local json = util.TableToJSON(proplist,true)
		file.Write(path.."/pcr_bans.txt", json)
		
		print("[Prop Chooser] File successfully created on: phe_config/prop_model_bans/pcr_bans.txt.")
	end
end

function PCR.CheckBBox(entity)
	local min,max = entity:GetCollisionBounds()
	if math.Round(max.x) >= PCR.CVAR.MaxBBOXWidth:GetInt() or
		math.Round(max.y) >= PCR.CVAR.MaxBBOXWidth:GetInt() or 
		math.Round(max.z) >= PCR.CVAR.MaxBBOXHeight:GetInt() then 
			return true 
	end
	return false
end

function PCR.GetCustomProps()
	local path = "phe_config/prop_chooser_custom"
	
	if !file.Exists(path,"DATA") then
		print("[Prop Chooser] Creating default Prop Chooser Prop Data...")
		file.CreateDir(path)
		print("[Prop Chooser] Successfully created: "..path.."!")
	end
	
	if file.Exists(path.."/models.txt","DATA") then
		local read = util.JSONToTable(file.Read(path.."/models.txt"))
		for _,mdl in pairs(read) do
			table.insert(PCR.CustomProp, mdl)
		end
	else
		print("[Prop Chooser] Creating a default Prop Chooser custom prop data...")
		
		local proplist = { "models/balloons/balloon_star.mdl", "models/balloons/balloon_dog.mdl", "models/balloons/balloon_classicheart.mdl" }
		local json = util.TableToJSON(proplist,true)
		file.Write(path.."/models.txt", json)
		
		print("[Prop Chooser] File successfully created on: phe_config/prop_chooser_custom/models.txt.")
	end
end

PCR.PropList = {}
function PCR.PopulateProp()
	PCR.ReadBannedProps()

	local count = 0
	for i,prop in RandomPairs(ents.FindByClass("prop_physics*")) do			
		if (!IsValid(prop:GetPhysicsObject())) then
			print("[Prop Chooser] Warning: Prop "..prop:GetModel().. " @Index #"..prop:EntIndex().." has no physics. Ignoring!")
			continue
		end
		if table.HasValue(PCR.PropList, string.lower(prop:GetModel())) then continue end
		if (PCR.CVAR.EnablePropBan:GetBool() && table.HasValue(PCR.BannedProp, string.lower(prop:GetModel()))) then
			print("[Prop Chooser] Banning a prop of "..prop:GetModel().." @Index #"..prop:EntIndex().."...")
			continue
		end
		if (PCR.CVAR.EnableLimit:GetBool() && PCR.CheckBBox(prop)) then
			print("[Prop Chooser] Found a prop "..prop:GetModel().." @Index #"..prop:EntIndex().." that Exceeds the OBB settings, ignoring...")
			continue
		end
		
		if (PCR.CVAR.EnableMaximum:GetBool() && count == PCR.CVAR.MaximumLimit:GetInt()) then break end
		
		count = count + 1
		table.insert(PCR.PropList, string.lower(prop:GetModel()))
		util.PrecacheModel(prop:GetModel())
	end
	print("[Prop Chooser] Total by "..count.." props was added.")
	
	if PCR.CVAR.AllowCustomProp:GetBool() then
		print("[Prop Chooser] Adding Custom Props as well...")
		PCR.GetCustomProps()
		for i,prop in pairs(PCR.CustomProp) do
			table.insert(PCR.PropList, prop)
			util.PrecacheModel(prop)
		end
	end
end

hook.Add("Initialize", "PCR.PopulateProps", function()
	timer.Simple(math.Rand(2,3), function()
		PCR.PopulateProp()
	end)
end)

-- NOTE: If you made changes to server side code, Please do a map restart to take effect or force player to rejoin!
-- These only adds once during player initial join.
util.AddNetworkString("pcr.PropListData")
hook.Add("PlayerInitialSpawn", "PCR.SendPropListData", function(ply)
	timer.Simple(math.random(4,7), function()
		net.Start("pcr.PropListData")
			net.WriteUInt(#PCR.PropList, 32)
			for i=1, #PCR.PropList do
				-- I don't think I saw any map that have different models path that goes more than 1024.
				-- uncomment these lines below if you want to *limit* the prop addition max to 1024 for Safety sake.
				-- Maximum count can be 128, 256, 512, 1024, 2048. 256 and 512 is the safest range.
				
				-- if (i > 256) then
				net.WriteString(PCR.PropList[i])
				--    break
				-- end
			end
		net.Send(ply)
	end)
	
	ply:SetNWInt("CurrentUsage", 0)
end)

hook.Add("PostCleanupMap","PCR.ResetUseLimit",function()
	for _,ply in pairs(player.GetAll()) do
		ply:ResetUsage()
	end
end)

PCR.NotifyPlayer = function( ply , message , kind )
	ply:SendLua("notification.AddLegacy(\"".. message .. "\", " .. kind .. ", 5)")
	ply:SendLua("surface.PlaySound('garrysmod/save_load".. math.random(1,4) ..".wav')")
end

local function PlayerDelayCheck(ply)
	local lastUsedTime = ply:GetNWFloat("pcr.LastUsedTime")
	local delayedTime = lastUsedTime + PCR.CVAR.DelayUsageTime:GetFloat()
	local currentTime = CurTime()
	
	return delayedTime > currentTime; 
end

util.AddNetworkString("pcr.SetMetheProp")
net.Receive("pcr.SetMetheProp",function(len,ply)
	local mdl = net.ReadString()
	
	-- if so, Warn / Kick player to maximum thresold if they are trying to access invalid model.
	if (not table.HasValue(PCR.PropList, mdl)) then
		if !ply.warnInvalidModel then
			ply.warnInvalidModel = 0
		end
		
		print("[Prop Chooser] !!WARNING: User ".. ply:Nick() .." ("..ply:SteamID()..") is trying to use Invalid Prop Model : " .. mdl .. ", which DOES NOT EXIST in the map!")
		
		if ( PCR.CVAR.KickInvalidModel:GetBool() ) then
			ply.warnInvalidModel = ply.warnInvalidModel + 1
			ply:ChatPrint("That prop you have selected does not exists in this map. (" ..tostring(ply.warnInvalidModel).. "/4).")
			if ply.warnInvalidModel > 4 then
				ply:Kick("[Prop Chooser] Kicked for Reason: trying to access invalid prop.")
			end
		else
			ply:ChatPrint("That prop you have selected does not exists in this map.")
		end
		
		return
	end
	
	-- Make sure that the player is On Ground and Not crouching.
	if ( ply:Crouching() or (not ply:IsOnGround()) ) then
		ply:ChatPrint("[Prop Chooser] You need to stay on the ground or not crouching!")
		return
	end
	
	-- Make sure player is not accessing banned prop
	if ( PCR.CVAR.EnablePropBan:GetBool() and table.HasValue(PCR.BannedProp, string.lower(mdl)) ) then
		ply:ChatPrint("[Prop Chooser] The prop you have selected was banned on the server.")
		return
	end
	
	if ( IsValid(ply) and (not PlayerDelayCheck(ply)) ) then
	
		if ply:CheckUsage() == 0 then
			ply:ChatPrint("[Prop Chooser] You have reached the limit!")
			return
		end
	
		local pos = ply:GetPos()
		--Temporarily Spawn a prop.
		local ent = ents.Create("prop_physics")
		ent:SetPos( Vector( pos.x, pos.y, pos.z-512 ) )
		ent:SetAngles(Angle(0,0,0))
		ent:SetKeyValue("spawnflags","654")
		ent:SetNoDraw(true)
		ent:SetModel(mdl)
		
		ent:Spawn()
		
		local usage = ply:CheckUsage()
		local hmx,hz = ent:GetPropSize()
		if ( PCR.CVAR.RoomCheck:GetBool() and (not ply:CheckHull(hmx,hmx,hz)) ) then
			if usage > 0 then
				ply:SendLua([[chat.AddText(Color(235,10,15), "[Prop Chooser]", Color(220,220,220), " There is no room to change the prop. Move a little a bit...")]])
			end
		else
			if usage <= -1 then
				GAMEMODE:PlayerExchangeProp(ply,ent)
				PCR.NotifyPlayer( ply, "[Prop Chooser] You have **unlimitted** usage left!", "NOTIFY_UNDO" )
			elseif usage > 0 then
				ply:UsageSubstractCount()
				GAMEMODE:PlayerExchangeProp(ply,ent)
				PCR.NotifyPlayer( ply, "[Prop Chooser] You have " .. (usage - 1) .. " usage left!", "NOTIFY_GENERIC" )
			end
		end
		ent:Remove()
		
		ply:SetNWFloat( "pcr.LastUsedTime", CurTime() )
		
	else
	
		ply:ChatPrint( "[Prop Chooser] Please wait in few seconds...!" )
		
	end
end)

-- Handles UI
util.AddNetworkString("pcr.ShowUI")
function PCR.KeyUp(ply,key)
	if ( IsValid(ply) and key == PCR.CVAR.DefaultKey:GetInt() and ply:Team() == TEAM_PROPS ) then
		net.Start("pcr.ShowUI")
		net.Send(ply)
	end
end
hook.Add("PlayerButtonDown","PCR.PressedKey",function(ply, btn)
	PCR.KeyUp(ply,btn)
end)