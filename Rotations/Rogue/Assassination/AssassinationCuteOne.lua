if select(2, UnitClass("player")) == "ROGUE" then
    local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
    local function createToggles()
    -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.fanOfKnives },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.fanOfKnives },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mutilate },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.crimsonVial}
        };
        CreateButton("Rotation",1,0)
    -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.vendetta },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.vendetta },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.vendetta }
        };
        CreateButton("Cooldown",2,0)
    -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.evasion },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.evasion }
        };
        CreateButton("Defensive",3,0)
    -- Interrupt Button
        InterruptModes = {
            [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.kick },
            [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.kick }
        };
        CreateButton("Interrupt",4,0)
    -- Cleave Button
        CleaveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = br.player.spell.fanOfKnives },
            [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = br.player.spell.mutilate }
        };
        CreateButton("Cleave",5,0)
    -- Pick Pocket Button
      	PickerModes = {
          [1] = { mode = "Auto", value = 2 , overlay = "Auto Pick Pocket Enabled", tip = "Profile will attempt to Pick Pocket prior to combat.", highlight = 1, icon = br.player.spell.pickPocket},
          [2] = { mode = "Only", value = 1 , overlay = "Only Pick Pocket Enabled", tip = "Profile will attempt to Sap and only Pick Pocket, no combat.", highlight = 0, icon = br.player.spell.pickPocket},
          [3] = { mode = "Off", value = 3, overlay = "Pick Pocket Disabled", tip = "Profile will not use Pick Pocket.", highlight = 0, icon = br.player.spell.pickPocket}
        };
        CreateButton("Picker",6,0)
    end

