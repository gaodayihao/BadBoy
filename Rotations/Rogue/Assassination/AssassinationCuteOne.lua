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
	            br.ui:createDropdown(section, "Stealth Breaker", {"Garrote", "Cheap Shot"},  1, "|cffFFFFFFSelect Attack to Break Stealth with")
            	-- Poison
            	br.ui:createDropdown(section, "Lethal Poison", {"Deadly","Wound","Agonizing"}, 1, "Lethal Poison to Apply")
            	br.ui:createDropdown(section, "Non-Lethal Poison", {"Crippling","Leeching"}, 1, "Non-Lethal Poison to Apply")
            	-- Poisoned Knife
            	br.ui:createCheckbox(section, "Poisoned Knife")
            	-- Stealth
	            br.ui:createDropdown(section, "Stealth", {"|cff00FF00Always", "|cffFFDD00PrePot", "|cffFF000020Yards"},  1, "Stealthing method.")
	            -- Shadowstep
	            br.ui:createCheckbox(section, "Shadowstep")
	            -- Opener
	            br.ui:createCheckbox(section, "Opener")
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
	            br.ui:createDropdown(section, "Marked For Death", {"|cff00FF00Target", "|cffFFDD00Lowest"}, 1, "|cffFFBB00Health Percentage to use at.")
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
			local multidot 										= useCleave()
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

			if opener == nil then opener = false end
			if not inCombat and not ObjectExists("target") and lastSpell ~= spell.vanish then 
				GAR1 = false
				MUT1 = false
				RUP1 = false
				VEN1 = false
				RAC1 = false
				MUT2 = false
				VAN1 = false
				RUP2 = false
				EXS1 = false
				KIN1 = false
				opener = false
			end
			-- if not inCombat and lastSpell ~= spell.vanish then custom.opener = false end

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
			-- -- Hemorrhage Count
			-- custom.hemorrhageCount = 0
			-- for i=1, #enemies.yards5 do
   --              local thisUnit = enemies.yards5[i]
   --              local hemorrhageRemain = getDebuffRemain(thisUnit,spell.hemorrhage,"player") or 0
   --              if hemorrhageRemain > 0 then
   --              	custom.hemorrhageCount = custom.hemorrhageCount + 1
   --              end
   --          end
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
            if talent.deeperStrategem then dStrat = 1 else dStrat = 0 end
            if talent.anticipation then antital = 1 else antital = 0 end
            if talent.masterPoisoner then masterPoison = 1 else masterPoison = 0 end
            if talent.exsanguinate then exsanguinated = 1 else exsanguinated = 0 end
            if not talent.exsanguinate then noExsanguinate = 1 else noExsanguinate = 0 end
            if artifact.urgeToKill then urges = 1 else urges = 0 end
   --          if debuff.vendetta then custom.vendy = 1 else custom.vendy = 0 end
   --          if artifact.bagOfTricks then custom.trickyBag = 1 else custom.trickyBag = 0 end
   --          if talent.elaboratePlanning then custom.ePlan = 1 else custom.ePlan = 0 end

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
		    		if isChecked("Cloak of Shadows") and canDispel("player",spell.cloakOfShadows) then
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
			-- Potion
					-- potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|debuff.vendetta.up
			-- Racial
					-- blood_fury,if=debuff.vendetta.up
					-- berserking,if=debuff.vendetta.up
					-- arcane_torrent,if=debuff.vendetta.up&energy.deficit>50
					if debuff.vendetta and (race == "Orc" or race == "Troll" or (race == "BloodElf" and powerDeficit > 50)) then
						if castSpell("player",racial,false,false,false) then return end
					end
			-- Marked For Death
					if isChecked("Marked For Death") then
						if getOptionValue("Marked For Death") == 1 then
							-- marked_for_death,if=combo_points.deficit>=4+talent.deeper_strategem.enabled+talent.anticipation.enabled
							if comboDeficit >= 4 + dStrat + antital then
								if cast.markedForDeath() then return end
							end
						end
						if getOptionValue("Marked For Death") == 2 then
							-- marked_for_death,if=target.time_to_die<combo_points.deficit 
							for i = 1, #enemies.yards30 do
								local thisUnit = enemies.yards30[i]
								if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
									if ttd(thisUnit) < comboDeficit then
										if cast.markedForDeath(thisUnit) then return end
									end
								end
							end
						end
					end
			-- Vendetta
					-- vendetta,if=talent.exsanguinate.enabled&cooldown.exsanguinate.remains<5&dot.rupture.ticking
					-- vendetta,if=!talent.exsanguinate.enabled&(!artifact.urge_to_kill.enabled|energy.deficit>=70)
 					if (talent.exsanguinate and cd.exsanguinate < 5 and debuff.rupture) 
 						or (not talent.exsanguinate and (not artifact.urgeToKill or powerDeficit >= 70)) 
 					then
 						if cast.vendetta() then return end
 					end 
			-- Vanish
					-- vanish,if=talent.nightstalker.enabled&combo_points>=cp_max_spend&((talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&(dot.rupture.ticking|time>10))|(!talent.exsanguinate.enabled&dot.rupture.refreshable))
					-- vanish,if=talent.subterfuge.enabled&dot.garrote.refreshable&((spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives)|(spell_targets.fan_of_knives>=4&combo_points.deficit>=4))
					-- vanish,if=talent.shadow_focus.enabled&energy.time_to_max>=2&combo_points.deficit>=4
					if isChecked("Vanish") and not solo then
						if (talent.nightstalker and combo >= select(5,getSpellCost(spell.rupture)) and ((talent.exsanguinate and cd.exsanguinate < 1 and (debuff.rupture or cTime > 10)) or (not talent.exsanguinate and debuff.refresh.rupture)))
							or (talent.subterfuge and debuff.refresh.garrote and (#enemies.yards10 <= 3 and comboDeficit >= 1 + #enemies.yards10) or (#enemies.yards10 >= 4 and comboDeficit >= 4))
							or (talent.shadowFocus and ttm >= 2 and comboDeficit >= 4)
 						then
							if cast.vanish() then return end
						end
					end
			-- Exsanguinate
					-- exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>4+4*cp_max_spend
					if lastSpell == spell.rupture and debuff.remain.rupture > 4 + 4 * select(5,getSpellCost(spell.rupture)) then
						if cast.exsanguinate() then return end
					end
				end -- End Cooldown Usage Check
			end -- End Action List - Cooldowns
		-- Action List - Finishers
			local function actionList_Finishers()
            -- Death From Above
            	-- death_from_above,if=combo_points>=cp_max_spend
            	if combo >= select(5,getSpellCost(spell.rupture)) then
					if cast.deathFromAbove() then return end
				end
			-- Envenom
				-- envenom,if=combo_points>=cp_max_spend-talent.master_poisoner.enabled|(talent.elaborate_planning.enabled&combo_points>=3+!talent.exsanguinate.enabled&buff.elaborate_planning.remains<2)
				if combo >= select(5,getSpellCost(spell.envenom)) - masterPoison or (talent.elaboratePlanning and combo >= 3 + noExsanguinate and buff.remain.elaboratePlanning < 2) then
					if cast.envenom() then return end
				end
			end -- End Action List - Finishers
		-- Action List - Maintain
			local function actionList_Maintain()
			-- Rupture
				-- rupture,if=(talent.nightstalker.enabled&stealthed.rogue)|(talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2+artifact.urge_to_kill.enabled))))
				if (talent.nightstalker and stealthing) or (talent.exsanguinate and ((combo >= select(5,getSpellCost(spell.rupture)) and cd.exsanguinate < 1) or (not debuff.rupture and (cTime > 10 or combo >= 2 + urges)))) then
					if cast.rupture() then return end
				end
				-- rupture,cycle_targets=1,if=combo_points>=cp_max_spend-talent.exsanguinate.enabled&refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
				for i=1, #enemies.yards5 do
					local thisUnit 			= enemies.yards5[i]
                    local ruptureRemain 	= getDebuffRemain(thisUnit,spell.spec.debuffs.rupture,"player")
                    local ruptureDuration 	= getDebuffDuration(thisUnit,spell.spec.debuffs.rupture,"player")
                    local ruptureRefresh 	= getDebuffRemain(thisUnit,spell.spec.debuffs.rupture,"player") <= getDebuffDuration(thisUnit,spell.spec.debuffs.rupture,"player") * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
	                    if combo >= select(5,getSpellCost(spell.rupture)) - exsanguinated and ruptureRefresh and (not custom.exsanguinated or ruptureRemain <= 1.5) and (ttd(thisUnit) - ruptureRemain > 4 or isDummy(thisUnit)) then
	                    	if cast.rupture(thisUnit) then return end
	                    end
	                end
                end
            -- Kingsbane
            	-- kingsbane,if=(talent.exsanguinate.enabled&dot.rupture.exsanguinated)|(!talent.exsanguinate.enabled&(debuff.vendetta.up|cooldown.vendetta.remains>10))
				if (talent.exsanguinate and exRupture) or (not talent.exsanguinate and (debuff.vendetta or cd.vendetta > 10)) then
					if cast.kingsbane() then return end
				end
			-- Garrote
				-- garrote,cycle_targets=1,if=refreshable&(!exsanguinated|remains<=1.5)&target.time_to_die-remains>4
				for i=1, #enemies.yards5 do
					local thisUnit 			= enemies.yards5[i]
                    local garroteRemain 	= getDebuffRemain(thisUnit,spell.spec.debuffs.garrote,"player")
                    local garroteDuration 	= getDebuffDuration(thisUnit,spell.spec.debuffs.garrote,"player")
                    local garroteRefresh 	= getDebuffRemain(thisUnit,spell.spec.debuffs.garrote,"player") <= getDebuffDuration(thisUnit,spell.spec.debuffs.garrote,"player") * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
	                    if garroteRefresh and (not custom.exsanguinated or garroteRemain <= 1.5) and (ttd(thisUnit) - garroteRemain > 4 or isDummy(thisUnit)) then
	                    	if cast.garrote(thisUnit) then return end
	                    end
	                end
                end
			end -- End Action List - Maintain
		-- Action List - Generators
			local function actionList_Generators()
			-- Hemorrhage
				-- hemorrhage,if=refreshable
				if debuff.refresh.hemorrhage then
					if cast.hemorrhage() then return end
				end
				-- hemorrhage,cycle_targets=1,if=refreshable&dot.rupture.ticking&spell_targets.fan_of_knives<=3
				for i=1, #enemies.yards5 do
                    local thisUnit 				= enemies.yards5[i]
                    local ruptureRemain 		= getDebuffRemain(thisUnit,spell.spec.debuffs.rupture,"player")
                    local hemorrhageRemain 		= getDebuffRemain(thisUnit,spell.spec.debuffs.hemorrhage,"player")
                    local hemorrhageDuration 	= getDebuffDuration(thisUnit,spell.spec.debuffs.hemorrhage,"player")
                    local hemorrhageRefresh 	= getDebuffRemain(thisUnit,spell.spec.debuffs.hemorrhage,"player") <= getDebuffDuration(thisUnit,spell.spec.debuffs.hemorrhage,"player") * 0.3
                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
                        if hemorrhageRefresh and ruptureRemain > 0 and #enemies.yards10 <= 3 then
                           if cast.hemorrhage(thisUnit) then return end
                        end
                    end
                end
            -- Fan of Knives
            	-- fan_of_knives,if=spell_targets>=3|buff.the_dreadlords_deceit.stack>=29
            	if ((mode.rotation == 1 and #enemies.yards8 >= 3) or mode.rotation == 2) or buff.stack.theDreadlordsDeceit >= 29 then
            		if cast.fanOfKnives() then return end
            	end
			-- Mutilate
				-- mutilate,cycle_targets=1,if=(!talent.agonizing_poison.enabled&dot.deadly_poison_dot.refreshable)|(talent.agonizing_poison.enabled&debuff.agonizing_poison.remains<debuff.agonizing_poison.duration*0.3)|(set_bonus.tier19_2pc=1&dot.mutilated_flesh.refreshable)
				if ((mode.rotation == 1 and #enemies.yards8 < 3) or mode.rotation == 3) then
					for i=1, #enemies.yards5 do
	                    local thisUnit = enemies.yards5[i]
	                    local deadlyPoisonRemain 		= getDebuffRemain(thisUnit,spell.spec.debuffs.deadlyPoison,"player")
	                    local deadlyPoisonDuration 		= getDebuffDuration(thisUnit,spell.spec.debuffs.deadlyPoison,"player")
	                    local deadlyPoisonRefresh 		= getDebuffRemain(thisUnit,spell.spec.debuffs.deadlyPoison,"player") <= getDebuffDuration(thisUnit,spell.spec.debuffs.deadlyPoison,"player") * 0.3
	                    local agonizingPoisonRemain		= getDebuffRemain(thisUnit,spell.spec.debuffs.agonizingPoison,"player")
	                    local agonizingPoisonDuration	= getDebuffDuration(thisUnit,spell.spec.debuffs.agonizingPoison,"player")
	                    local agonizingPoisonRefresh	= getDebuffRemain(thisUnit,spell.spec.debuffs.agonizingPoison,"player") <= getDebuffDuration(thisUnit,spell.spec.debuffs.agonizingPoison,"player") * 0.3
	                    if (multidot or (UnitIsUnit(thisUnit,units.dyn5) and not multidot)) then
	                    	if (not talent.agonizingPoison and deadlyPoisonRefresh) or (talent.agonizingPoison and agonizingPoisonRefresh) then
	                    		if cast.mutilate(thisUnit) then return end
	                    	end
	                    end
	                end
					-- mutilate
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
                	if isChecked("Opener") and isBoss("target") and opener == false then
						if not GAR1 then
                -- Garrote
           					if castOpener("garrote","GAR1",1) then return end
           				elseif GAR1 and not MUT1 then
           		-- Mutilate
           					if castOpener("mutilate","MUT1",2) then return end
           				elseif MUT1 and not RUP1 then
           		-- Rupture
           					if castOpener("rupture","RUP1",3) then return end
           				elseif RUP1 and not VEN1 then
           		-- Vendetta
           					if castOpener("vendetta","VEN1",4) then return end
           				elseif VEN1 and not RAC1 then
           		-- Racial
           					if race == "Orc" or race == "Troll" or race == "BloodElf" then
           						if castSpell("player",racial,false,false,false) then print("5: Racial"); RAC1 = true; return else print("5: Racial (Uncastable)"); RAC1 = true; return end
           					else
           						print("5: Racial (Uncastable)");
           						RAC1 = true;
           						return
           					end 
	           			elseif RAC1 and not MUT2 then
           		-- Mutilate
           					if castOpener("mutilate","MUT2",6) then return end
           				elseif MUT2 and not VAN1 then
           		-- Vanish
           					if castOpener("vanish","VAN1",7) then return end
           				elseif VAN1 and not RUP2 then
           		-- Rupture
           					if castOpener("rupture","RUP2",8) then return end
           				elseif RUP2 and not EXS1 then
           		-- Exsanguinate
           					if castOpener("exsanguinate","EXS1",9) then return end
           				elseif EXS1 and not KIN1 then
           		-- Kingsbane
           					if castOpener("kingsbane","KIN1",10) then return end
           				elseif KIN1 then
           					opener = true;
           					return
           				end
	            	elseif not isBoss("target") or not isChecked("Opener") then
	            		if combo >= 2 and not debuff.rupture and cTime < 10 and not artifact.urgeToKill and getOptionValue("Stealth Breaker") == 1 then
	                		if cast.rupture("target") then opener = true; return end
	                	elseif combo >= 4 and not debuff.rupture and getOptionValue("Stealth Breaker") == 1 then
	                		if cast.rupture("target") then opener = true; return end
	                	elseif level >= 48 and not debuff.garrote and cd.garrote <= 1 and getOptionValue("Stealth Breaker") == 1 then
	                		if cast.garrote("target") then opener = true; return end
	                	elseif level >= 29 and getOptionValue("Stealth Breaker") == 2 then
	                		if cast.cheapShot("target") then opener = true; return end
	                	else
	                		if cast.mutilate("target") then opener = true; return end
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
	--------------------------
	--- Interrupt Rotation ---
	--------------------------
 				if actionList_Interrupts() then return end				
	------------------------------
	--- Out of Combat Rotation ---
	------------------------------
				if actionList_PreCombat() then return end
				if opener == false then
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
					if opener == true then
						if actionList_Cooldowns() then return end
					end
	----------------------------------
	--- In Combat - Begin Rotation ---
	----------------------------------
			-- Shadowstep
	                if isChecked("Shadowstep") then
	                    if cast.shadowstep("target") then return end 
	                end
	                if opener == false and isChecked("Opener") and isBoss("target") then
	                    if actionList_Opener() then return end
	                end
	                if (not stealthing or (isDummy("target") and lastSpell == spell.vanish)) and opener == true then
	                	if getDistance(units.dyn5) < 5 then
	                		StartAttack()
	                	end
	       	-- Call Action List - Maintain
	       				-- call_action_list,name=maintain 
	       				if actionList_Maintain() then return end
	       	-- Call Action List - Finisher
	       				-- call_action_list,name=finish,if=(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)&(!dot.rupture.refreshable|(dot.rupture.exsanguinated&dot.rupture.remains>=3.5)|target.time_to_die-dot.rupture.remains<=4)&active_dot.rupture>=spell_targets.rupture
	       				if (not talent.exsanguinate or cd.exsanguinate > 2) and (not debuff.refresh.rupture or (exRupture and debuff.remain.rupture >= 3.5) or (ttd(units.dyn5) - debuff.remain.rupture <= 4 or isDummy(units.dyn5))) and (custom.ruptureCount >= #enemies.yards5 or not mutidot) then
	       					if actionList_Finishers() then return end
	       				end
	       	-- Call Action List - Builders
	       				-- call_action_list,name=build,if=(combo_points.deficit>0|energy.time_to_max<1)
	       				if (comboDeficit > 0 or ttm < 1) then
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