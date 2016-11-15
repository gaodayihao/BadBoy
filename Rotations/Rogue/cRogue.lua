-- Inherit from: ../cCharacter.lua
-- All Rogue specs inherit from this file
if select(2, UnitClass("player")) == "ROGUE" then
    cRogue = {}
    -- Creates Rogue with given specialisation
    function cRogue:new(spec)
        local self = cCharacter:new("Rogue")

        local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES ---
    -----------------

        self.profile                    = spec
        self.comboPoints                = UnitPower("player",4)
        self.comboPointsMax             = UnitPowerMax("player",4)
        self.buff.duration              = {}       -- Buff Durations
        self.buff.remain                = {}       -- Buff Time Remaining
        self.buff.stack                 = {}
        self.buff.refresh               = {}
        self.cast                       = {}       -- Cast Spell Functions
        self.cast.debug                 = {}       -- Cast Spell Functions Debug
        self.debuff.duration            = {}       -- Debuff Durations
        self.debuff.remain              = {}       -- Debuff Time Remaining
        self.debuff.refresh             = {}       -- Debuff Refreshable
        self.spell.class                = {}        -- Abilities Available To All Rogues
        self.spell.class.abilities = {
            cheapShot                   = 1833,
            cloakOfShadows              = 31224,
            crimsonVial                 = 185311,
            deathFromAbove              = 152150,
            distract                    = 1725,
            feint                       = 1966,
            goremawsBite                = 209783, --809784
            kick                        = 1766,
            markedForDeath              = 137619,
            pickLock                    = 1804,
            pickPocket                  = 921,
            sap                         = 6770,
            shadowmeld                  = 58984,
            sprint                      = 2983,
            stealth                     = 115191, --1784,
            tricksOfTheTrade            = 57934,
            vanish                      = 1856,
        }
        self.spell.class.artifacts  = {        -- Artifact Traits Available To All Rogues
            artificialStamina           = 211309,
        }
        self.spell.class.buffs      = {        -- Buffs Available To All Rogues
            cloakOfShadows              = 31224,
            feint                       = 1966,
            shadowmeld                  = 58984,
            stealth                     = 115191, --1784,
            vanish                      = 11327,
        }
        self.spell.class.debuffs    = {        -- Debuffs Available To All Rogues
            sap                         = 6770,
        }
        self.spell.class.glyphs     = {        -- Glyphs Available To All Rogues
            glyphOfBlackout             = 219693,
            glyphOfBurnout              = 220279,
            glyphOfDisguise             = 63268,
            glyphOfFlashBang            = 219678,
        }
        self.spell.class.talents    = {        -- Talents Available To All Rogues
            alacrity                    = 193539,
            anticipation                = 114015,
            cheatDeath                  = 31230,
            deathFromAbove              = 152150,
            deeperStrategem             = 193531,
            elusiveness                 = 79008,
            markedForDeath              = 137619,
            preyOnTheWeak               = 131511,
            vigor                       = 14983,
        }

    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.classUpdateOOC()
            -- Call baseUpdateOOC()
            self.baseUpdateOOC()
            self.getClassArtifacts()
            self.getClassArtifactRanks()
            self.getClassGlyphs()
            self.getClassTalents()
            self.getClassPerks()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.classUpdate()
            -- Call baseUpdate()
            self.baseUpdate()
            self.getClassDynamicUnits()
            self.getClassBuffs()
            self.getClassCastable()
            self.getClassCharges()
            self.getClassCooldowns()
            self.getClassDebuffs()
            self.getClassToggleModes()
            

            -- Update Combo Points
            self.comboPoints    = UnitPower("player",4)
            self.comboPointsMax = UnitPowerMax("player",4)

            -- Update Energy Regeneration
            self.powerRegen     = getRegen("player")
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn10    = dynamicTarget(10,true) -- Sap
            self.units.dyn15    = dynamicTarget(15,true) -- Death From Above

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Entangling Roots
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getClassArtifacts()
            local hasPerk = hasPerk

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
            end
        end

        function self.getClassArtifactRanks()
            local getPerkRank = getPerkRank
            
            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact.rank[k] = getPerkRank(v) or 0
            end
        end

    -------------
    --- BUFFS ---
    -------------
    
        function self.getClassBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.spell.class.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------
        function self.getClassCharges()
            local getCharges = getCharges

            -- self.charges.survivalInstincts = getCharges(self.spell.survivalInstincts)
        end

    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getClassCooldowns()
            local getSpellCD = getSpellCD

            for k,v in pairs(self.spell.class.abilities) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    ---------------
    --- DEBUFFS ---
    ---------------

        function self.getClassDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.class.debuffs) do
                self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
                self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
            end
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getClassGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.cheetah           = hasGlyph(self.spell.glyphOfTheCheetah)
        end

    ----------------
    --- TALENTS ---
    ----------------

        function self.getClassTalents()
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.spell.class.talents) do
                        if v == talentID then
                            self.talent[k] = getTalent(r,c)
                        end
                    end
                end
            end
        end
            
    -------------
    --- PERKS ---
    -------------

        function self.getClassPerks()
            local isKnown = isKnown

            -- self.perk.enhancedRebirth = isKnown(self.spell.enhancedRebirth)
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getClassToggleModes()

            self.mode.rotation      = br.data["Rotation"]
            self.mode.cooldown      = br.data["Cooldown"]
            self.mode.defensive     = br.data["Defensive"]
            self.mode.interrupt     = br.data["Interrupt"]
            self.mode.cleave        = br.data["Cleave"]
            self.mode.pickPocket    = br.data["Picker"]
        end

        -- Create the toggle defined within rotation files
        function self.createClassToggles()
            GarbageButtons()
            if self.rotations[br.selectedProfile] ~= nil then
                self.rotations[br.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Rogue should have
        function self.createClassOptions()
            -- Class Wrap
            local section = br.ui:createSection(br.ui.window.profile,  "Class Options", "Nothing")
            br.ui:checkSectionState(section)
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getClassCastable()
            self.cast.debug.cheapShot       = self.cast.cheapShot("target",true)
            self.cast.debug.cloakOfShadows  = self.cast.cloakOfShadows("player",true)
            self.cast.debug.crimsonVial     = self.cast.crimsonVial("player",true)
            self.cast.debug.deathFromAbove  = self.cast.deathFromAbove("target",true)
            self.cast.debug.feint           = self.cast.feint("player",true)
            self.cast.debug.kick            = self.cast.kick("target",true)
            self.cast.debug.killingSpree    = self.cast.killingSpree("target",true)
            self.cast.debug.markedForDeath  = self.cast.markedForDeath("target",true)
            self.cast.debug.pickPocket      = self.cast.pickPocket("target",true)
            self.cast.debug.sap             = self.cast.sap("target",true)
            self.cast.debug.shadowmeld      = self.cast.shadowmeld("player",true)
            self.cast.debug.sprint          = self.cast.sprint("player",true)
            self.cast.debug.stealth         = self.cast.stealth("player",true)
            self.cast.debug.vanish          = self.cast.vanish("player",true)
        end

        function self.cast.cheapShot(thisUnit,debug)
            local spellCast = self.spell.cheapShot
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 29 and self.power > 40 and (self.buff.stealth or self.buff.vanish or self.buff.shadowmeld) and (self.cd.cheapShot == 0  or self.talent.dirtyTricks) and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.cloakOfShadows(thisUnit,debug)
            local spellCast = self.spell.cloakOfShadows
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 58 and self.cd.cloakOfShadows == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.crimsonVial(thisUnit,debug)
            local spellCast = self.spell.crimsonVial
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 14 and self.power > 30 and self.cd.crimsonVial == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.deathFromAbove(thisUnit,debug)
            local spellCast = self.spell.deathFromAbove
            local thisUnit = thisUnit
            local powerReq = powerReq 
            local fateRank = fateRank
            if thisUnit == nil then thisUnit = self.units.dyn15 end
            if debug == nil then debug = false end
            if self.artifact.rank.fatebringer == nil then fateRank = 0 else fateRank = self.artifact.rank.fatebringer * 3 end

            if self.talent.deathFromAbove and self.comboPoints > 0 and self.cd.deathFromAbove == 0 and self.power > 25 - fateRank and getDistance(thisUnit) < 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.feint(thisUnit,debug)
            local spellCast = self.spell.feint
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 44 and self.power > 20 and self.cd.feint == 0 and not self.buff.feint then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.kick(thisUnit,debug)
            local spellCast = self.spell.kick
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 18 and self.cd.kick == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        function self.cast.killingSpree(thisUnit,debug)
            local spellCast = self.spell.killingSpree
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.talent.killingSpree and self.cd.killingSpree == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        function self.cast.markedForDeath(thisUnit,debug)
            local spellCast = self.spell.markedForDeath
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.talent.markedForDeath and self.cd.markedForDeath == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        function self.cast.pickPocket(thisUnit,debug)
            local spellCast = self.spell.pickPocket
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 16 and self.cd.pickPocket == 0 and self.buff.stealth and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        function self.cast.sap(thisUnit,debug)
            local spellCast = self.spell.sap
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn10 end
            if debug == nil then debug = false end

            if self.level >= 12 and self.power > 30 and self.buff.stealth and self.cd.sap == 0 and getDistance(thisUnit) < 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        function self.cast.shadowmeld(thisUnit,debug)
            local spellCast = self.spell.shadowmeld
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 1 and self.cd.shadowmeld == 0 and not self.buff.stealth and not self.buff.vanish and not isMoving("player") then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.sprint(thisUnit,debug)
            local spellCast = self.spell.sprint
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 26 and self.cd.sprint == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.stealth(thisUnit,debug)
            local spellCast = self.spell.stealth
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 5 and self.cd.stealth == 0 and not self.buff.stealth then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false) 
                end
            elseif debug then
                return false
            end
        end
        function self.cast.vanish(thisUnit,debug)
            local spellCast = self.spell.vanish
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 32 and self.cd.vanish == 0 then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 2) or rotation == 2 then
                return true
            else
                return false
            end
        end

        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

        function useCleave()
            if self.mode.cleave == 1 and self.mode.rotation < 3 then
                return true
            else
                return false
            end
        end

        function usePickPocket()
            if self.mode.pickPocket == 1 or self.mode.pickPocket == 2 then
                return true
            else
                return false
            end
        end

        function isPicked(thisUnit)   --  Pick Pocket Testing
            if thisUnit == nil then thisUnit = "target" end
            if GetObjectExists(thisUnit) then
                if myTarget ~= UnitGUID(thisUnit) then
                    canPickpocket = true
                    myTarget = UnitGUID(thisUnit)
                end
            end
            if (canPickpocket == false or self.mode.pickPocket == 3 or GetNumLootItems()>0) and not isDummy() then
                return true
            else
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
        -- Return
        return self
    end --End function cRogue:new(spec)
end -- End Select 