
function cFileBuild(cFileName,self)
    -- local timeStart = debugprofilestop()
    -- Make tables if not existing
    if self.detect          == nil then self.detect             = {} end                                                            -- Detect
    if self.detect.rage     == nil then self.detect.rage        = {["y8"]=8,["y10"]=10,["y12"]=12,["y20"]=20} end                   -- Detect Rage
    -- if self.artifact        == nil then self.artifact           = {} end        -- Artifact Trait Info
    -- if self.artifact.rank   == nil then self.artifact.rank      = {} end        -- Artifact Trait Rank

    -- Update Power
    self.mana           = UnitPower("player", 0)
    self.rage           = UnitPower("player", 1)
    self.focus          = UnitPower("player", 2)
    self.energy         = UnitPower("player", 3)
    self.comboPoints    = UnitPower("player", 4)
    self.runes          = UnitPower("player", 5)
    self.runicPower     = UnitPower("player", 6)
    self.soulShards     = UnitPower("player", 7)
    self.lunarPower     = UnitPower("player", 8)
    self.holyPower      = UnitPower("player", 9)
    self.altPower       = UnitPower("player",10)
    self.maelstrom      = UnitPower("player",11)
    self.chi            = UnitPower("player",12)
    self.insanity       = UnitPower("player",13)
    self.obsolete       = UnitPower("player",14)
    self.obsolete2      = UnitPower("player",15)
    self.arcaneCharges  = UnitPower("player",16)
    self.fury           = UnitPower("player",17)
    self.pain           = UnitPower("player",18)
    self.powerRegen     = getRegen("player")
    self.timeToMax      = getTimeToMax("player")

    -- -- Build Best Unit per Range
    -- local typicalRanges = {
    --     40,
    --     35,
    --     30,
    --     25,
    --     20,
    --     15,
    --     13,
    --     12,
    --     10,
    --     8,
    --     5,
    -- }
    -- -- for i = 40, 5, -1 do
    -- for x = 1, #typicalRanges do
    --     local i = typicalRanges[x]
    --     self.units["dyn"..tostring(i)]                  = dynamicTarget(i, true)
    --     self.units["dyn"..tostring(i).."AoE"]           = dynamicTarget(i, false)
    --     -- if i == 40 then 
    --         self.enemies["yards"..tostring(i)]              = getEnemies("player",i)
    --         self.enemies["yards"..tostring(i).."t"]         = getEnemies(self.units["dyn"..tostring(i)],i)
    --     -- elseif i < 40 then
    --     --     local theseUnits = self.enemies["yards"..tostring(i + 1)]
    --     --     self.enemies["yards"..tostring(i)]      = getTableEnemies("player",i,theseUnits)
    --     --     self.enemies["yards"..tostring(i).."t"] = getTableEnemies(self.units["dyn"..tostring(i)],i,theseUnits)
    --     -- end
    -- end

    -- Select class/spec Spell List
    if cFileName == "class" then
        ctype = self.spell.class
    end
    if cFileName == "spec" then
        ctype = self.spell.spec
    end

    -- Build Unit/Enemies Tables per Spell Range
    for k,v in pairs(ctype.abilities) do
        local spellCast = v
        local spellName = GetSpellInfo(v)
        local minRange = select(5,GetSpellInfo(spellName))
        local maxRange = select(6,GetSpellInfo(spellName))
        if maxRange == nil or maxRange <= 0 then
            maxRange = 5
        end
        if not self.detect.rage["y"..tostring(maxRange)] then
            self.detect.rage["y"..tostring(maxRange)] = maxRange
        end
    end
    -- Unit/Enemies Table Common Checks Independant of Spells
    if cFileName == "spec" then
        self.units.dyn40 = dynamicTarget(40,  true)
        self.units.dyn40AoE = dynamicTarget(40,  false)
        self.enemies.yards40 = getEnemies("player",40)
        self.enemies.yards40t  = getEnemies(self.units.dyn40,40)
        local theseUnits = self.enemies.yards40
        for k,v in pairs(self.detect.rage) do
            if v ~= 40 then
                self.units["dyn"..tostring(v)]           = dynamicTarget(v,  true)
                self.units["dyn"..tostring(v).."AoE"]    = dynamicTarget(v,  false)
                self.enemies["yards"..tostring(v)]       = getTableEnemies("player",v,theseUnits)
                self.enemies["yards"..tostring(v).."t"]  = getTableEnemies(self.units["dyn"..tostring(v)],v,theseUnits)
            end
        end
    end

    -- if not UnitAffectingCombat("player") then
        -- Build Artifact Info
        for k,v in pairs(ctype.artifacts) do
            self.artifact[k] = hasPerk(v) or false
            self.artifact.rank[k] = getPerkRank(v) or 0
        end

        -- Build Talent Info
        for k,v in pairs(ctype.talents) do
            self.talent[k] = br.talent[v]
        end
    -- end

    -- Build Buff Info
    for k,v in pairs(ctype.buffs) do
        -- Build Buff Table
        if self.buff[k] == nil then self.buff[k] = {} end
        self.buff[k].exists     = UnitBuffID("player",v) ~= nil
        self.buff[k].duration   = getBuffDuration("player",v)
        self.buff[k].remain     = getBuffRemain("player",v)
        self.buff[k].refresh    = self.buff[k].remain <= self.buff[k].duration * 0.3
        self.buff[k].stack      = getBuffStacks("player",v)
    end

    -- Build Debuff Info
    function self.getSnapshotValue(dot)
        -- Feral Bleeds
        if cFileName == "spec" then
            if GetSpecializationInfo(GetSpecialization()) == 103 then
                local multiplier        = 1.00
                local Bloodtalons       = 1.30
                local SavageRoar        = 1.40
                local TigersFury        = 1.15
                local RakeMultiplier    = 1
                -- Bloodtalons
                if self.buff.bloodtalons.exists then multiplier = multiplier*Bloodtalons end
                -- Savage Roar
                if self.buff.savageRoar.exists then multiplier = multiplier*SavageRoar end
                -- Tigers Fury
                if self.buff.tigersFury.exists then multiplier = multiplier*TigersFury end
                -- rip
                if dot == ctype.debuffs.rip then
                    -- -- Versatility
                    -- multiplier = multiplier*(1+Versatility*0.1)
                    -- return rip
                    return 5*multiplier
                end
                -- rake
                if dot == ctype.debuffs.rake then
                    -- Incarnation/Prowl
                    if self.buff.incarnationKingOfTheJungle.exists or self.buff.prowl.exists then
                        RakeMultiplier = 2
                    end
                    -- return rake
                    return multiplier*RakeMultiplier
                end
            end
        end
        return 0
    end
    for k,v in pairs(ctype.debuffs) do
        -- Build Debuff Table for all enemy units
        if self.debuff[k] == nil then self.debuff[k] = {} end
        -- Setup debuff table per valid unit and per debuff
        for i = 1, #self.enemies.yards40 do
            local thisUnit = self.enemies.yards40[i]
            -- if hasThreat(thisUnit) or (not hasThreat(thisUnit) and getHP(thisUnit) < 100 and UnitIsUnit(thisUnit,"target")) or isDummy(thisUnit) then
                if self.debuff[k][thisUnit]         == nil then self.debuff[k][thisUnit]            = {} end
                if self.debuff[k][thisUnit].applied == nil then self.debuff[k][thisUnit].applied    = 0 end
                self.debuff[k][thisUnit].exists         = UnitDebuffID(thisUnit,v,"player") ~= nil
                if self.debuff[k][thisUnit].exists then
                    self.debuff[k][thisUnit].duration       = getDebuffDuration(thisUnit,v,"player")
                    self.debuff[k][thisUnit].remain         = getDebuffRemain(thisUnit,v,"player")
                    self.debuff[k][thisUnit].refresh        = self.debuff[k][thisUnit].remain <= self.debuff[k][thisUnit].duration * 0.3
                    self.debuff[k][thisUnit].stack          = getDebuffStacks(thisUnit,v,"player")
                    self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
                else
                    self.debuff[k][thisUnit].duration       = 0
                    self.debuff[k][thisUnit].remain         = 0
                    self.debuff[k][thisUnit].refresh        = true
                    self.debuff[k][thisUnit].stack          = 0
                    self.debuff[k][thisUnit].calc           = 0
                end
                if UnitIsUnit(thisUnit,"target") then self.debuff[k]["target"] = self.debuff[k][thisUnit] end
            -- end
        end
        -- Remove non-valid entries
        for c,v in pairs(self.debuff[k]) do
            local thisUnit = c
            if not ObjectExists(thisUnit) or UnitIsDeadOrGhost(thisUnit) then self.debuff[k][c] = nil end
        end 
    end
    -- for k,v in pairs(ctype.debuffs) do
    --     -- Build Debuff Table for all units in 40yrds
    --     if self.debuff[k] == nil then self.debuff[k] = {} end
    --     for i = 1, #self.enemies.yards40 do
    --         local thisUnit = self.enemies.yards40[i]
    --         -- Setup debuff table per unit and per debuff
    --         if self.debuff[k][thisUnit]         == nil then self.debuff[k][thisUnit]            = {} end
    --         if self.debuff[k][thisUnit].applied == nil then self.debuff[k][thisUnit].applied    = 0 end
    --         if br.tracker.query(UnitGUID(thisUnit),v) ~= false then
    --             local spell = br.tracker.query(UnitGUID(thisUnit),v)
    --             -- Get the Debuff Info
    --             self.debuff[k][thisUnit].exists         = true
    --             self.debuff[k][thisUnit].duration       = spell.duration
    --             self.debuff[k][thisUnit].remain         = spell.remain
    --             self.debuff[k][thisUnit].refresh        = spell.refresh
    --             self.debuff[k][thisUnit].stack          = spell.stacks
    --             self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
    --             -- self.debuff[k][thisUnit].applied        = 0
    --         else
    --             -- Zero Out the Debuff Info
    --             self.debuff[k][thisUnit].exists         = false
    --             self.debuff[k][thisUnit].duration       = 0
    --             self.debuff[k][thisUnit].remain         = 0
    --             self.debuff[k][thisUnit].refresh        = true
    --             self.debuff[k][thisUnit].stack          = 0
    --             self.debuff[k][thisUnit].calc           = self.getSnapshotValue(v)
    --             self.debuff[k][thisUnit].applied        = 0
    --         end
    --     end
    -- end

    -- Cycle through Abilities List
    for k,v in pairs(ctype.abilities) do
        if self.cast            == nil then self.cast               = {} end        -- Cast Spell Functions
        if self.cast.debug      == nil then self.cast.debug         = {} end        -- Cast Spell Debugging
        if self.charges.frac    == nil then self.charges.frac       = {} end        -- Charges Fractional
        if self.charges.max     == nil then self.charges.max        = {} end        -- Charges Maximum 

        -- Build Spell Charges
        self.charges[k]     = getCharges(v)
        self.charges.frac[k]= getChargesFrac(v)
        self.charges.max[k] = getChargesFrac(v,true)
        self.recharge[k]    = getRecharge(v)

        -- Build Spell Cooldown
        self.cd[k] = getSpellCD(v)

        -- Build Cast Funcitons
        self.cast[k] = function(thisUnit,debug,minUnits,effectRng)
            local spellCast = v
            local spellName = GetSpellInfo(v)
            local minRange = select(5,GetSpellInfo(spellName))
            local maxRange = select(6,GetSpellInfo(spellName))
            if IsHelpfulSpell(spellName) then 
                thisUnit = "player"
                amIinRange = true 
            elseif thisUnit == nil then
                if IsUsableSpell(v) and isKnown(v) then
                    if maxRange ~= nil and maxRange > 0 then
                        thisUnit = self.units["dyn"..tostring(maxRange)]
                        amIinRange = getDistance(thisUnit) < maxRange 
                    else
                        thisUnit = self.units.dyn5
                        amIinRange = getDistance(thisUnit) < 5  
                    end
                end
            elseif thisUnit == "best" then
                amIinRange = true
            elseif IsSpellInRange(spellName,thisUnit) == nil then
                amIinRange = true
            else
                amIinRange = IsSpellInRange(spellName,thisUnit) == 1
            end
            if minUnits == nil then minUnits = 1 end
            if effectRng == nil then effectRng = 8 end
            if IsUsableSpell(v) and getSpellCD(v) == 0 and isKnown(v) and amIinRange then
                if debug == "debug" then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    if thisUnit == "best" then
                        return castGroundAtBestLocation(spellCast,effectRng,minUnits,maxRange,minRange,debug)
                    elseif debug == "ground" then
                        if getLineOfSight(thisUnit) then 
                           return castGround(thisUnit,spellCast,maxRange,minRange)
                        end
                    elseif debug == "dead" then
                        if thisUnit == nil then thisUnit = "player" end
                        return castSpell(thisUnit,spellCast,false,false,false,false,true)
                    else
                        if thisUnit == nil then thisUnit = "player" end
                        return castSpell(thisUnit,spellCast,false,false,false)
                    end
                end
            elseif debug == "debug" then
                return false
            end
        end
        -- Build Cast Debug
        self.cast.debug[k] = self.cast[k](nil,"debug")
    end
-- local duration = debugprofilestop()-timeStart
-- local average = duration/1
-- local cycles = 1
-- print(format("Function executed %i time(s) in %f ms (%f average)", cycles, duration, average))
end