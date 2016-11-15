--- Unholy Class
-- Inherit from: ../cCharacter.lua and ../cDeathKnight.lua
if select(2, UnitClass("player")) == "DEATHKNIGHT" then
	cUnholy = {}
    cUnholy.rotations = {}

	-- Creates Unholy DeathKnight
	function cUnholy:new()
		local self = cDeathKnight:new("Unholy")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cUnholy.rotations
		
		-----------------
        --- VARIABLES ---
        -----------------
        self.charges.frac       = {}        -- Fractional Charges
        self.trinket            = {}        -- Trinket Procs
        self.enemies            = {
            yards5,
            yards8,
            yards13,
            yards20,
            yards40,
        }
		self.unholyArtifacts     = {
           
        }
        self.unholyBuffs         = {
            
        }
        self.unholyDebuffs       = {
            
        }
        self.unholySpecials      = {
            
        }
        self.unholyTalents       = {
            
        }
        -- Merge all spell tables into self.spell
        self.unholySpells = {}
        self.unholySpells = mergeTables(self.unholySpells,self.unholyArtifacts)
        self.unholySpells = mergeTables(self.unholySpells,self.unholyBuffs)
        self.unholySpells = mergeTables(self.unholySpells,self.unholyDebuffs)
        self.unholySpells = mergeTables(self.unholySpells,self.unholySpecials)
        self.unholySpells = mergeTables(self.unholySpells,self.unholyTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.druidSpell, self.unholySpells)
		
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
            -- self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            -- self.unholy_bleed_table()
            self.getBuffs()
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
            self.getTrinketProc()
            self.hasTrinketProc()
            self.getEnemies()
            self.getRecharges()
            self.getToggleModes()
            self.getCastable()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end

            -- Start selected rotation
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8 = dynamicTarget(8, true) -- Swipe
            self.units.dyn13 = dynamicTarget(13, true) -- Skull Bash

            -- AoE
            self.units.dyn8AoE = dynamicTarget(8, false) -- Thrash
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local isKnown = isKnown

            --self.artifact.ashamanesBite     = isKnown(self.spell.ashamanesBite)
        end

        function self.getArtifactRanks()

        end
       
   	-------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
        	local UnitBuffID = UnitBuffID

        	-- self.buff.berserk                      = UnitBuffID("player",self.spell.berserkBuff)~=nil or false
        end

        function self.getBuffsDuration()
        	local getBuffDuration = getBuffDuration

        	-- self.buff.duration.berserk                     = getBuffDuration("player",self.spell.berserkBuff) or 0
        end

        function self.getBuffsRemain()
        	local getBuffRemain = getBuffRemain

        	-- self.buff.remain.berserk                    = getBuffRemain("player",self.spell.berserkBuff) or 0
        end

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

        end

        function self.hasTrinketProc()
            -- for i = 1, #self.trinket do
            --     if self.trinket[i]==true then return true else return false end
            -- end
        end

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
        	local UnitDebuffID = UnitDebuffID

        	-- self.debuff.ashamanesFrenzy   = UnitDebuffID(self.units.dyn5,self.spell.ashamanesFrenzyDebuff,"player")~=nil or false
		end

		function self.getDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

			-- self.debuff.duration.ashamanesFrenzy    = getDebuffDuration(self.units.dyn5,self.spell.ashamanesFrenzyDebuff,"player") or 0
		end

		function self.getDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

			-- self.debuff.remain.ashamanesFrenzy  = getDebuffRemain(self.units.dyn5,self.spell.ashamanesFrenzyDebuff,"player") or 0
		end

    ---------------
    --- CHARGES ---
    ---------------

		function self.getCharge()
			local getCharges = getCharges
            local getChargesFrac = getChargesFrac
			local getBuffStacks = getBuffStacks

			-- self.charges.unholytalons 	   = getBuffStacks("player",self.spell.unholytalonsBuff,"player")
		end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            -- self.cd.ashamanesFrenzy                 = getSpellCD(self.spell.ashamanesFrenzy)
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.catForm   		= hasGlyph(self.spell.catFormGlyph))
        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            -- self.talent.predator                    = getTalent(1,1)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
        	local isKnown = isKnown

        	-- self.perk.enhancedBerserk 		= isKnown(self.spell.enhancedBerserk)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5) -- Melee
            self.enemies.yards8 = #getEnemies("player", 8) -- Swipe/Thrash
            self.enemies.yards13 = #getEnemies("player", 13) -- Skull Bash
            self.enemies.yards20 = #getEnemies("player", 20) --Prowl
            self.enemies.yards40 = #getEnemies("player", 40) --Moonfire
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

        function self.getCastable()

            -- self.castable.maim              = self.castMaim("target",true)
        end

 

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
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

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cUnholy
end-- select DeathKnight