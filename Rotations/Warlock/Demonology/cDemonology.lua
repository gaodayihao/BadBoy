--- Demonology Class
-- Inherit from: ../cCharacter.lua and ../cWarlock.lua
cDemonology = {}
cDemonology.rotations = {}

-- Creates Demonology Warlock
function cDemonology:new()
    if GetSpecializationInfo(GetSpecialization()) == 266 then
        local self = cWarlock:new("Demonology")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cDemonology.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
    
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            callDreadstalkers           = 104316,
            commandDemon                = 119898,
            demonbolt                   = 157695,
            demonicEmpowerment          = 193396,
            demonwrath                  = 193440,
            doom                        = 603,
            Felstorm                    = 89751,
            grimoireFelguard            = 111898,
            handOfGuldan                = 105174,
            implosion                   = 196277,
            shadowbolt                  = 686,
            shadowflame                 = 205181,
            summonDarkglare             = 205180,
            summonFelguard              = 30146,
            thalkielsConsumption        = 211714,
        }
        self.spell.spec.artifacts       = {
            thalkielsConsumption        = 211714,
        }
        self.spell.spec.buffs           = {
            demonicCalling              = 205146,
            demonicEmpowerment          = 193396,
            demonwrath                  = 193440,
        }
        self.spell.spec.debuffs         = {
            doom                        = 603,
            shadowflame                 = 205181,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            demonbolt                   = 157695,
            grimoireOfService           = 108501,
            grimoireOfSupremacy         = 152107,
            grimoireOfSynergy           = 171975,
            handOfDoom                  = 196283,
            implosion                   = 196277,
            shadowflame                 = 205181,
            summonDarkglare             = 205180,
        }
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)

        self.petType                   = {
            darkglare                   = 103673,
            doomguard                   = 11859,
            dreadStalkers               = 98035,
            felguard                    = 17252,
            felhunter                   = 417,
            Imp                         = 416,
            infernal                    = 89,
            succubus                    = 1863,
            voidwalker                  = 1860,
            wildImp                     = 55659,
        }
        
        self.petVaild                   ={
            [103673]                    = true,     -- darkglare
            [11859]                     = true,     -- doomguard
            [98035]                     = true,     -- dreadStalkers
            [17252]                     = true,     -- felguard
            [417]                       = true,     -- felhunter
            [416]                       = true,     -- Imp
            [89]                        = true,     -- infernal
            [1863]                      = true,     -- succubus
            [1860]                      = true,     -- voidwalker
            [55659]                     = true,     -- wildImp
        }
        
        self.petDuration                ={
            [103673]                    = 12,     -- darkglare
            [11859]                     = 25,     -- doomguard
            [98035]                     = 12,     -- dreadStalkers
            [17252]                     = -1,     -- felguard
            [417]                       = -1,     -- felhunter
            [416]                       = -1,     -- Imp
            [89]                        = 25,     -- infernal
            [1863]                      = -1,     -- succubus
            [1860]                      = -1,     -- voidwalker
            [55659]                     = 12,     -- wildImp
        }

        self.petStartTime           = {}
    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            cFileBuild("spec",self)
            self:initSpell()
            self.getToggleModes()
            if br.timer:useTimer("GetPetInfo",1/5) then self.getPetInfo() end

            -- Start selected rotation
            self:startRotation()
        end

    ----------------
    --- PET INFO ---
    ----------------
        function self.getPetInfo()
            self.petInfo            = {}
            self.petPool            = {
                count               = {
                    wildImp         = 0,
                },
                remain              = {
                    wildImp         = 999,
                    dreadStalkers   = 999,
                },
                noDEcount           ={
                    wildImp         = 0,
                    others          = 0,
                },
                useFelstorm         = false,
                demonwrathPet       = false,
            }
            for i = 1, ObjectCount() do
                -- define our unit
                --local thisUnit = GetObjectIndex(i)
                local thisUnit = GetObjectWithIndex(i)
                -- check if it a unit first
                if ObjectIsType(thisUnit, ObjectTypes.Unit) then
                    local unitID        = GetObjectID(thisUnit)
                    local unitCreator   = UnitCreator(thisUnit)
                    local player        = GetObjectWithGUID(UnitGUID("player"))
                    if unitCreator == player and (self.petVaild[unitID] or false) then
                    --------------------
                    -- build Pet Info --
                    --------------------
                        --local unitName      = UnitName(thisUnit)
                        local unitGUID      = UnitGUID(thisUnit)
                        local demoEmpBuff   = UnitBuffID(thisUnit,self.spell.spec.buffs.demonicEmpowerment) ~= nil
                        --local unitCount     = #getEnemies(tostring(thisUnit),10) or 0
                        
                        local pet = {
                                        name = "-", 
                                        guid = unitGUID, 
                                        id = unitID, 
                                        creator = unitCreator, 
                                        deBuff = demoEmpBuff, 
                                        numEnemies = 0,
                                        duration = self.petDuration[unitID] or -1,
                                        remain = 999,
                                    }
                        if self.talent.grimoireOfSupremacy and (unitID == self.petType.doomguard or unitID == self.petType.infernal) then
                            pet.duration = -1
                        end

                        if pet.duration > 0 then
                            if self.petStartTime[pet.guid] == nil then
                                self.petStartTime[pet.guid] = GetTime()
                                pet.remain = pet.duration
                            else
                                pet.remain = pet.duration - (GetTime() - self.petStartTime[pet.guid])
                                if pet.remain < 0 then pet.remain = 0 end
                            end
                        end

                    --------------------
                    -- build Pet Pool --
                    --------------------
                        if pet.id == self.petType.wildImp then
                            self.petPool.count.wildImp = self.petPool.count.wildImp + 1
                            self.petPool.remain.wildImp = math.min(self.petPool.remain.wildImp,pet.remain)
                            if not pet.deBuff then self.petPool.noDEcount.wildImp = self.petPool.noDEcount.wildImp + 1 end
                        elseif pet.id == self.petType.dreadStalkers then
                            self.petPool.remain.dreadStalkers = math.min(self.petPool.remain.dreadStalkers,pet.remain)
                            if not pet.deBuff then self.petPool.noDEcount.others = self.petPool.noDEcount.others + 1 end
                        else
                            if not pet.deBuff then self.petPool.noDEcount.others = self.petPool.noDEcount.others + 1 end
                        end

                        if not self.petPool.useFelstorm and pet.id == self.petType.felguard and (#getEnemies(tostring(thisUnit),10) or 0) > 0 then
                            self.petPool.useFelstorm = true
                        end
                        
                        if not self.petPool.demonwrathPet and (#getEnemies(tostring(thisUnit),10) or 0) >= 3 then
                            self.petPool.demonwrathPet = true
                        end

                        tinsert(self.petInfo,pet)
                    end -- End If
                end -- End If
            end -- End for

            -- Clear up the pool
            if br.timer:useTimer("ClearPetStartTime",5) then
                local tempPool = {}
                for i = 1,#self.petInfo do
                    local pet = self.petInfo[i]
                    if pet.duration > 0 then
                        tempPool[self.petInfo[i].guid] = self.petStartTime[self.petInfo[i].guid]
                    end
                end
                self.petStartTime = tempPool
            end
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.rotation  = br.data["Rotation"]
            self.mode.cooldown  = br.data["Cooldown"]
            self.mode.defensive = br.data["Defensive"]
            self.mode.interrupt = br.data["Interrupt"]
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
        function self.initSpell()
            -- summonDarkglare
            self.cast.summonDarkglare = function(thisUnit,debug)
                local spellCast = self.spell.summonDarkglare
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonDarkglare == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,false)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonDoomguard
            self.cast.summonDoomguard = function(thisUnit,debug)
                local spellCast = self.spell.summonDoomguard
                local thisUnit = thisUnit
                local moveCheck = true
                if thisUnit == nil then
                    if self.talent.grimoireOfSupremacy then
                        thisUnit = "player"
                        moveCheck = true
                    else
                        thisUnit = "target"
                        moveCheck = false
                    end
                end
                if debug == nil then debug = false end

                if self.cd.summonDoomguard == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,moveCheck,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,moveCheck)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonFelguard
            self.cast.summonFelguard = function(thisUnit,debug)
                local spellCast = self.spell.summonFelguard
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonFelguard == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,true)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonFelhunter
            self.cast.summonFelhunter = function(thisUnit,debug)
                local spellCast = self.spell.summonFelhunter
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonFelhunter == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,true)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonFelImp
            self.cast.summonFelImp = function(thisUnit,debug)
                local spellCast = self.spell.summonFelImp
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonFelImp == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,true)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonImp
            self.cast.summonImp = function(thisUnit,debug)
                local spellCast = self.spell.summonImp
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonImp == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,true)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonInfernal
            self.cast.summonInfernal = function(thisUnit,debug)
                local spellCast = self.spell.summonInfernal
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonInfernal == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    elseif self.talent.grimoireOfSupremacy then
                        return castSpell(thisUnit,spellCast,false,true)
                    else
                        return castGroundAtBestLocation(spellCast,10,1,30)
                    end 
                elseif debug then
                    return false
                end
            end

            -- summonSuccubus
            self.cast.summonSuccubus = function(thisUnit,debug)
                local spellCast = self.spell.summonSuccubus
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonSuccubus == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,true)
                    end
                elseif debug then
                    return false
                end
            end

            -- summonVoidwalker
            self.cast.summonVoidwalker = function(thisUnit,debug)
                local spellCast = self.spell.summonVoidwalker
                local thisUnit = thisUnit
                if thisUnit == nil then thisUnit = "player" end
                if debug == nil then debug = false end

                if self.cd.summonVoidwalker == 0 and self.soulShards >= 1 then
                    if debug then
                        return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                    else
                        return castSpell(thisUnit,spellCast,false,true)
                    end
                elseif debug then
                    return false
                end
            end
        end
    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        --Target HP
        function thp(unit)
            return getHP(unit)
        end

        --Target Time to Die
        function ttd(unit)
            return getTimeToDie(unit)
        end

        --Target Distance
        function tarDist(unit)
            return getDistance(unit)
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cDemonology
end-- select Warlock