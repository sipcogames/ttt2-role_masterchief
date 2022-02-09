--ConVar syncing
CreateConVar("ttt2_masterchief_armor", "50", {FCVAR_ARCHIVE, FCVAR_NOTFIY})
CreateConVar("ttt2_masterchief_tracker_mode", "0", {FCVAR_ARCHIVE, FCVAR_NOTFIY})
CreateConVar("ttt2_masterchief_force_model", "1", {FCVAR_ARCHIVE, FCVAR_NOTFIY})
CreateConVar("ttt2_masterchief_max_health", "150", {FCVAR_ARCHIVE, FCVAR_NOTFIY})

hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicMasterChiefCVars", function(tbl)
	tbl[ROLE_MASTERCHIEF] = tbl[ROLE_MASTERCHIEF] or {}

	table.insert(tbl[ROLE_MASTERCHIEF], {
		cvar = "ttt2_masterchief_armor",
		slider = true,
		min = 0,
		max = 100,
		decimal = 0,
		desc = "ttt2_masterchief_armor [0..100] (Def: 50)"
	})

	table.insert(tbl[ROLE_MASTERCHIEF], {
		cvar = "ttt2_masterchief_tracker_mode",
		combobox = true,
		desc = "ttt2_masterchief_tracker_mode (Def: 0)",
		choices = {
			"0 - Master Chief does not spawn with a tracking device",
			"1 - Master Chief spawns with a radar",
			"2 - Master Chief spawns with a tracker"
		},
		numStart = 0
	})

	table.insert(tbl[ROLE_MASTERCHIEF], {
    cvar = "ttt2_masterchief_force_model",
    checkbox = true,
    desc = "ttt2_masterchief_force_model (Def. 1)"
    })

    table.insert(tbl[ROLE_MASTERCHIEF], {
		cvar = "ttt2_masterchief_max_health",
		slider = true,
		min = 1,
		max = 300,
		decimal = 0,
		desc = "ttt2_masterchief_max_health [1..300] (Def: 150)"
	})
end)
