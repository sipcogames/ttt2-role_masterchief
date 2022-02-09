if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mc.vmt")
end

roles.InitCustomTeam(ROLE.name, {
		icon = "vgui/ttt/dynamic/roles/icon_mc",
		color = Color(0, 204, 102, 255)
})

-- Make sure sound/model is precached
function ROLE:Precache()
	util.PrecacheSound("ttt2/halotheme.mp3")
	util.PrecacheModel("models/player/h3_masterchief_player.mdl")
end

MC = {}

MC.model = util.IsValidModel("models/player/h3_masterchief_player.mdl") and Model("models/player/h3_masterchief_player.mdl") or Model("models/player/kleiner.mdl")
MC.sounds = {}
MC.sounds.spawn = Sound("ttt2/halotheme.mp3", 100, 100)
MC.oldModel = ""

function ROLE:PreInitialize()
	self.color = Color(0, 204, 102, 255)

	self.abbr = "mc"
	self.score.killsMultiplier = 8
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 3
	self.unknownTeam = true

	self.defaultTeam = TEAM_INNOCENT
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.isOmniscientRole = true
	self.isPublicRole = true
	self.isPolicingRole = true

	self.conVarData = {
		pct = 0.13,
		maximum = 1,
		minPlayers = 8,
		minKarma = 600,

		credits = 1,
		creditsAwardDeadEnable = 1,
		creditsAwardKillEnable = 0,

		togglable = true,
		shopFallback = SHOP_FALLBACK_DETECTIVE
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_DETECTIVE)
end

if SERVER then
	--CONSTANTS
	-- Enum for tracker mode
	local TRACKER_MODE = {NONE = 0, RADAR = 1, TRACKER = 2}

	-- Give Loadout on respawn and rolechange
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		
		-- Give Halo 3 Weapons
		ply:StripWeapons()
		ply:Give("br55")

		-- Set Tracker Mode
		if GetConVar("ttt2_masterchief_tracker_mode"):GetInt() == TRACKER_MODE.RADAR then
			ply:GiveEquipmentItem("item_ttt_radar")
		elseif GetConVar("ttt2_masterchief_tracker_mode"):GetInt() == TRACKER_MODE.TRACKER then
			ply:GiveEquipmentItem("item_ttt_tracker")
		end

		-- Set Armor and HP
		ply:GiveArmor(GetConVar("ttt2_masterchief_armor"):GetInt())
		ply:SetHealth(GetConVar("ttt2_masterchief_max_health"):GetInt())
		ply:SetMaxHealth(GetConVar("ttt2_masterchief_max_health"):GetInt())

		-- emit halo noise
		ply:EmitSound(MC.sounds.spawn)
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		-- Remove Halo Weps
		ply:StripWeapon("br55")

		-- Reset Tracker
		if GetConVar("ttt2_masterchief_tracker_mode"):GetInt() == TRACKER_MODE.RADAR then
			ply:RemoveEquipmentItem("item_ttt_radar")
		elseif GetConVar("ttt2_masterchief_tracker_mode"):GetInt() == TRACKER_MODE.TRACKER then
			ply:RemoveEquipmentItem("item_ttt_tracker")
		end

		--Reset Armor and Health
		ply:RemoveArmor(GetConVar("ttt2_masterchief_armor"):GetInt())
		ply:SetHealth(100)
		ply:SetMaxHealth(100)
	end

	hook.Add("PlayerDeath", "MasterChiefDeath", function(victim, infl, attacker)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetSubRole() == ROLE_MASTERCHIEF then
			timer.Stop("sksmokechecker")
			timer.Start("sksmokechecker")
			timer.Remove("sksmoke")
		end
	end)

	hook.Add("TTT2UpdateSubrole", "UpdateMasterChiefRoleSelect", function(ply, oldSubrole, newSubrole)
		if GetConVar("ttt2_masterchief_force_model"):GetBool() then
			if newSubrole == ROLE_MASTERCHIEF then
				ply:SetSubRoleModel(MC.model)
			elseif oldSubrole == ROLE_MASTERCHIEF then
				ply:SetSubRoleModel(nil)
			end
		end
	end)
end

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

    form:MakeSlider({
      serverConvar = "ttt2_masterchief_armor",
      label = "ttt2_masterchief_armor",
      min = 0,
      max = 100,
      decimal = 0
    })

    form:MakeComboBox({
    	serverConvar = "ttt2_masterchief_tracker_mode",
    	label = "ttt2_masterchief_tracker_mode (Use ULX or Console)",
    	choices = {
			"0 - Master Chief does not spawn with a tracking device",
			"1 - Master Chief spawns with a radar",
			"2 - Master Chief spawns with a tracker"
		},
		numStart = 0
    })

    form:MakeCheckBox({
      serverConvar = "ttt2_masterchief_force_model",
      label = "ttt2_masterchief_force_model"
    })

    form:MakeSlider({
      serverConvar = "ttt2_masterchief_max_health",
      label = "ttt2_masterchief_max_health",
      min = 1,
      max = 300,
      decimal = 0
    })

  end
end
