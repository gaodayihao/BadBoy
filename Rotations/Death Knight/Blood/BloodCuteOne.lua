if select(2, UnitClass("player")) == "DEATHKNIGHT" then
	local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
	local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.bloodBoil },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.bloodBoil },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.heartStrike },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.bonestorm },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.bonestorm },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.bonestorm }
        };
       	CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.vampiricBlood },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.vampiricBlood }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.asphyxiate },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.asphyxiate }
        };
        CreateButton("Interrupt",4,0)
    end

---------------
--- OPTIONS ---
---------------
	local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
        -- General Options
            section = br.ui:createSection(br.ui.window.profile, "General")
            -- APL
                br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFIcy-Veins","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
                br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Pre-Pull Timer
                br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Artifact 
                br.ui:createDropdownWithout(section, "Artifact", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            br.ui:checkSectionState(section)
        -- Cooldown Options
            section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Agi Pot
                br.ui:createCheckbox(section, "Potion")
            -- Flask / Crystal
                br.ui:createCheckbox(section, "Flask / Crystal")
            -- Racial
                br.ui:createCheckbox(section, "Racial")
            -- Trinkets
                br.ui:createCheckbox(section, "Trinkets")
            -- Dancing Rune Weapon
                br.ui:createCheckbox(section, "Dancing Rune Weapon")
            br.ui:checkSectionState(section)
        -- Defensive Options
            section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
                br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
                br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Anti-Magic Shell
                br.ui:createSpinner(section, "Anti-Magic Shell",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Vampiric Blood
                br.ui:createSpinner(section, "Vampiric Blood",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            br.ui:checkSectionState(section)
        -- Interrupt Options
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Asphyxiate
                br.ui:createCheckbox(section,"Asphyxiate")
            -- Death Grip
                br.ui:createCheckbox(section,"Death Grip - Int")
            -- Mind Freeze
                br.ui:createCheckbox(section,"Mind Freeze")
            -- Interrupt Percentage
                br.ui:createSpinner(section, "Interrupts",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
            br.ui:checkSectionState(section)
        -- Toggle Key Options
            section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
                br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
                br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
                br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            br.ui:checkSectionState(section)
        end
        optionTable = {{
            [1] = "Rotation Options",
            [2] = rotationOptions,
        }}
        return optionTable
    end

----------------
--- ROTATION ---
----------------
	local function runRotation()
        if br.timer:useTimer("debugBlood", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
	--- Toggles ---
	---------------
	        UpdateToggle("Rotation",0.25)
	        UpdateToggle("Cooldown",0.25)
	        UpdateToggle("Defensive",0.25)
	        UpdateToggle("Interrupt",0.25)

	--------------
	--- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local artifact                                      = br.player.artifact
            local buff                                          = br.player.buff
            local canFlask                                      = canUse(br.player.flask.wod.agilityBig)
            local cast                                          = br.player.cast
            local clearcast                                     = br.player.buff.clearcasting
            local combatTime                                    = getCombatTime()
            local cd                                            = br.player.cd
            local charges                                       = br.player.charges
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = br.player.debuff
            local enemies                                       = br.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local fatality                                      = false
            local flaskBuff                                     = getBuffRemain("player",br.player.flask.wod.buff.agilityBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = br.player.gcd
            local hasMouse                                      = ObjectExists("mouseover")
            local healPot                                       = getHealthPot()
            local inCombat                                      = br.player.inCombat
            local inInstance                                    = br.player.instance=="party"
            local inRaid                                        = br.player.instance=="raid"
            local level                                         = br.player.level
            local lootDelay                                     = getOptionValue("LootDelay")
            local lowestHP                                      = br.friend[1].unit
            local mode                                          = br.player.mode
            local multidot                                      = (br.player.mode.cleave == 1 or br.player.mode.rotation == 2) and br.player.mode.rotation ~= 3
            local perk                                          = br.player.perk        
            local php                                           = br.player.health
            local playerMouse                                   = UnitIsPlayer("mouseover")
            local potion                                        = br.player.potion
            local power, powmax, powgen                         = br.player.power, br.player.powerMax, br.player.powerRegen
            local pullTimer                                     = br.DBM:getPulltimer()
            local racial                                        = br.player.getRacial()
            local recharge                                      = br.player.recharge
            local runes                                         = br.player.runes
            local runicPower                                    = br.player.runicPower             
            local solo                                          = #br.friend < 2
            local friendsInRange                                = friendsInRange
            local spell                                         = br.player.spell
            local stealth                                       = br.player.stealth
            local talent                                        = br.player.talent
            local trinketProc                                   = false
            local ttd                                           = getTTD
            local ttm                                           = br.player.timeToMax
            local units                                         = br.player.units
            
	   		if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
			-- Dummy Test
				if isChecked("DPS Testing") then
					if ObjectExists("target") then
						if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
							StopAttack()
							ClearTarget()
							print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
							profileStop = true
						end
					end
				end -- End Dummy Test
			end -- End Action List - Extras
		-- Action List - Defensive
			local function actionList_Defensive()
				if useDefensive() and not stealth and not flight then
			-- Pot/Stoned
		            if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") 
		            	and inCombat and (hasHealthPot() or hasItem(5512)) 
		            then
	                    if canUse(5512) then
	                        useItem(5512)
	                    elseif canUse(healPot) then
	                        useItem(healPot)
	                    end
		            end
		    -- Heirloom Neck
		    		if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
		    			if hasEquiped(122668) then
		    				if GetItemCooldown(122668)==0 then
		    					useItem(122668)
		    				end
		    			end
		    		end
            -- Anti-Magic Shell
                    if isChecked("Anti-Magic Shell") and php <= getOptionValue("Anti-Magic Shell") then
                        if cast.antimagicShell() then return end
                    end
            -- Vampiric Blood
                    if isChecked("Vampiric Blood") and php <= getOptionValue("Vampiric Blood") then
                        if cast.vampiricBlood() then return end
                    end
                end                    
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() then
                    for i=1, #enemies.yards30 do
                        thisUnit = enemies.yards30[i]
                        if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
            -- Death Grip
                            if isChecked("Death Grip - Int") and getDistance(thisUnit) > 8 then
                                if cast.deathGrip(thisUnit) then return end
                            end
            -- Asphyxiate
                            if isChecked("Asphyxiate") and getDistance(thisUnit) < 20 then
                                if cast.asphyxiate(thisUnit) then return end
                            end
            -- Mind Freeze
                            if isChecked("Mind Freeze") and getDistance(thisUnit) < 15 then
                                if cast.mindFreeze(thisUnit) then return end
                            end
                        end
                    end
			 	end -- End useInterrupts check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if useCDs() and getDistance(units.dyn5) < 5 then
			-- Trinkets
					if isChecked("Trinkets") then
						if canUse(13) then
							useItem(13)
						end
						if canUse(14) then
							useItem(14)
						end
					end
            -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                    -- blood_fury,buff.tigers_fury | berserking,buff.tigers_fury | arcane_torrent,buff.tigers_fury
                    if isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "BloodElf") then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Dancing Rune Weapon
                    if isChecked("Dancing Rune Weapon") then
                        if cast.dancingRuneWeapon() then return end
                    end           
                end -- End useCooldowns check
            end -- End Action List - Cooldowns
        -- Action List - PreCombat
            local function actionList_PreCombat()
                if not inCombat and not (IsFlying() or IsMounted()) then
                    if not stealth then
            -- Flask / Crystal
                        -- flask,type=flask_of_the_seventh_demon
                        if isChecked("Flask / Crystal") and not stealth then
                            if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",188033) then
                                useItem(br.player.flask.wod.agilityBig)
                                return true
                            end
                            if flaskBuff==0 then
                                if not UnitBuffID("player",188033) and canUse(118922) then --Draenor Insanity Crystal
                                    useItem(118922)
                                    return true
                                end
                            end
                        end
            -- auto_attack
                        if getDistance("target") < 5 then
                            StartAttack()
                        end
                    end
                end -- End No Combat
            end -- End Action List - PreCombat 
    ---------------------
    --- Begin Profile ---
    ---------------------
        -- Profile Stop | Pause
            if not inCombat and not hastar and profileStop==true then
                profileStop = false
            elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
                return true
            else
    -----------------------
    --- Extras Rotation ---
    -----------------------
                if actionList_Extras() then return end
    --------------------------
    --- Defensive Rotation ---
    --------------------------
                if actionList_Defensive() then return end
    ------------------------------
    --- Out of Combat Rotation ---
    ------------------------------
                if actionList_PreCombat() then return end
    --------------------------
    --- In Combat Rotation ---
    --------------------------
            -- Cat is 4 fyte!
                if inCombat and profileStop==false and isValidUnit(units.dyn5) then
                    -- auto_attack
                    if getDistance("target") < 5 then
                        StartAttack()
                    end
        ------------------------------
        --- In Combat - Interrupts ---
        ------------------------------
                    if actionList_Interrupts() then return end
        -----------------------------
        --- In Combat - Cooldowns ---
        -----------------------------
                    if actionList_Cooldowns() then return end
        ---------------------------
        --- SimulationCraft APL ---
        ---------------------------
                    if getOptionValue("APL Mode") == 1 then
            -- Marrowrend
                        if buff.remain.boneShield < 3 or #enemies.yards10 == 0 then
                            if cast.marrowrend() then return end
                        end
            -- Blood Boil
                        for i = 1, #enemies.yards10 do
                            local thisUnit = enemies.yards10[i]
                            local bloodPlague = debuff.bloodPlague[thisUnit]
                            if not bloodPlague.exists then
                                if cast.bloodBoil("player") then return end
                            end
                        end
            -- Death and Decay
                        if (buff.crimsonScourge or level < 63) and (#enemies.yards8 > 1 or (#enemies.yards8 == 1 and talent.RapidDecomposition)) then
                            if cast.deathAndDecay("best",false,#enemies.yards8,8) then return end
                        end
            -- Death Strike
                        if ttm <= 20 or php < 75 then
                            if cast.deathStrike() then return end
                        end
            -- Marrowrend
                        if buff.stack.boneShield <= 6 then
                            if cast.marrowrend() then return end
                        end
            -- Death and Decay
                        if (#enemies.yards8 == 1 and runes >= 3) or #enemies.yards8 >= 3 then
                            if cast.deathAndDecay("best",false,#enemies.yards8,8) then return end
                        end
            -- Heart Strike
                        if runes >= 3 or ((not talent.ossuary or buff.stack.boneShield < 5) and power < 45) or (talent.ossuary and buff.stack.boneShield >= 5 and power < 40) then
                            if cast.heartStrike() then return end
                        end
            -- Consumption
                        if cast.consumption() then return end
            -- Blood Boil
                        if cast.bloodBoil("player") then return end         
                    end -- End SimC APL
        ------------------------
        --- Ask Mr Robot APL ---
        ------------------------
                    if getOptionValue("APL Mode") == 2 then
            -- Soulgorge
                        -- if DotRemainingSec(BloodPlague) < 3 and HasDot(BloodPlague)
                        if debuff.bloodPlague[units.dyn30AoE].exists and debuff.bloodPlague[units.dyn30AoE].remain < 3 then
                            if cast.soulgorge() then return end
                        end
            -- Bonestorm
                        -- if TargetsInRadius(Bonestorm) > 2 and AlternatePower >= 80
                        if #enemies.yards8 > 2 and runicPower >= 80 then
                            if cast.bonestorm() then return end
                        end
            -- Death Strike
                        -- if HealthPercent < 0.75 or AlternatePowerToMax <= 20
                        if php < 75 or ttm <= 20 then
                            if cast.deathStrike() then return end
                        end
            -- Death's Caress
                        -- if not HasDot(BloodPlague) and HasTalent(Soulgorge)
                        if not debuff.bloodPlague[units.dyn30AoE].exists and talent.soulGorge then
                            if cast.deathsCaress() then return end
                        end
            -- Blood Tap
                        -- if Power < 2 and BuffStack(BoneShield) <= BuffMaxStack(BoneShield) - 3
                        if runes < 2 and buff.stack.boneshield <= 7 then
                            if cast.bloodTap() then return end
                        end
            -- Marrowrend
                        -- if (BuffStack(BoneShield) <= BuffMaxStack(BoneShield) - 3 and (ArtifactTraitRank(MouthOfHell) = 0 or not HasBuff(DancingRuneWeapon))) or 
                        -- (BuffStack(BoneShield) <= BuffMaxStack(BoneShield) - 4 and ArtifactTraitRank(MouthOfHell) > 0 and HasBuff(DancingRuneWeapon))
                        if (buff.stack.boneShield <= 7 and (artifact.mouthOfHell or not buff.exists.dancingRuneWeapon)) or (buff.stack.boneShield <= 6 and artifact.mouthOfHell and buff.exists.dancingRuneWeapon) then
                            if cast.marrowrend() then return end
                        end
            -- Blooddrinker
                        -- if HealthPercent < 0.75
                        if php < 75 then
                            if cast.blooddrinker() then return end
                        end
            -- Blood Boil
                        if cast.bloodBoil("player") then return end
            -- Death and Decay
                        -- if HasBuff(CrimsonScourge) or HasTalent(RapidDecomposition)
                        if buff.exists.crimsonScourge or talent.rapidDecomposition then
                            if cast.deathAndDecay("best",false,#enemies.yards8,8) then return end
                        end
            -- Heart Strike
                        if cast.heartStrike() then return end
            -- Mark of Blood
                        -- if not HasBuff(MarkOfBlood)
                        if not buff.exists.markOfBlood then 
                            if cast.markOfBlood() then return end
                        end      
                    end
				end --End In Combat 
			end --End Rotation Logic
        end -- End Timer
    end -- End runRotation
    tinsert(cBlood.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check