---------------
--- OPTIONS ---
---------------
    local function createOptions()
        local optionTable

        local function rotationOptions()
            -----------------------
            --- GENERAL OPTIONS ---
            -----------------------
            section = br.ui:createSection(br.ui.window.profile,  "General")
            	-- Opening Attack
	            br.ui:createDropdown(section, "Opener", {"Garrote", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
            	-- Poison
            	br.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound","Agonizing"}, 1, "Lethal Poison to Apply")
            	br.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling","Leeching"}, 1, "Non-Lethal Poison to Apply")
            	-- Poisoned Knife
            	br.ui:createCheckbox(section, "Poisoned Knife")
            	-- Stealth
	            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Shadowstep
	            br.ui:createCheckbox(section, "Shadowstep")
	            -- Pre-Pull Timer
	            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
	            -- Dummy DPS Test
                br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            br.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
                -- Agi Pot
	            br.ui:createCheckbox(section, "Agi-Pot")
	            -- Legendary Ring
	            br.ui:createCheckbox(section, "Legendary Ring")
	            -- Marked For Death
	            br.ui:createSpinner(section, "Marked For Death",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Vanish
	            br.ui:createCheckbox(section, "Vanish")
            br.ui:checkSectionState(section)
            -------------------------
            --- DEFENSIVE OPTIONS ---
            -------------------------
            section = br.ui:createSection(br.ui.window.profile, "Defensive")
	            -- Healthstone
	            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
	            -- Heirloom Neck
	            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            	-- Evasion
                br.ui:createSpinner(section, "Evasion",  40,  0,  100,  5, "Set health percent threshhold to cast at - In Combat Only!",  "|cffFFFFFFHealth Percent to Cast At")
                -- Cloak of Shadows
	            br.ui:createCheckbox(section, "Cloak of Shadows")
	            -- Crimson Vial
	            br.ui:createSpinner(section, "Crimson Vial",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:checkSectionState(section)
            -------------------------
            --- INTERRUPT OPTIONS ---
            -------------------------
            section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            	-- Kick
	            br.ui:createCheckbox(section,"Kick")
	            -- Kidney Shot
	            br.ui:createCheckbox(section,"Kidney Shot")
	            -- Interrupt Percentage
	            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")    
            br.ui:checkSectionState(section)
            ----------------------
            --- TOGGLE OPTIONS ---
            ----------------------
            section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            	-- Single/Multi Toggle
	            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
	            --Cooldown Key Toggle
	            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
	            --Defensive Key Toggle
	            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
	            -- Interrupts Key Toggle
	            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
	            -- Cleave Toggle
	            br.ui:createDropdown(section, "Cleave Mode", br.dropOptions.Toggle,  6)
	            -- Pick Pocket Toggle
	            br.ui:createDropdown(section, "Pick Pocket Mode", br.dropOptions.Toggle,  6)
	            -- Pause Toggle
	            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)   
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
        if br.timer:useTimer("debugAssassination", math.random(0.15,0.3)) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("Interrupt",0.25)
            UpdateToggle("Cleave",0.25)
            UpdateToggle("Picker",0.25)

	--------------
	--- Locals ---
	--------------
			if leftCombat == nil then leftCombat = GetTime() end
			if profileStop == nil then profileStop = false end
			local addsIn                                        = 999
			local artifact 										= br.player.artifact
			local attacktar 									= UnitCanAttack("target","player")
			local buff, buffRemain								= br.player.buff, br.player.buff.remain
			local cast 											= br.player.cast
			local cd 											= br.player.cd
			local charge 										= br.player.charges
			local combo, comboDeficit, comboMax					= br.player.comboPoints, br.player.comboPointsMax - br.player.comboPoints, br.player.comboPointsMax
			local cTime 										= getCombatTime()
			local deadtar										= UnitIsDeadOrGhost("target")
			local debuff 										= br.player.debuff
			local enemies										= br.player.enemies
			local envenomHim 									= envenomHim
			local exsanguinated 								= exsanguinated									
			local flaskBuff, canFlask							= getBuffRemain("player",br.player.flask.wod.buff.agilityBig), canUse(br.player.flask.wod.agilityBig)	
			local gcd 											= br.player.gcd
			local glyph				 							= br.player.glyph
			local hastar 										= ObjectExists("target")
			local healPot 										= getHealthPot()
			local hemorrhageCount 								= hemorrhageCount
			local inCombat 										= br.player.inCombat
			local lastSpell 									= lastSpellCast
			local level											= br.player.level
			local mode 											= br.player.mode
			local multidot 										= (useCleave() or br.player.mode.rotation ~= 3)
			local perk											= br.player.perk
			local php											= br.player.health
			local power, powerDeficit, powerRegen				= br.player.power, br.player.powerDeficit, br.player.powerRegen
			local pullTimer 									= br.DBM:getPulltimer()
			local race 											= br.player.race
			local racial 										= br.player.racial
			local ruptureCount 									= ruptureCount
			local solo											= GetNumGroupMembers() == 0	
			local spell 										= br.player.spell
			local stealth 										= br.player.buff.stealth
			local stealthing 									= br.player.buff.stealth or br.player.buff.vanish or br.player.buff.shadowmeld
			local t18_4pc 										= br.player.eq.t18_4pc
			local talent 										= br.player.talent
			local ttd 											= getTTD
			local ttm 											= br.player.powerTTM --timeToMax
			local units 										= br.player.units
			local custom 										= br.player.custom



			if not inCombat and lastSpell ~= spell.vanish then custom.opener = false end

			-- Exsanguinated Bleeds
			if not custom.envenomHim then custom.envenomHim = false end
			if not debuff.rupture then custom.exRupture = false end
			if not debuff.garrote then custom.exGarrote = false end
			if not debuff.internalBleeding then custom.exInternalBleeding = false end
			if lastSpell == spell.exsanguinate then custom.exsanguinateCast = true else custom.exsanguinateCast = false end
			if custom.exsanguinateCast and debuff.rupture then custom.exRupture = true end
			if custom.exsanguinateCast and debuff.garrote then custom.exGarrote = true end
			if custom.exsanguinateCast and debuff.internalBleeding then custom.exInternalBleeding = true end
			if custom.exRupture or custom.exGarrote or custom.exInternalBleeding then custom.exsanguinated = true else custom.exsanguinated = false end
			-- Hemorrhage Count
			custom.hemorrhageCount = 0
			for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                if hemorrhageRemain > 0 then
                	custom.hemorrhageCount = custom.hemorrhageCount + 1
                end
            end
            -- Rupture Count
            custom.ruptureCount = 0
            for i=1, #enemies.yards5 do
                local thisUnit = enemies.yards5[i]
                local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                if ruptureRemain > 0 then
                	custom.ruptureCount = custom.ruptureCount + 1
                end
            end
            -- Numeric Returns
            if talent.deeperStrategem then custom.dStrat = 1 else custom.dStrat = 0 end
            if debuff.vendetta then custom.vendy = 1 else custom.vendy = 0 end
            if artifact.bagOfTricks then custom.trickyBag = 1 else custom.trickyBag = 0 end
            if talent.elaboratePlanning then custom.ePlan = 1 else custom.ePlan = 0 end

	--------------------
	--- Action Lists ---
	--------------------
		-- Action List - Extras
			local function actionList_Extras()
				-- TODO: Add Extra Features To Base Profile
			-- Dummy Test
	            if isChecked("DPS Testing") then
	                if GetObjectExists("target") then
	                    if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
	                        StopAttack()
	                        ClearTarget()
	                        ChatOverlay(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
	                        profileStop = true
	                    end
	                end
	            end
	        -- Pick Pocket
	        	if usePickPocket() then
        			if (isValidUnit(units.dyn5) or mode.pickPocket == 2) and mode.pickPocket ~= 3 then
	        			if not isPicked(units.dyn5) and not isDummy(units.dyn5) then
	        				if debuff.remain.sap < 1 and mode.pickPocket ~= 1 then
	        					if cast.sap(units.dyn5) then return end
	        				end
	        				if lastSpell ~= spell.vanish then
	        					if cast.pickPocket() then return end
	        				end
	        			end
	        		end
	        	end
	        -- Poisoned Knife
        		if isChecked("Poisoned Knife") and not buff.stealth then
        			for i = 1, #enemies.yards30 do
        				local thisUnit = enemies.yards30[i]
        				local distance = getDistance(thisUnit)
        				local deadlyPoisoned = UnitDebuffID(thisUnit,spell.spec.debuffs.deadlyPoison,"player") ~= nil or false
            			local agonizingPoisoned = UnitDebuffID(thisUnit,spell.spec.debuffs.agonizingPoison,"player") ~= nil or false
            			local woundPoisoned	= UnitDebuffID(thisUnit,spell.spec.debuffs.woundPoison,"player") ~= nil or false
        				if not (deadlyPoisoned or agonizingPoisoned or woundPoisoned) and distance > 5 and isValidUnit(thisUnit) then
        					if cast.poisonedKnife(thisUnit) then return end
        				end
        			end
        		end
			end -- End Action List - Extras
		-- Action List - Defensives
			local function actionList_Defensive()
				-- -- TODO: Add Defensive Abilities
				if useDefensive() and not stealth then
	            -- Heirloom Neck
		    		if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") and not inCombat then
		    			if hasEquiped(122668) then
		    				if GetItemCooldown(122668)==0 then
		    					useItem(122668)
		    				end
		    			end
		    		end
				-- Pot/Stoned
		            if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and hasHealthPot() then
	                    if canUse(5512) then
	                        useItem(5512)
	                    elseif canUse(healPot) then
	                        useItem(healPot)
	                    end
		            end
		        -- Cloak of Shadows
		    		if isChecked("Cloak of Shaodws") and canDispel("player",spell.cloakOfShadows) then
		    			if cast.cloakOfShadows() then return end
		    		end
		        -- Crimson Vial
					if isChecked("Crimson Vial") and php < getOptionValue("Crimson Vial") then
						if cast.crimsonVial() then return end
					end
	            -- Evasion
	                if isChecked("Evasion") and php < getOptionValue("Evasion") and inCombat then
	                    if cast.evasion() then return end
	                end
	            end
			end -- End Action List - Defensive
		-- Action List - Interrupts
			local function actionList_Interrupts()
				if useInterrupts() and not stealth then
					for i=1, #enemies.yards5 do
						local thisUnit = enemies.yards5[i]
						if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
				-- Kick
							-- kick
							if isChecked("Kick") then
								if cast.kick(thisUnit) then return end
							end
				-- Kidney Shot
							if cd.kick ~= 0 then
								if isChecked("Kidney Shot") then
									if cast.kidneyShot(thisUnit) then return end
								end
							end
						end
					end
				end -- End Interrupt and No Stealth Check
			end -- End Action List - Interrupts
		-- Action List - Cooldowns
			local function actionList_Cooldowns()
				if (useCDs() or burst) and getDistance(units.dyn5) < 5 then
			-- Racial
					-- blood_fury,if=debuff.vendetta.up
					-- berserking,if=debuff.vendetta.up
					-- arcane_torrent,if=debuff.vendetta.up&energy.deficit>50
					if debuff.vendetta and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 50)) then
						if castSpell("player",racial,false,false,false) then return end
					end
			-- Marked For Death
					-- marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|combo_points.deficit>=5
					if isChecked("Marked For Death") then
						for i = 1, #enemies.yards30 do
							local thisUnit = enemies.yards30[i]
							if getHP(thisUnit) < getOptionValue("Marked For Death") or ttd(thisUnit) < comboDeficit or comboDeficit >= 5 then
								if cast.markedForDeath(thisUnit) then return end
							end
						end
					end
			-- Vendetta
					-- /vendetta,if=target.time_to_die<20
					-- vendetta,if=artifact.urge_to_kill.enabled&dot.rupture.ticking&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5)&(energy<55|time<10|spell_targets.fan_of_knives>=2)
 					-- vendetta,if=!artifact.urge_to_kill.enabled&dot.rupture.ticking&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<1)
 					if ttd("target") < 20 
 						or (artifact.urgeToKill and debuff.rupture and (not talent.exsanguinate or cd.exsanguinate < 5) and (power < 55 or cTime < 10 or #enemies.yards8 >= 2))
 						or (not artifact.urgeToKill and debuff.rupture and (not talent.exsanguinate or cd.exsanguinate < 1))
 					then
 						if cast.vendetta() then return end
 					end 
			-- Vanish
					-- vanish,if=talent.subterfuge.enabled&combo_points<=2&!dot.rupture.exsanguinated|talent.shadow_focus.enabled&!dot.rupture.exsanguinated&combo_points.deficit>=2
 					-- vanish,if=!talent.exsanguinate.enabled&talent.nightstalker.enabled&combo_points>=5+talent.deeper_stratagem.enabled&energy>=25&gcd.remains=0
					if isChecked("Vanish") and not solo then
						if ((talent.subterfuge and combo <= 2 and not custom.exRupture) or (talent.shadowFocus and not custom.exRupture and combo >= 2))
							or (not talent.exsanguinate and talent.nightstalker and combo >= 5 + custom.dStrat and power >= 25)
 						then
							if cast.vanish() then return end
						end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - Garrote
			local function actionList_Garrote()
				-- pool_resource,for_next=1
				-- garrote,cycle_targets=1,if=talent.subterfuge.enabled&!ticking&combo_points.deficit>=1&spell_targets.fan_of_knives>=2
				for i = 1, #enemies.yards5 do
					local thisUnit = enemies.yards5[i]
					local garroteRemain = getDebuffRemain(thisUnit,spell.garrote,"player") or 0
					if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
						if talent.subterfuge and garroteRemain == 0 and comboDeficit >= 1 and #enemies.yards10 >= 2 then
							if power < 45 then
								return true
							else
								if cast.garrote(thisUnit) then return end
							end
						end
					end
				end
				-- pool_resource,for_next=1
				-- garrote,if=combo_points.deficit>=1&!exsanguinated
				if (comboDeficit >= 1 and not custom.exsanguinated) or stealthing then
					if power < 45 then
						return true
					else
						if cast.garrote(thisUnit) then return end
					end
				end
			end -- End Action List - Garrote
		-- Action List - Builders Exsanguinate
			local function actionList_BuildersExsanguinate()
			-- Hemorrhage
				-- hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
				-- hemorrhage,cycle_targets=1,max_cycle_targets=3,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives=5
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageDuration = getDebuffDuration(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageRefresh = hemorrhageRemain < hemorrhageDuration * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    	if (comboDeficit >= 1 and hemorrhageRefreshable and ruptureRemain > 6 and ((mode.rotation == 1 and #enemies.yards10 > 1 and #enemies.yards10 <= 4) or mode.rotation == 2 or (mode.rotation == 3 and UnitIsUnit(thisUnit,units.dyn5)))) 
                    		or (custom.hemorrhageCount <= 3 and comboDeficit >= 1 and hemorrhageRefresh and ruptureRemain > 6 and ((mode.rotation == 1 and #enemies.yards10 > 1 and #enemies.yards10 == 5) or mode.rotation == 2 or (mode.rotation == 3 and UnitIsUnit(thisUnit,units.dyn5))))
                    	then
                    		if cast.hemorrhage(thisUnit) then return end
                    	end
                    end
                end
            -- Fan of Knives
            	-- fan_of_knives,if=(spell_targets>=2+debuff.vendetta.up&(combo_points.deficit>=1|energy.deficit<=30))|(!artifact.bag_of_tricks.enabled&spell_targets>=7+2*debuff.vendetta.up)
            	-- fan_of_knives,if=equipped.the_dreadlords_deceit&((buff.the_dreadlords_deceit.stack>=29|buff.the_dreadlords_deceit.stack>=15&debuff.vendetta.remains<=3)&debuff.vendetta.up|buff.the_dreadlords_deceit.stack>=5&cooldown.vendetta.remains>60&cooldown.vendetta.remains<65)
            	if (((#enemies.yards10 >= 2 + custom.vendy and (comboDeficit >= 1 or powerDeficit <= 30)) or (not artifact.bagOfTricks and ((mode.rotation == 1 and #enemies.yards10 >= 7 + 2 * custom.vendy) or mode.rotation == 2)))
            		or (hasEquiped(137021) and ((buff.stack.theDreadlordsDeceit >= 15 and debuff.remain.vendetta <= 3) and debuff.vendetta or buff.stack.theDreadlordsDeceit >= 5 and cd.vendetta > 60 and cd.vendetta < 65 and (mode.rotation == 1 or mode.rotation == 2))))
            		and mode.rotation ~= 3
            	then
            		if cast.fanOfKnives() then return end
            	end
            -- Hemorrhage
            	-- hemorrhage,if=(combo_points.deficit>=1&refreshable)|(combo_points.deficit=1&(dot.rupture.exsanguinated&dot.rupture.remains<=2|cooldown.exsanguinate.remains<=2))
            	if (comboDeficit >= 1 and debuff.refresh.hemorrhage) or (comboDeficit == 1 and (custom.exRupture and debuff.remain.rupture <= 2 or cd.exsanguinate <= 2)) then
            		if cast.hemorrhage() then return end
            	end
            -- Mutilate
            	-- mutilate,if=combo_points.deficit<=1&energy.deficit<=30
            	-- mutilate,if=combo_points.deficit>=2&cooldown.garrote.remains>2
            	if (comboDeficit <= 1 and powerDeficit <= 30)
            		or (comboDeficit >= 2 and cd.garrote > 2) 
            	then
            		if cast.mutilate() then return end
            	end
			end -- End Action List - Builders Exsanguinate
		-- Action List - Exsanguinated Finishers
			local function actionList_ExsanguinatedFinishers()
			-- Rupture
				-- rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend-1&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend&ticks_remain<2
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local ruptureDuration = getDebuffDuration(thisUnit,spell.rupture,"player") or 0
                    local ruptureTicks = ruptureRemain / 2
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    	if custom.ruptureCount <= 14 - 2 * custom.trickyBag and ruptureRemain == 0 and combo >= comboMax - 1 and ((mode.rotation == 1 and #enemies.yards10 > 1) or mode.rotation == 2) and ttd(thisUnit) - ruptureRemain > 6 then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    elseif UnitIsUnit(thisUnit,units.dyn5) then
                    	if combo >= comboMax and ruptureTicks < 2 then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    end
                end
			-- Death From Above
				-- death_from_above,if=combo_points>=cp_max_spend-1&(dot.rupture.remains>3|dot.rupture.remains>2&spell_targets.fan_of_knives>=3)&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6+2*debuff.vendetta.up)
				if combo >= comboMax - 1 and (debuff.remain.rupture > 3 or debuff.remain.rupture > 2 and ((mode.rotation == 1 and #enemies.yards10 >= 3) or mode.rotation == 2)) and (artifact.bagOfTricks or #enemies.yards10 <= 6 + 2 * custom.vendy) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-1&(dot.rupture.remains>3|dot.rupture.remains>2&spell_targets.fan_of_knives>=3)&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6+2*debuff.vendetta.up)
				if combo >= comboMax - 1 and (debuff.remain.rupture > 3 or debuff.remain.rupture > 2 and ((mode.rotation == 1 and #enemies.yards10 >= 3) or mode.rotation == 2)) and (artifact.bagOfTricks or #enemies.yards10 <= 6 + 2 * custom.vendy) then
					if cast.envenom() then return end
				end
			end -- End Action List - Exsanguinated Finishers
		-- Action List - Exsanguinate Combo
			local function actionList_ExsanguinateCombo()
			-- Vanish
				-- vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&gcd.remains=0&energy>=25
				if isChecked("Vanish") and (not solo or isDummy("target")) and talent.nightstalker and combo >= comboMax and cd.exsanguinate < 1 and power >= 25 then
					if cast.vanish() then return end
				end
			-- Rupture
				-- rupture,if=combo_points>=cp_max_spend&(!talent.nightstalker.enabled|buff.vanish.up|cooldown.vanish.remains>15)&cooldown.exsanguinate.remains<1
				if combo >= comboMax and (not talent.nightstalker or buff.vanish or cd.vanish > 15 or not isChecked("Vanish") or solo or not isBoss("target")) and cd.exsanguinate < 1 then
					if cast.rupture() then return end
				end
			-- Exsanguinate
				-- exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>22+4*talent.deeper_stratagem.enabled&cooldown.vanish.remains>10
				if lastSpell == spell.rupture and debuff.remain.rupture > 22 + 4 * custom.dStrat and (cd.vanish > 10 or not isChecked("Vanish") or solo or not isBoss("target")) then
					if cast.exsanguinate() then return end
				end
			-- Call Action List: Garrote
				-- call_action_list,name=garrote,if=spell_targets.fan_of_knives<=8-artifact.bag_of_tricks.enabled
				if #enemies.yards10 <= 8 - custom.trickyBag then
					if actionList_Garrote() then return end
				end
			-- Hemorrhage
				-- hemorrhage,if=spell_targets.fan_of_knives>=2&!ticking
				if #enemies.yards10 >= 2 and not debuff.hemorrhage then
					if cast.hemorrhage() then return end
				end
			-- Call Action List: Builder Exsanguinate
				-- call_action_list,name=build_ex
				if actionList_BuildersExsanguinate() then return end
			end -- End Action List - Exsanguinate Combo
		-- Action List - Finishers Exsanguinate
			local function actionList_FinishersExsanguinate()
			-- Rupture
				-- rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend-1&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend-1&refreshable&!exsanguinated
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local ruptureDuration = getDebuffDuration(thisUnit,spell.rupture,"player") or 0
                    local ruptureRefreshable = ruptureRemain < ruptureDuration * 0.3
                    local ruptureTicks = ruptureRemain / 2
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                    	if custom.ruptureCount <= 14 - 2 * custom.trickyBag and ruptureRemain == 0 and combo >= comboMax - 1 and ((mode.rotation == 1 and #enemies.yards10 > 1) or mode.rotation == 2) and ttd(thisUnit) - ruptureRemain > 6 then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    elseif UnitIsUnit(thisUnit,units.dyn5) then
                    	if combo >= comboMax and ruptureRefreshable and not custom.exsanguinated then
                    		if cast.rupture(thisUnit) then return end
                    	end
                    end
                end
			-- Death From Above
				-- death_from_above,if=combo_points>=cp_max_spend-1&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				if combo >= comboMax - 1 and (artifact.bagOfTricks or #enemies.yards10 <= 6) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&energy.deficit<40&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				-- envenom,if=combo_points>=cp_max_spend&!dot.rupture.refreshable&buff.elaborate_planning.remains<2&cooldown.garrote.remains<1&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				if (combo >= comboMax - 1 and not debuff.refresh.rupture and buff.remain.elaboratePlanning < 2 and powerDeficit < 40 and (artifact.bagOfTricks or #enemies.yards10 <= 6))
					or (combo >= comboMax - 1 and not debuff.refresh.rupture and buff.remain.elaboratePlanning < 2 and cd.garrote < 1 and (artifact.bagOfTricks or #enemies.yards10 <= 6))
				then
					if cast.envenom() then return end
				end
			end -- End Action List - Finishers Exsanguinate
		-- Action List - Finishers
			local function actionList_Finishers()
			-- Envenom Condition
				-- variable,name=envenom_condition,value=!(dot.rupture.refreshable&dot.rupture.pmultiplier<1.5)&(!talent.nightstalker.enabled|cooldown.vanish.remains>=6)&dot.rupture.remains>=6&buff.elaborate_planning.remains<1.5&(artifact.bag_of_tricks.enabled|spell_targets.fan_of_knives<=6)
				if not debuff.refresh.rupture and (not talent.nightstalker or cd.vanish >= 6 or not isChecked("Vanish") or solo or not isBoss("target")) and debuff.remain.rupture >= 6 and buff.remain.elaboratePlanning < 1.5 and (artifact.bagOfTricks or #enemies.yards10 <= 6 or isDummy("target")) then
					custom.envenomHim = true
				else
					custom.envenomHim = false
				end 
			-- Rupture
				-- rupture,cycle_targets=1,max_cycle_targets=14-2*artifact.bag_of_tricks.enabled,if=!ticking&combo_points>=cp_max_spend&spell_targets.fan_of_knives>1&target.time_to_die-remains>6
				-- rupture,if=combo_points>=cp_max_spend&(((dot.rupture.refreshable)|dot.rupture.ticks_remain<=1)|(talent.nightstalker.enabled&buff.vanish.up))
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if custom.ruptureCount == 14 - 2 * custom.trickyBag and ruptureRemain == 0 and combo >= comboMax and ((mode.rotation == 1 and #enemies.yards10 > 1) or mode.rotation == 2) and ttd(thisUnit) - ruptureRemain > 6 then 
                           if cast.rupture(thisUnit) then return end
                        end
                    end
                    if UnitIsUnit(thisUnit,units.dyn5) then
                        if combo >= comboMax and (((debuff.refresh.rupture) or debuff.remain.rupture / 2 <= 1) or (talent.nightstalker and buff.vanish)) then 
                            if cast.rupture(thisUnit) then return end
                        end
                    end
                end
            -- Death From Above
            	-- death_from_above,if=(combo_points>=5+talent.deeper_stratagem.enabled-2*talent.elaborate_planning.enabled)&variable.envenom_condition&(refreshable|talent.elaborate_planning.enabled&!buff.elaborate_planning.up|cooldown.garrote.remains<1)
				if (combo >= 5 + custom.dStrat - (2 * custom.ePlan)) and custom.envenomHim and (buff.refresh.envenom or (talent.elaboratePlanning and not buff.elaboratePlanning) or cd.garrote < 1) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=(combo_points>=5+talent.deeper_stratagem.enabled-2*talent.elaborate_planning.enabled)&variable.envenom_condition&(refreshable|talent.elaborate_planning.enabled&!buff.elaborate_planning.up|cooldown.garrote.remains<1)
				if (combo >= 5 + custom.dStrat - (2 * custom.ePlan)) and custom.envenomHim and (buff.refresh.envenom or (talent.elaboratePlanning and not buff.elaboratePlanning) or cd.garrote < 1) then
					if cast.envenom() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Generators
			local function actionList_Generators()
			-- Hemorrhage
				-- hemorrhage,cycle_targets=1,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives<=4
				-- hemorrhage,cycle_targets=1,max_cycle_targets=3,if=combo_points.deficit>=1&refreshable&dot.rupture.remains>6&spell_targets.fan_of_knives>1&spell_targets.fan_of_knives=5
				for i=1, #enemies.yards5 do
                    local thisUnit = enemies.yards5[i]
                    local ruptureRemain = getDebuffRemain(thisUnit,spell.rupture,"player") or 0
                    local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageDuration = getDebuffDuration(thisUnit,spell.hemorrhage,"player") or 0
                    local hemorrhageRefresh = hemorrhageRemain < hemorrhageDuration * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if (comboDeficit >= 1 and  hemorrhageRemain < hemorrhageDuration * 0.3 and ruptureRemain > 6 and #enemies.yards10 > 1 and #enemies.yards10 <= 4)
                        	or (custom.hemorrhageCount <= 3 and comboDeficit >= 1 and hemorrhageRefresh and ruptureRemain > 6 and #enemies.yards10 > 1 and #enemies.yards10 == 5) 
                        then
                           if cast.hemorrhage(thisUnit) then return end
                        end
                    end
                end
            -- Fan of Knives
            	-- fan_of_knives,if=(spell_targets>=2+debuff.vendetta.up&(combo_points.deficit>=1|energy.deficit<=30))|(!artifact.bag_of_tricks.enabled&spell_targets>=7+2*debuff.vendetta.up)
            	-- fan_of_knives,if=equipped.the_dreadlords_deceit&((buff.the_dreadlords_deceit.stack>=29|buff.the_dreadlords_deceit.stack>=15&debuff.vendetta.remains<=3)&debuff.vendetta.up|buff.the_dreadlords_deceit.stack>=5&cooldown.vendetta.remains>60&cooldown.vendetta.remains<65)
            	if ((((mode.rotation == 1 and #enemies.yards8 >= 2 + custom.vendy) or mode.rotation == 2) and (comboDeficit >= 1 or powerDeficit <= 30)) or (not artifact.bagOfTricks and ((mode.rotation == 1 and #enemies.yards10 >= 7 + 2 * custom.vendy) or mode.rotation == 2)) 
            		or (hasEquiped(137021) and ((buff.stack.theDreadlordsDeceit >= 29 or buff.stack.theDreadlordsDeceit >= 15 and debuff.remain.vendetta <= 3) and debuff.vendetta or buff.stack.theDreadlordsDeceit >= 5 and cd.vendetta > 60 and cd.vendetta < 65)))
            		and mode.rotation ~= 3
            	then
            		if cast.fanOfKnives() then return end
            	end
            -- Hemorrhage
            	-- hemorrhage,if=combo_points.deficit>=1&refreshable
            	if comboDeficit >= 1 and debuff.refresh.hemorrhage then
            		if cast.hemorrhage() then return end
            	end
			-- Mutilate
				-- mutilate,if=combo_points.deficit>=1&cooldown.garrote.remains>2
				if ((comboDeficit >= 1 or level < 3) and (cd.garrote > 2 or level < 48)) then
					if cast.mutilate() then return end
				end
			end -- End Action List - Generators
		-- Action List - PreCombat
			local function actionList_PreCombat()
			-- Apply Poison
				-- apply_poison 
					if isChecked("Lethal Poison") then
						if br.timer:useTimer("Lethal Poison", 3.5) then
							if getOptionValue("Lethal Poison") == 1 and not buff.deadlyPoison then 
								if cast.deadlyPoison() then return end
							end
							if getOptionValue("Lethal Poison") == 2 and not buff.woundPoison then
								if cast.woundPoison() then return end
							end
							if getOptionValue("Lethal Poison") == 3 and not buff.agonizingPoison then
								if cast.agonizingPoison() then return end
							end
						end
					end
					if isChecked("Non-Lethal Poison") then
						if br.timer:useTimer("Non-Lethal Poison", 3.5) then
							if (getOptionValue("Non-Lethal Poison") == 1 or not talent.leechingPoison) and not buff.cripplingPoison then
								if cast.cripplingPoison() then return end
							end
							if getOptionValue("Non-Lethal Poison") == 2 and not buff.leechingPoison then
								if cast.leechingPoison() then return end
							end
						end
					end
			-- Stealth
				-- stealth
				if isChecked("Stealth") and (not IsResting() or (isDummy("target") and lastSpell ~= spell.vanish)) then
					if getOptionValue("Stealth") == 1 then
						if cast.stealth() then return end
					end
				end
			-- Marked For Death
				-- marked_for_death,if=raid_event.adds.in>40
				if addsIn > 40 and isValidUnit("target") then
					if cast.markedForDeath() then return end
				end
			end -- End Action List - PreCombat
		-- Action List - Opener
			local function actionList_Opener()
			-- Shadowstep
                if isChecked("Shadowstep") and isValidUnit("target") then
                    if cast.shadowstep("target") then return end 
                end
			-- Start Attack
                -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 and mode.pickPocket ~= 2 then
                	-- if combo >= 2 and not debuff.rupture and cTime < 10 and not artifact.urgeToKill and getOptionValue("Opener") == 1 then
                	-- 	if cast.rupture("target") then StartAttack(); return end
                	-- elseif combo >= 4 and not debuff.rupture and getOptionValue("Opener") == 1 then
                	-- 	if cast.rupture("target") then StartAttack(); return end
                	-- elseif level >= 48 and not debuff.garrote and getOptionValue("Opener") == 1 then
                	-- 	if actionList_Garrote("target") then StartAttack(); return end
                	-- elseif level >= 29 and getOptionValue("Opener") == 2 then
                	-- 	if cast.cheapShot("target") then StartAttack(); return end
                	-- else
                	-- 	if cast.mutilate("target") then StartAttack(); return end
                	-- end
                	if isBoss("target") and custom.opener == false then
            -- Ruputure
	            		if combo == comboMax and debuff.rupture and debuff.duration.rupture < 24 then
	            			if cast.rupture() then return end
	            		end
	            		if buff.rupture and debuff.duration.rupture >= 24 then
	        -- Exsanguinate
    						if cast.exsanguinate() then return end
            -- Kingsbane
	            			if cast.kingsbane() then custom.opener = true; return end
	            		end
            -- Garrote
	            		if not debuff.garrote and cd.garrote == 0 then
	            			if cast.garrote() then return end
	            		elseif debuff.garrote or cd.garrote > gcd then
	            			if not debuff.rupture then
	            				if combo < 3 then 
            -- Mutilate
	            					if cast.mutilate() then return end
	            				elseif combo >= 3 then
            -- Rupture
            						if cast.rupture() then return end
	            				end
	            			elseif debuff.rupture then
	            				if debuff.duration.rupture < 24 then
            -- Vendetta
				            		if useCDs() then
				            			if cast.vendetta() then return end
			-- Racial
										if debuff.vendetta and (race == "Orc" or race == "Troll" or race == "BloodElf") then
											if castSpell("player",racial,false,false,false) then return end
										end
				            		end
            -- Mutilate
				            		if combo < comboMax then
				            			if cast.mutilate() then return end
				            		elseif combo == comboMax then
            -- Vanish
            							if useCDs() and isChecked("Vanish") and not solo then
            								if cast.vanish() then return end
            							end
            -- Ruputure
            							if cast.rupture() then return end
            					
	            					end
	            				elseif debuff.duration.rupture >= 24 then
	        -- Exsanguinate
	        						if cast.exsanguinate() then return end
            -- Kingsbane
            						if cast.kingsbane() then custom.opener = true; return end
	            				end
	            			end
	            		end
	            	elseif not isBoss("target") then
	            		if combo >= 2 and not debuff.rupture and cTime < 10 and not artifact.urgeToKill and getOptionValue("Opener") == 1 then
	                		if cast.rupture("target") then custom.opener = true; return end
	                	elseif combo >= 4 and not debuff.rupture and getOptionValue("Opener") == 1 then
	                		if cast.rupture("target") then custom.opener = true; return end
	                	elseif level >= 48 and not debuff.garrote and getOptionValue("Opener") == 1 then
	                		if actionList_Garrote("target") then custom.opener = true; return end
	                	elseif level >= 29 and getOptionValue("Opener") == 2 then
	                		if cast.cheapShot("target") then custom.opener = true; return end
	                	else
	                		if cast.mutilate("target") then custom.opener = true; return end
	            		end
	            	end
                end
			end -- End Action List - Opener
	---------------------
	--- Begin Profile ---
	---------------------
		--Profile Stop | Pause
			if not inCombat and not hastar and profileStop==true then
				profileStop = false
			elseif (inCombat and profileStop == true) or pause() or (IsMounted() or IsFlying()) or mode.rotation==4 then
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
				if custom.opener == false then
					if actionList_Opener() then return end
				end
	--------------------------
	--- In Combat Rotation ---
	--------------------------
			-- Assassination is 4 shank!
				if inCombat and mode.pickPocket ~= 2 and isValidUnit(units.dyn5) then
	-----------------------------
	--- In Combat - Cooldowns ---
	-----------------------------
					if custom.opener == true then
						if actionList_Cooldowns() then return end
					end
	----------------------------------
	--- In Combat - Begin Rotation ---
	----------------------------------
			-- Shadowstep
	                if isChecked("Shadowstep") then
	                    if cast.shadowstep("target") then return end 
	                end
	                if stealthing and custom.opener == false then
	                	if actionList_Opener() then return end
	                end
	                if (not stealthing or (isDummy("target") and lastSpell == spell.vanish)) and custom.opener == true then
	     				if actionList_Interrupts() then return end
	       	-- Rupture
		       			-- rupture,if=combo_points>=2&!ticking&time<10&!artifact.urge_to_kill.enabled&talent.exsanguinate.enabled
						-- rupture,if=combo_points>=4&!ticking&talent.exsanguinate.enabled
						if (combo >= 2 and not debuff.rupture and cTime < 10 and not artifact.urgeToKill and talent.exsanguinate)
							or (combo >= 4 and not debuff.rupture and talent.exsanguinate)
						then
							if cast.rupture() then return end
						end
			-- Kingsbane
						-- pool_resource,for_next=1
						-- kingsbane,if=!talent.exsanguinate.enabled&(buff.vendetta.up|cooldown.vendetta.remains>10)|talent.exsanguinate.enabled&dot.rupture.exsanguinated
						if (not talent.exsanguinate and (debuff.vendetta or cd.vendetta > 10)) or (talent.exsanguinate and custom.exRupture) then
							if power <= 35 then
								return true
							else
								if cast.kingsbane() then return end
							end
						end
			-- Exsanguinate Combo
						-- run_action_list,name=exsang_combo,if=cooldown.exsanguinate.remains<3&talent.exsanguinate.enabled
						if cd.exsanguinate < 3 and talent.exsanguinate then
							if actionList_ExsanguinateCombo() then return end
						end
			-- Garrote
						-- call_action_list,name=garrote,if=spell_targets.fan_of_knives<=8-artifact.bag_of_tricks.enabled
						if #enemies.yards10 <= 8 - custom.trickyBag then
							if actionList_Garrote() then return end
						end
			-- Exsanguinate Finishers
						-- call_action_list,name=exsang,if=dot.rupture.exsanguinated
						if custom.exRupture then
							if actionList_ExsanguinatedFinishers() then return end
						end
			-- Rupture
						-- rupture,if=talent.exsanguinate.enabled&remains-cooldown.exsanguinate.remains<(4+cp_max_spend*4)*0.3&new_duration-cooldown.exsanguinate.remains>=(4+cp_max_spend*4)*0.3+3
						if talent.exsanguinate and debuff.remain.rupture - cd.exsanguinate < (4 + comboMax * 4) * 0.3 and debuff.duration.rupture - cd.exsanguinate >= (4 + comboMax * 4) * 0.3 + 3 then
							if cast.rupture() then return end
						end
			-- Finisher Exsanguinate
						-- call_action_list,name=finish_ex,if=talent.exsanguinate.enabled
						if talent.exsanguinate then
							if actionList_FinishersExsanguinate() then return end
						end
			-- Finishers
						-- call_action_list,name=finish_noex,if=!talent.exsanguinate.enabled
						if not talent.exsanguinate then
							if actionList_Finishers() then return end
						end
			-- Generator Exsanguinate
						-- call_action_list,name=build_ex,if=talent.exsanguinate.enabled
						if talent.exsanguinate then
							if actionList_BuildersExsanguinate() then return end
						end
			-- Generators
						-- call_action_list,name=build_noex,if=!talent.exsanguinate.enabled
						if not talent.exsanguinate then
							if actionList_Generators() then return end
						end
					end
				end -- End In Combat
			end -- End Profile
	    end -- Timer
	end -- runRotation
	tinsert(cAssassination.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end -- End Class Check