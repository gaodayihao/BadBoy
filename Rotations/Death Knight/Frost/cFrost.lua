--- Frost Class
-- Inherit from: ../cCharacter.lua and ../cDeathKnight.lua
cFrost = {}
cFrost.rotations = {}

-- Creates Frost Death Knight
function cFrost:new()
    if GetSpecializationInfo(GetSpecialization()) == 251 then
        local self = cDeathKnight:new("Frost")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFrost.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            blindingSleet               = 207167,
            breathOfSindragosa          = 152279,
            chainsOfIce                 = 45524,
            empowerRuneWeapon           = 47568,
            frostscythe                 = 207230,
            frostStrike                 = 49143,
            glacialAdvance              = 194913,
            hornOfWinter                = 57330,
            howlingBlast                = 49184,
            hungeringRuneWeapon         = 207127,
            obliterate                  = 49020,
            obliteration                = 207256,
            pillarOfFrost               = 51271,
            remorselessWinter           = 196770,
        }
        self.spell.spec.artifacts       = {
            sindragosasFury             = 190778,
        }
        self.spell.spec.buffs           = {
            breathOfSindragosa          = 152279,
            icyTalons                   = 194879,
            killingMachine              = 51128,
            obliteration                = 207256,
            pillarOfFrost               = 51271,
            rime                        = 59052,
        }
        self.spell.spec.debuffs         = {
            chainsOfIce                 = 45524,
            frostFever                  = 55095,
            razorice                    = 51714,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            abominationsMight           = 207161,
            avalanche                   = 207142,
            blindingSleet               = 207167,
            breathOfSindragosa          = 152279,
            freezingFog                 = 207060,
            frostscythe                 = 207230,
            frozenPulse                 = 194909,
            gatheringStorm              = 194912,
            glacialAdvance              = 194913,
            hornOfWinter                = 57330,
            hungeringRuneWeapon         = 207127,
            icecap                      = 207126,
            icyTalons                   = 194878,
            murderousEfficiency         = 207061,
            obliteration                = 207256,
            permafrost                  = 207200,
            runicAttenuation            = 207104,
            shatteringStrikes           = 207057,
            volatileShielding           = 207188,
            whiteWalker                 = 212765,
            winterIsComing              = 207170,
        }
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)
        
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
            self.getToggleModes()
            
            -- Start selected rotation
            self:startRotation()
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

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------


    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cFrost
end-- select Death Knight