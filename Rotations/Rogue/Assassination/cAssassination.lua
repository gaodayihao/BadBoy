--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cRogue.lua
cAssassination = {}
cAssassination.rotations = {}

-- Creates Assassination Rogue
function cAssassination:new()
    if GetSpecializationInfo(GetSpecialization()) == 259 then
        local self = cRogue:new("Assassination")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cAssassination.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.custom                 = {}
        self.spell.spec             = {}
        self.spell.spec.abilities   = {
            agonizingPoison         = 200802,
            assassinsResolve        = 84601,
            cripplingPoison         = 3408,
            cutToTheChase           = 51667,
            deadlyPoison            = 2823,
            envenom                 = 32645,
            evasion                 = 5277,
            exsanguinate            = 200806,
            fanOfKnives             = 51723,
            garrote                 = 703,
            hemorrhage              = 16511,
            improvedPoisons         = 14117,
            kidneyShot              = 408,
            kingsbane               = 192759, --222062
            leechingPoison          = 108211,
            masteryPotentPoisons    = 76803,
            mutilate                = 1329,
            poisonedKnife           = 185565,
            rupture                 = 1943,
            sealFate                = 14190,
            shadowstep              = 36554,
            vendetta                = 79140,
            venomousWounds          = 79134,
            woundPoison             = 8679,
        }
        self.spell.spec.artifacts   = {
            assassinsBlades         = 214368,
            bagOfTricks             = 192657,
            balancedBlades          = 192326,
            bloodOfTheAssassinated  = 192923,
            fadeIntoShadows         = 192323,
            fromTheShadows          = 192428,
            gushingWound            = 192329,
            kingsbane               = 192759,
            masterAlchemist         = 192318,
            masterAssassin          = 192349,
            poisonKnives            = 192376,
            serratedEdge            = 192315,
            shadowSwiftness         = 192422,
            shadowWalker            = 192345,
            slayersPrecision        = 214928,
            surgeOfToxins           = 192424,
            toxicBlades             = 192310,
            urgeToKill              = 192384,
        }
        self.spell.spec.buffs       = {
            agonizingPoison         = 200802,
            cripplingPoison         = 3408,
            deadlyPoison            = 2823,
            elaboratePlanning       = 193641,
            envenom                 = 32645,
            leechingPoison          = 108211,
            theDreadlordsDeceit     = 208692,
            woundPoison             = 8679,
        }
        self.spell.spec.debuffs     = {
            agonizingPoison         = 200803,
            cripplingPoison         = 3409,
            deadlyPoison            = 2818,
            garrote                 = 703,
            hemorrhage              = 16511,
            internalBleeding        = 154953,
            rupture                 = 1943,
            vendetta                = 79140,
            woundPoison             = 8680,
        }
        self.spell.spec.talents     = {
            agonizingPoison         = 200802,
            elaboratePlanning       = 193640,
            exsanguinate            = 200806,
            hemorrhage              = 16511,
            internalBleeding        = 154904,
            leechingPoison          = 108211,
            masterPoisoner          = 196864,
            nightstalker            = 14062,
            shadowFocus             = 108209,
            subterfuge              = 108208,
            thuggee                 = 196861,
            venomRush               = 152152,
        }
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)
        
    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
            self.getArtifacts()
            self.getArtifactRanks()
            self.getGlyphs()
            self.getTalents()
            self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getBuffs()
            self.getCastable()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getEnemies()
            self.getRecharges()
            self.getToggleModes()
            self.getCastable()

            -- Start selected rotation
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn25 = dynamicTarget(25, true) -- Shadowstep
            self.units.dyn30 = dynamicTarget(30, true) -- Poisoned Knife

            -- AoE
            self.units.dyn8AoE = dynamicTarget(8, false)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8     = getEnemies("player", 8) -- Fan of Knives
            self.enemies.yards10    = getEnemies("player", 10)
            self.enemies.yards20    = getEnemies("player", 20) -- Interrupts
            self.enemies.yards30    = getEnemies("player", 30) -- Poisoned Knife
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local isKnown = isKnown

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = isKnown(v) or false
            end
        end

        function self.getArtifactRanks()

        end
       
    -------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.spell.spec.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
                self.buff.refresh[k]    = (self.buff.remain[k] < self.buff.duration[k] * 0.3) or self.buff.remain[k] == 0
                self.buff.stack[k]      = getBuffStacks("player",v,"player") or 0
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

        function self.getCharge()
            local getCharges = getCharges
            local getChargesFrac = getChargesFrac
            local getBuffStacks = getBuffStacks

            -- self.charges.assassinationtalons        = getBuffStacks("player",self.spell.assassinationtalonsBuff,"player")
        end

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.spec.debuffs) do
                self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
                self.debuff.refresh[k]  = (self.debuff.remain[k] < self.debuff.duration[k] * 0.3) or self.debuff.remain[k] == 0
            end
        end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            for k,v in pairs(self.spell.spec.abilities) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.catForm           = hasGlyph(self.spell.catFormGlyph))
        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.spell.spec.talents) do
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

        function self.getPerks()
            local isKnown = isKnown

            -- self.perk.enhancedBerserk        = isKnown(self.spell.enhancedBerserk)
        end

    -----------------
    --- RECHARGES ---
    -----------------
    
        function self.getRecharges()
            local getRecharge = getRecharge

            -- self.recharge.forceOfNature = getRecharge(self.spell.forceOfNature)
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
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
        
        -- Creates the option/profile window
        function self.createOptions()
            br.ui.window.profile = br.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            br.ui:createRotationDropdown(br.ui.window.profile.parent, names)

            -- Create Base and Class option table
            local optionTable = {
                {
                    [1] = "Base Options",
                    [2] = self.createBaseOptions,
                },
                {
                    [1] = "Class Options",
                    [2] = self.createClassOptions,
                },
            }

            -- Get profile defined options
            local profileTable = profileTable
            if self.rotations[br.selectedProfile] ~= nil then 
                profileTable = self.rotations[br.selectedProfile].options()
            else
                return
            end

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            br.ui:createPagesDropdown(br.ui.window.profile, optionTable)
            br:checkProfileWindowStatus()
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getCastable()

            self.cast.debug.agonizingPoison   = self.cast.agonizingPoison("player",true)
            self.cast.debug.cripplingPoison   = self.cast.cripplingPoison("player",true)
            self.cast.debug.deadlyPoison      = self.cast.deadlyPoison("player",true)
            self.cast.debug.envenom           = self.cast.envenom("target",true)
            self.cast.debug.evasion           = self.cast.evasion("player",true)
            self.cast.debug.exsanguinate      = self.cast.exsanguinate("player",true)
            self.cast.debug.fanOfKnives       = self.cast.fanOfKnives("player",true)
            self.cast.debug.garrote           = self.cast.garrote("target",true)
            self.cast.debug.hemorrhage        = self.cast.hemorrhage("target",true)
            self.cast.debug.kidneyShot        = self.cast.kidneyShot("target",true)
            self.cast.debug.kingsbane         = self.cast.kingsbane("target",true)
            self.cast.debug.leechingPoison    = self.cast.leechingPoison("player",true)
            self.cast.debug.mutilate          = self.cast.mutilate("target",true)
            self.cast.debug.poisonKnive       = self.cast.poisonedKnife("target",true)
            self.cast.debug.rupture           = self.cast.rupture("target",true)
            self.cast.debug.shadowstep        = self.cast.shadowstep("target",true)
            self.cast.debug.vendetta          = self.cast.vendetta("target",true)
            self.cast.debug.woundPoison       = self.cast.woundPoison("player",true)
        end

        function self.cast.agonizingPoison(thisUnit,debug)
            local spellCast = self.spell.agonizingPoison
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.agonizingPoison and self.buff.remain.agonizingPoison < 600 and self.cd.agonizingPoison == 0 and not isCastingSpell(spellCast,thisUnit) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.cripplingPoison(thisUnit,debug)
            local spellCast = self.spell.cripplingPoison
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 19 and self.buff.remain.cripplingPoison < 600 and self.cd.cripplingPoison == 0 and not isCastingSpell(spellCast,thisUnit) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.deadlyPoison(thisUnit,debug)
            local spellCast = self.spell.deadlyPoison
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 2 and self.buff.remain.deadlyPoison < 600 and self.cd.deadlyPoison == 0 and not isCastingSpell(spellCast,thisUnit) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            end
        end
        function self.cast.envenom(thisUnit,debug)
            local spellCast = self.spell.envenom
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 3 and self.power > 35 and self.comboPoints > 0 and self.cd.envenom == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.evasion(thisUnit,debug)
            local spellCast = self.spell.evasion
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 8 and self.cd.evasion == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.exsanguinate(thisUnit,debug)
            local spellCast = self.spell.exsanguinate
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.talent.exsanguinate and self.cd.exsanguinate == 0 and (self.debuff.rupture or self.debuff.garrote or self.debuff.internalBleeding) and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.fanOfKnives(thisUnit,debug)
            local spellCast = self.spell.fanOfKnives
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 66 and self.power > 35 and self.cd.fanOfKnives == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.garrote(thisUnit,debug)
            local spellCast = self.spell.garrote
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 48 and self.cd.garrote == 0 and self.power > 45 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.hemorrhage(thisUnit,debug)
            local spellCast = self.spell.hemorrhage
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.talent.hemorrhage and self.power > 30 and self.cd.hemorrhage == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.kidneyShot(thisUnit,debug)
            local spellCast = self.spell.kidneyShot
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 40 and self.power > 25 and self.comboPoints > 0 and self.cd.kidneyShot == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.kingsbane(thisUnit,debug)
            local spellCast = self.spell.kingsbane
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.artifact.kingsbane and self.power > 35 and self.cd.kingsbane == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.leechingPoison(thisUnit,debug)
            local spellCast = self.spell.leechingPoison
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.leechingPoison and self.buff.remain.leechingPoison < 600 and self.cd.leechingPoison == 0 and not isCastingSpell(spellCast,thisUnit) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.mutilate(thisUnit,debug)
            local spellCast = self.spell.mutilate
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 1 and self.power > 55 and self.cd.mutilate == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.poisonedKnife(thisUnit,debug)
            local spellCast = self.spell.poisonedKnife
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 10 and self.power > 40 and self.cd.poisonedKnife == 0 and getDistance(thisUnit) < 30 and getDistance(thisUnit) > 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.rupture(thisUnit,debug)
            local spellCast = self.spell.rupture
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 22 and self.power > 25 and self.comboPoints > 0 and self.cd.rupture == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.shadowstep(thisUnit,debug)
            local spellCast = self.spell.shadowstep
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 13 and self.cd.shadowstep == 0 and getDistance(thisUnit) < 25 and getDistance(thisUnit) >= 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.vendetta(thisUnit,debug)
            local spellCast = self.spell.vendetta
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 72 and self.cd.vendetta == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        function self.cast.woundPoison(thisUnit,debug)
            local spellCast = self.spell.woundPoison
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 25 and self.buff.remain.woundPoison < 600 and self.cd.woundPoison == 0 and not isCastingSpell(spellCast,thisUnit) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cAssassination
end-- select Rogue