concommand.Add( "pcr_debug_model_list",function( ply )
	if ply == NULL then -- assume it's dedicated server.
		PrintTable(PCR.PropList)
		print("[pcr] debug: running on server cmd")
	else
		if ( ply:IsSuperAdmin() or ply:IsAdmin() ) then
			ply:ChatPrint("[Prop Chooser] Check on your Console!")
			PrintTable(PCR.PropList)
			print("[pcr] debug: running on client cmd")
		else
			ply:ChatPrint("[Prop Chooser] Sorry, you can not use this command.")
		end
	end
end)