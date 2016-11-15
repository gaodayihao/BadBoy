if select(2, UnitClass("player")) == "PRIEST" then
	local rotationName = "Ellis"

---------------
--- Toggles ---
---------------
	local function createToggles()
        -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.mindFlay },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.mindSear },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.mindFlay },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.shadowMend}
        };
        CreateButton("Rotation",1,0)
        -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.powerInfusion },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.powerInfusion },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.powerInfusion }
        };
       	CreateButton("Cooldown",2,0)
        -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.dispersion },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.dispersion }
        };
        CreateButton("Defensive",3,0)
        -- Void Form Button
        VoidEruptionModes = {
            [1] = { mode = "On", value = 1 , overlay = "Void Eruption Enabled", tip = "Void Eruption will be used.", highlight = 1, icon = bb.player.spell.voidEruption },
            [2] = { mode = "Off", value = 2 , overlay = "Void Eruption Disabled", tip = "Void Eruption will not be used.", highlight = 0, icon = bb.player.spell.voidEruption }
        };
        CreateButton("VoidEruption",4,0)
    end

---------------
--- OPTIONS ---
---------------
	local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
        -- General Options
            section = bb.ui:createSection(bb.ui.window.profile, LC_GENERAL)
            -- SWP Max Targets
                bb.ui:createSpinnerWithout(section, LC_SWP_MAX_TARGETS,  6,  1,  10,  1, LC_SWP_MAX_TARGETS_DESCRIPTION)
            -- VT Max Targets
                bb.ui:createSpinnerWithout(section, LC_VT_MAX_TARGETS,  3,  1,  10,  1, LC_VT_MAX_TARGETS_DESCRIPTION)
            -- VT Max Targets
                bb.ui:createSpinnerWithout(section, LC_DOT_MINIMUM_HEALTH,  3,  1,  5,  1, LC_DOT_MINIMUM_HEALTH_DESCRIPTION)
            -- Body And Soul
                bb.ui:createSpinner(section, LC_BODY_AND_SOUL,  1.5,  0,  5,  0.5, LC_BODY_AND_SOUL_DESCRIPTION)
            bb.ui:checkSectionState(section)
        -- Pre-Pull BossMod
            section = bb.ui:createSection(bb.ui.window.profile, LC_PRE_PULL_BOSSMOD)
            -- Pre-Pull Timer
                bb.ui:createSpinner(section, LC_PRE_PULL_TIMER,  3,  1,  10,  1,  LC_PRE_PULL_TIMER_DESCRIPTION)
            -- Potion
                bb.ui:createDropdown(section, LC_POTION, {LC_DEADLY_GRACE,LC_PROLONGED_POWER}, 1)
            -- Flask
                bb.ui:createCheckbox(section,LC_FLASK)
            bb.ui:checkSectionState(section)
        -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
            -- Int Pot
                bb.ui:createCheckbox(section,"Int Pot")
            -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
            -- Touch of the Void
                if hasEquiped(128318) then
                    bb.ui:createCheckbox(section,"Touch of the Void")
                end
            -- Shadowfiend
                bb.ui:createCheckbox(section,"Shadowfiend / Mind Bender")
            -- Power Infusion
                bb.ui:createCheckbox(section,"Power Infusion")
            bb.ui:checkSectionState(section)
        -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, LC_DEFENSIVE)
            -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
            -- Power Word: Shield
                bb.ui:createSpinner(section, "Power Word: Shield",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Dispel Magic
                bb.ui:createCheckbox(section,"Dispel Magic")
            -- Vampiric Embrace
                bb.ui:createSpinner(section, LC_VAMPIRIC_EMBRACE,  40,  1,  100,  5, LC_VAMPIRIC_EMBRACE_DESCRIPTION)
            bb.ui:checkSectionState(section)
        -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
                bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
                bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
            -- Pause Toggle
                bb.ui:createDropdown(section, "Pause Mode", bb.dropOptions.Toggle,  6)
            bb.ui:checkSectionState(section)
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
        --if bb.timer:useTimer("debugShadow", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
            UpdateToggle("VoidEruption",0.25)
    --------------
    --- Locals ---
    --------------
            local addsExist                                     = false 
            local addsIn                                        = 999
            local artifact                                      = bb.player.artifact
            local buff                                          = bb.player.buff
            local canFlask                                      = canUse(bb.player.flask.wod.intellectBig)
            local cast                                          = bb.player.cast
            local castable                                      = bb.player.cast.debug
            local combatTime                                    = getCombatTime()
            local cd                                            = bb.player.cd
            local charges                                       = bb.player.charges
            local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
            local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or ObjectExists("target"), UnitIsPlayer("target")
            local debuff                                        = bb.player.debuff
            local enemies                                       = bb.player.enemies
            local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
            local flaskBuff                                     = getBuffRemain("player",bb.player.flask.wod.buff.intellectBig)
            local friendly                                      = friendly or UnitIsFriend("target", "player")
            local gcd                                           = bb.player.gcd
            local hasMouse                                      = ObjectExists("mouseover")
            --local healPot                                       = getHealthPot()
            local inCombat                                      = bb.player.inCombat
            local inInstance                                    = bb.player.instance=="party"
            local inRaid                                        = bb.player.instance=="raid"
            local lastSpell                                     = lastSpellCast
            local level                                         = bb.player.level
            --local lootDelay                                     = getOptionValue("LootDelay")
            --local lowestHP                                      = bb.friend[1].unit
            local mode                                          = bb.player.mode
            --local moveIn                                        = 999
            --local multidot                                      = (useCleave() or bb.player.mode.rotation ~= 3)
            local perk                                          = bb.player.perk        
            local php                                           = bb.player.health
            --local playerMouse                                   = UnitIsPlayer("mouseover")
            local power, powmax, powgen, powerDeficit           = bb.player.power, bb.player.powerMax, bb.player.powerRegen, bb.player.powerDeficit
            local pullTimer                                     = bb.DBM:getPulltimer()
            local racial                                        = bb.player.getRacial()
            local recharge                                      = bb.player.recharge
            local solo                                          = bb.player.instance=="none"
            local spell                                         = bb.player.spell
            local talent                                        = bb.player.talent
            local thp                                           = getHP(bb.player.units.dyn40)
            local ttd                                           = getTTD
            --local ttm                                           = bb.player.timeToMax
            local units                                         = bb.player.units
            
            local SWPmaxTargets                                 = getOptionValue(LC_SWP_MAX_TARGETS)
            local VTmaxTargets                                  = getOptionValue(LC_VT_MAX_TARGETS)

            local s2mcheck                                      = 0
            local nAP                                           = -1

            if useMindBlast == nil then useMindBlast = false end
            if rawHastePct == nil then rawHastePct = 0 end

            --if leftCombat == nil then leftCombat = GetTime() end
            --if profileStop == nil then profileStop = false end
            --if IsHackEnabled("NoKnockback") ~= nil then SetHackEnabled("NoKnockback", false) end
            
    --------------------
    -- Custom Function--
    --------------------
            function usePotion()
                if isChecked(LC_POTION) and inRaid then
                    if getOptionValue(LC_POTION) == 1 and canUse(127843) and not buff.deadlyGrace then -- Deadly Grace
                        useItem(127843)
                    elseif getOptionValue(LC_POTION) == 2 and canUse(142117) and not buff.prolongedPower then -- Prolonged Power
                        useItem(142117)
                    end
                end
            end

            function nonexecuteActorsPct()
                local execute, nonexecute = 0, 0

                for i = 1, #bb.friend do
                    local specId
                    if UnitIsPlayer(bb.friend[i].unit) then
                        local specIndex = GetSpecialization()
                        if specIndex then
                            specId = select(1, GetSpecializationInfo(specIndex))
                        end
                    else
                        specId = GetInspectSpecialization(bb.friend[i].unit)
                    end

                    if specId == 258 or     -- PRIEST_SHADOW
                       specId == 71  or     -- WARRIOR_ARMS
                       specId == 72  or     -- WARRIOR_FURY
                       specId == 254 then   -- HUNTER_MARKSMANSHIP
                        execute = execute + 1
                    else
                        nonexecute = nonexecute + 1
                    end
                end

                local divisor = nonexecute + execute
                if divisor > 0 then
                    return nonexecute / divisor
                else
                    return 0
                end

                return 0
            end

            function updateRawHate()
                if bb.timer:useTimer("debugUpdateRawHate", 2) then
                    if not hasBloodLust() and buff.stack.voidForm == 0 and not buff.powerInfusion then
                        rawHastePct = round2(GetHaste()/100,4)
                    end
                end
            end

            function analyzeS2M()
                if inCombat then 
                    local targetTTD = ttd("target")
                -- variable,op=set,name=actors_fight_time_mod,value=0
                    local actorsFightTimeMod = 0
                -- variable,op=set,name=actors_fight_time_mod,value=-((-(450)+(time+target.time_to_die))%10),if=time+target.time_to_die>450&time+target.time_to_die<600
                    if combatTime + targetTTD > 450 and combatTime + targetTTD < 600 then
                        actorsFightTimeMod = -((-(450) + (combatTime + targetTTD)) % 10)
                -- variable,op=set,name=actors_fight_time_mod,value=((450-(time+target.time_to_die))%5),if=time+target.time_to_die<=450
                    elseif combatTime + targetTTD <= 450 then
                        actorsFightTimeMod = ((450 - (combatTime + targetTTD)) % 5)
                    end
                -- variable,op=set,name=s2mcheck,value=0.8*(135+((raw_haste_pct*25)*(2+(1*talent.reaper_of_souls.enabled)+(2*artifact.mass_hysteria.rank)-(1*talent.sanlayn.enabled))))-(variable.actors_fight_time_mod*nonexecute_actors_pct)
                    if nAP == -1 then
                        nAP = nonexecuteActorsPct()
                    end
                    local reaperOfSoulsNum = 0
                    local sanlarynNum = 0
                    if talent.reaperOfSouls then
                        reaperOfSoulsNum = 1
                    end
                    if talent.sanlaryn then
                        sanlarynNum = 1
                    end
                    s2mcheck = 0.8 * (135+((rawHastePct*25)*(2+(1*reaperOfSoulsNum)+(2*artifact.rank.massHysteria)-(1*sanlarynNum))))
                                -(actorsFightTimeMod*nAP)
                    s2mcheck = s2mcheck * 0.9 -- 2016/11/15 hotfix
                -- variable,op=min,name=s2mcheck,value=180
                    s2mcheck = math.min(s2mcheck,180)
                    --print(s2mcheck)
                else
                    nAP = -1
                    updateRawHate()
                end
            end
    --------------------
    --- Action Lists ---
    --------------------
        -- Action list - Extras
            function actionList_Extra()
                analyzeS2M()
            end -- End Action List - Extra
        -- Action List - Defensive
            function actionList_Defensive()
                if useDefensive() and getHP("player")>0 then
                    -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race=="Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                    -- Power Word: Shield
                    if isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield then
                        if cast.powerWordShield("player") then return end
                    end
                end -- End Defensive Check
            end -- End Action List - Defensive
        -- Action List - Interrupts
            function actionList_Interrupts()

            end -- End Action List - Interrupts
        -- Action List - Cooldowns
            function actionList_Cooldowns()
                if useCDs() then
                -- Potion
                    -- potion,name=deadly_grace,if=buff.bloodlust.react|target.time_to_die<=40|(buff.voidform.stack>80&buff.power_infusion.up)
                    if hasBloodLust() or ttd("target") <= 40 or (buff.stack.voidForm > 80 and buff.powerInfusion) then
                        usePotion()
                    end
                end
            end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
            function actionList_PreCombat()
                if not (IsFlying() or IsMounted()) then
                -- Flask
                    --flask,type=flask_of_the_whispered_pact
                    if isChecked(LC_FLASK) then
                        if canFlask and flaskBuff < 420 then
                            useItem(bb.player.flask.wod.intellectBig)
                            return true
                        end
                    end
                
                -- Shadowform
                    if not buff.shadowform then
                        if cast.shadowform() then return end
                    end
                    
                    if isChecked(LC_PRE_PULL_TIMER) and pullTimer <= getOptionValue(LC_PRE_PULL_TIMER) then
                    -- Potion
                        usePotion()
                    end
                end
            end  -- End Action List - Pre-Combat
        -- Action List - Single
            function actionList_Auto()
                --Surrender to Madness
                --MindBender
                if isChecked("Shadowfiend / Mind Bender") and talent.mindBender then
                    if cast.mindBender() then return end
                end
                -- Void Eruption
                if mode.voidEruption == 1 and ((talent.legacyOfTheVoid and power > 70) or power > 100) then
                    if cast.voidEruption() then return end
                end
                -- Shadow Crash
                if cast.shadowCrash() then return end
                
                -- Shadow Word Death
                -- if ChargesRemaining(ShadowWordDeath) = SpellCharges(ShadowWordDeath)
                if charges.shadowWordDeath == charges.max.shadowWordDeath then
                    if cast.shadowWordDeath() then return end
                end
                -- Mind Blast
                if cast.mindBlast() then return end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 4 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                end
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") > 4 and debuff.count.shadowWordPain < SWPmaxTargets and (debuff.count.vampiricTouch >= 1 or isMoving("player")) then
                    for i=1,#enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if getDebuffRemain(thisUnit,spell.shadowWordPain,"player") <= 4 then
                            if cast.shadowWordPain(thisUnit) then return end 
                        end
                    end
                end              
                -- Vampiric Touch
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 6 and not isCastingSpell(spell.vampiricTouch)then
                    if cast.vampiricTouch(units.dyn40) then return end 
                end
                if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") > 6 and not isCastingSpell(spell.vampiricTouch) and debuff.count.vampiricTouch < VTmaxTargets and debuff.count.shadowWordPain >= 1 then
                    for i=1,#enemies.yards40 do
                        local thisUnit = enemies.yards40[i]
                        if getDebuffRemain(thisUnit,spell.vampiricTouch,"player") <= 6 then
                            if cast.vampiricTouch(thisUnit) then return end 
                        end
                    end
                end 
                -- Shadow Word: Void
                if cast.shadowWordVoid() then return end
                -- Mind Shear
                -- Mind Spike / Mind Flay
                if talent.mindSpike then
                    if cast.mindSpike() then return end
                else
                    if cast.mindFlay() then return end
                end
            end -- End Action List - Single

        -- Action List - VoidForm
            function actionList_VoidForm()
                --NoMindBlastSwitch
                if isCastingSpell(spell.mindFlay) or lastSpellCast == spell.mindSpike then
                    useMindBlast = false
                else
                    useMindBlast = true
                end
                --Cooldowns
                if actionList_Cooldowns() then return end
                --Void Torrent
                if ttd(units.dyn40) > 5 and getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") >= 6 and getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") >= 4 then
                    if cast.voidTorrent() then return end
                end
                --VoidBolt
                if cast.voidBolt() then return end 
                --Dispersion
                -- if HasBuff(SurrenderedSoul) and Abs(AlternatePowerRegen * GlobalCooldownSec) > AlternatePower and not CanUse(ShadowWordDeath)
                if buff.surrenderedSoul and (powgen * gcd) > power and not cast.shadowWordDeath(units.dyn40,true) then
                    if cast.dispersion() then return end
                end
                --MindBender
                if useCDs() and isChecked("Shadowfiend / Mind Bender") and talent.mindBender then
                    if cast.mindBender() then return end  
                end
                --Power Infusion
                -- if (BuffStack(Voidform) >= 10 and not HasBuff(SurrenderedSoul)) or BuffStack(Voidform) > 60
                if useCDs() and isChecked("Power Infusion") and (buff.stack.voidForm >= 10 and not buff.surrenderedSoul) or buff.stack.voidForm >= 60 then
                    if cast.powerInfusion() then return end 
                end
                
                --Shadow Crash
                if talent.shadowCrash then
                    if cast.shadowCrash() then return end
                end
                --SWD
                -- if not HasBuff(SurrenderedSoul) and ((HasTalent(ReaperOfSouls) and AlternatePowerToMax >= 30) or not HasTalent(ReaperOfSouls))
                if not buff.surrenderedSoul and (talent.reaperOfSouls and powerDeficit >= 30) or not talent.reaperOfSouls then
                    if cast.shadowWordDeath()then return end
                end
                --SWD
                --if HasBuff(SurrenderedSoul) and ((AlternatePowerToMax >= 75 and HasTalent(ReaperOfSouls)) or (AlternatePowerToMax >= 25 and not HasTalent(ReaperOfSouls)))
                if buff.surrenderedSoul and ((powerDeficit >= 75 and talent.reaperOfSouls) or (powerDeficit >= 25 and not talent.reaperOfSouls)) then
                    if cast.shadowWordDeath()then return end
                end
                -- Mind Blast
                -- if IsSwitchOff(NoMindBlast)
                if useMindBlast then
                    if cast.mindBlast() then return end
                end
                -- SWD
                -- if ChargesRemaining(ShadowWordDeath) = SpellCharges(ShadowWordDeath)
                if charges.shadowWordDeath == charges.max.shadowWordDeath then
                    if cast.shadowWordDeath() then return end
                end
                -- Shadow Word: Void
                -- if (AlternatePowerToMax >= 35 and not HasBuff(SurrenderedSoul)) or (HasBuff(SurrenderedSoul) and AlternatePowerToMax >= 50)
                if (powerDeficit >= 35 and not buff.surrenderedSoul) or (buff.surrenderedSoul and powerDeficit >= 50) then
                    if cast.shadowWordVoid() then return end
                end
                -- Shadowfiend
                if useCDs() and isChecked("Shadowfiend / Mind Bender") and buff.stack.voidForm > 15 then
                    if cast.shadowfiend() then return end
                end
                -- Shadow Word: Pain
                if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 4 then
                    if cast.shadowWordPain(units.dyn40) then return end 
                end              
                -- Vampiric Touch
                 if getDebuffRemain(units.dyn40,spell.vampiricTouch,"player") <= 6 and not isCastingSpell(spell.vampiricTouch) then
                    if cast.vampiricTouch(units.dyn40) then return end 
                end 
                -- Mind Sear
                -- Mind Spike / Mind Flay
                if talent.mindSpike then
                    if cast.mindSpike() then return end
                else
                    if cast.mindFlay() then return end
                end
            end -- End Action List - VoidForm
    -----------------
    --- Rotations ---
    -----------------
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
    ---------------------------------
    --- Out Of Combat - Rotations ---
    ---------------------------------
            if inRaid and not inCombat and isBoss() and isValidUnit("target") then
                if actionList_PreCombat() then return end
            end
    -----------------------------
    --- In Combat - Rotations --- 
    -----------------------------
            if inCombat and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.voidTorrent) then

                if buff.voidForm then
                    if actionList_VoidForm() then return end
                else
                    if actionList_Auto() then return end
                end     
            end -- End Combat Rotation
        --end -- End Timer
    end -- Run Rotation

    tinsert(cShadow.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check