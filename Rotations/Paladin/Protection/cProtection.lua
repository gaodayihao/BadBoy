--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cPaladin.lua
cPalProtection = {}
cPalProtection.rotations = {}

-- Creates Protection Paladin
function cPalProtection:new()
    if GetSpecializationInfo(GetSpecialization()) == 66 then
        local self = cPaladin:new("Protection")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cPalProtection.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            aegisOfLight                = 204150,
            ardentDefender              = 31850,
            avengersShield              = 31935,
            bastionOfLight              = 204035,
            blessedHammer               = 204019,
            consecration                = 26573,
            divineShield                = 190784,
            eyeOfTyr                    = 209202,
            guardianOfAncientKings      = 86659,
            hammerOfTheRighteous        = 53595,
            handOfTheProtector          = 213652,
            lightOfTheProtector         = 184092,
            seraphim                    = 152262,
            shieldOfTheRighteous        = 53600,
        }
        self.spell.spec.artifacts       = {
            -- eyeOfTyr                    = 209202,
        }
        self.spell.spec.buffs           = {
            seraphim                    = 152262,
            aegisOfLight                = 204150,
            ardentDefender              = 31850,
            guardianOfAncientKings      = 86659,
            shieldOfTheRighteous        = 132403,
        }
        self.spell.spec.debuffs         = {
            eyeOfTyr                    = 209202,
        }
        self.spell.spec.glyphs          = {
            glyphOfWingedVengeance      = 57979,
        }
        self.spell.spec.talents         = {
            bastionOfLight              = 204035,
            blessedHammer               = 204019,
            crusadersJudgment           = 204023,
            handOfTheProtector          = 213652,
            knightTemplar               = 204139,
            lightOfTheProtector         = 184092,
            seraphim                    = 152262,
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
                -- {
                --     [1] = "Class Options",
                --     [2] = self.createClassOptions,
                -- },
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
    end-- cPalProtection
end-- select Paladin