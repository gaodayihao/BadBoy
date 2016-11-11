-- Inherit from: ../cCharacter.lua
-- All Death Knight specs inherit from this file
if select(2, UnitClass("player")) == "DEATHKNIGHT" then
cDeathKnight = {}

-- Creates Death Knight with given specialisation
function cDeathKnight:new(spec)
	local self = cCharacter:new("Death Knight")

	local player = "player" -- if someone forgets ""

	self.profile         = spec
 --    self.powerRegen      = getRegen("player")
	-- self.buff.duration	 = {}		-- Buff Durations
	-- self.buff.remain 	 = {}		-- Buff Time Remaining
	-- self.debuff.duration = {}		-- Debuff Durations
	-- self.debuff.remain 	 = {}		-- Debuff Time Remaining
	-- self.disease		 = {}		-- Disease Info
	-- self.disease.min 	 = {} 		-- Disease with lowest duration
	-- self.disease.max 	 = {}		-- Disease with longest duration
	-- self.rune 			 = {}		-- Rune Info
	-- self.rune.count		 = {} 		-- Rune Count
	-- self.rune.percent 	 = {}		-- Rune Percent
	self.spell.class 					= {}
	self.spell.class.abilities      	= {
			antimagicShell 				= 48707,
			controlUndead 				= 111673,
			corpseExplosion 			= 127344,
			darkCommand 				= 56222,
			deathGate 					= 50977,
			deathGrip 					= 49576,
			deathStrike 				= 49998,
			frostBreath 				= 190780,
			mindFreeze 					= 47528,
			pathOfFrost 				= 3714,
			raiseAlly 					= 61999,
			wraithWalk 					= 212552,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina 			= 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class
        	pathOfFrost 				= 3714,
        	wraithWalk 					= 212552
        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class
        	bloodPlague 				= 55078,
        	controlUndead 				= 111673,
        	darkCommand 				= 56222,
        	frostBreath 				= 190780,
        	frostFever 					= 55095,
        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class
 
        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class

        }

-- Update OOC
	function self.classUpdateOOC()
		-- Call baseUpdateOOC()
		self.baseUpdateOOC()
	end

-- Update 
	function self.classUpdate()
		-- Call baseUpdate()
		self.baseUpdate()
		cFileBuild("class",self)
	end

-- -- Dynamic Units updates
-- 	function self.getClassDynamicUnits()
-- 		local dynamicTarget = dynamicTarget

-- 		self.units.dyn8AoE 	= dynamicTarget(8, false)
-- 		self.units.dyn10 	= dynamicTarget(10, true)
-- 		self.units.dyn10AoE = dynamicTarget(10, false)
-- 		self.units.dyn12 	= dynamicTarget(12, true)
-- 		self.units.dyn15 	= dynamicTarget(15, true)
-- 		self.units.dyn20AoE = dynamicTarget(20, false)
-- 	end

-- -- Buff updates
-- 	function self.getClassBuffs()
-- 		local UnitBuffID = UnitBuffID

-- 		self.buff.bloodPresence 		= UnitBuffID("player",self.spell.bloodPresenceBuff)~=nil or false
-- 		self.buff.breathOfSindragosa 	= UnitBuffID("player",self.spell.breathOfSindragosaBuff)~=nil or false
-- 		-- self.buff.deathStrike 			= UnitBuffID("player",self.spell.deathStrikeBuff)~=nil or false
-- 		self.buff.frostPresence 		= UnitBuffID("player",self.spell.frostPresenceBuff)~=nil or false 
-- 		self.buff.hornOfWinter 			= UnitBuffID("player",self.spell.hornOfWinterBuff)~=nil or false
-- 		self.buff.iceboundFortitude 	= UnitBuffID("player",self.spell.iceboundFortitudeBuff)~=nil or false
-- 		self.buff.pathOfFrost 			= UnitBuffID("player",self.spell.pathOfFrostBuff)~=nil or false
-- 		self.buff.unholyPresence 		= UnitBuffID("player",self.spell.unholyPresenceBuff)~=nil or false
-- 	end	

-- 	function self.getClassBuffsDuration()
-- 		local getBuffDuration = getBuffDuration

-- 		self.buff.duration.breathOfSindragosa 	= getBuffDuration("player",self.spell.breathOfSindragosaBuff) or 0
-- 		-- self.buff.duration.deathStrike 			= getBuffDuration("player",self.spell.deathStrikeBuff) or 0
-- 		self.buff.duration.hornOfWinter 		= getBuffDuration("player",self.spell.hornOfWinterBuff) or 0
-- 		self.buff.duration.iceboundFortitude 	= getBuffDuration("player",self.spell.iceboundFortitudeBuff) or 0
-- 	end

-- 	function self.getClassBuffsRemain()
-- 		local getBuffRemain = getBuffRemain

-- 		self.buff.remain.breathOfSindragosa = getBuffRemain("player",self.spell.breathOfSindragosaBuff) or 0
-- 		-- self.buff.remain.deathStrike 		= getBuffRemain("player",self.spell.deathStrikeBuff) or 0
-- 		self.buff.remain.hornOfWinter 		= getBuffRemain("player",self.spell.hornOfWinterBuff) or 0
-- 		self.buff.remain.iceboundFortitude 	= getBuffRemain("player",self.spell.iceboundFortitudeBuff) or 0
-- 	end

-- 	function self.getClassCharges()
-- 		local getBuffStacks 	= getBuffStacks
-- 		local getDebuffStacks 	= getDebuffStacks

-- 		self.charges.bloodTap 		= getBuffStacks("player",self.spell.bloodCharge,"player")
-- 		self.charges.necroticPlague = getDebuffStacks(self.units.dyn30,self.spell.necroticPlagueDebuff,"player")
-- 	end

-- -- Cooldown updates
-- 	function self.getClassCooldowns()
-- 		local getSpellCD = getSpellCD

-- 		self.cd.antiMagicShell 		= getSpellCD(self.spell.antiMagicShell)
-- 		self.cd.antiMagicZone 		= getSpellCD(self.spell.antiMagicZone)
-- 		self.cd.armyOfTheDead 		= getSpellCD(self.spell.armyOfTheDead)
-- 		self.cd.asphyxiate 			= getSpellCD(self.spell.asphyxiate)
-- 		self.cd.breathOfSindragosa 	= getSpellCD(self.spell.breathOfSindragosa)
-- 		self.cd.darkSimulacrum 		= getSpellCD(self.spell.darkSimulacrum)
-- 		self.cd.deathsAdvance 		= getSpellCD(self.spell.deathsAdvance)
-- 		self.cd.deathAndDecay 		= getSpellCD(self.spell.deathAndDecay)
-- 		self.cd.deathGrip 			= getSpellCD(self.spell.deathGrip)
-- 		self.cd.deathPact			= getSpellCD(self.spell.deathPact)
-- 		self.cd.defile 				= getSpellCD(self.spell.defile)
-- 		self.cd.desecratedGround 	= getSpellCD(self.spell.desecratedGround)
-- 		self.cd.empowerRuneWeapon 	= getSpellCD(self.spell.empowerRuneWeapon)
-- 		self.cd.gorefiendsGrasp 	= getSpellCD(self.spell.gorefiendsGrasp)
-- 		self.cd.iceboundFortitude 	= getSpellCD(self.spell.iceboundFortitude)
-- 		self.cd.lichborne 			= getSpellCD(self.spell.lichborne)
-- 		self.cd.mindFreeze 			= getSpellCD(self.spell.mindFreeze)
-- 		self.cd.outbreak 			= getSpellCD(self.spell.outbreak)
-- 		self.cd.plagueLeech 		= getSpellCD(self.spell.plagueLeech)
-- 		self.cd.raiseAlly 			= getSpellCD(self.spell.raiseAlly)
-- 		self.cd.remorselessWinter 	= getSpellCD(self.spell.remorselessWinter)
-- 		self.cd.strangulate 		= getSpellCD(self.spell.strangulate)
-- 		self.cd.unholyBlight 		= getSpellCD(self.spell.unholyBlight)
-- 	end

-- -- Debuff updates
-- 	function self.getClassDebuffs()
-- 		local UnitDebuffID = UnitDebuffID

-- 		self.debuff.bloodPlague 		= UnitDebuffID(self.units.dyn5,self.spell.bloodPlagueDebuff,"player")~=nil or false
-- 		self.debuff.chainsOfIce 		= UnitDebuffID(self.units.dyn30AoE,self.spell.chainsOfIceDebuff,"player")~=nil or false
-- 		self.debuff.defile 				= UnitDebuffID(self.units.dyn30AoE,self.spell.defileDebuff,"player")~=nil or false
-- 		self.debuff.frostFever 			= UnitDebuffID(self.units.dyn5,self.spell.frostFeverDebuff,"player")~=nil or false
-- 		self.debuff.necroticPlague 		= UnitDebuffID(self.units.dyn5,self.spell.necroticPlagueDebuff,"player")~=nil or false
-- 	end

-- 	function self.getClassDebuffsDuration()
-- 		local getDebuffDuration = getDebuffDuration

-- 		self.debuff.duration.bloodPlague 		= getDebuffDuration(self.units.dyn5,self.spell.bloodPlagueDebuff,"player") or 0
-- 		self.debuff.duration.chainsOfIce 		= getDebuffDuration(self.units.dyn30AoE,self.spell.chainsOfIceDebuff,"player") or 0
-- 		self.debuff.duration.defile 			= getDebuffDuration(self.units.dyn30AoE,self.spell.defileDebuff,"player") or 0
-- 		self.debuff.duration.frostFever 		= getDebuffDuration(self.units.dyn5,self.spell.frostFeverDebuff,"player") or 0
-- 		self.debuff.duration.necroticPlague 	= getDebuffDuration(self.units.dyn5,self.spell.necroticPlagueDebuff,"player") or 0
-- 	end

-- 	function self.getClassDebuffsRemain()
-- 		local getDebuffRemain = getDebuffRemain

-- 		self.debuff.remain.bloodPlague 			= getDebuffRemain(self.units.dyn5,self.spell.bloodPlagueDebuff,"player") or 0
-- 		self.debuff.remain.chainsOfIce 			= getDebuffRemain(self.units.dyn30AoE,self.spell.chainsOfIceDebuff,"player") or 0
-- 		self.debuff.remain.defile 				= getDebuffRemain(self.units.dyn30AoE,self.spell.defileDebuff,"player") or 0
-- 		self.debuff.remain.frostFever 			= getDebuffRemain(self.units.dyn5,self.spell.frostFeverDebuff,"player") or 0
-- 		self.debuff.remain.necroticPlague 		= getDebuffRemain(self.units.dyn5,self.spell.necroticPlagueDebuff,"player") or 0
-- 	end

-- -- Glyph updates
-- 	function self.getClassGlyphs()
-- 		local hasGlyph = hasGlyph

-- 		self.glyph.shiftingPresences = hasGlyph(self.spell.shiftingPresencesGlyph)
-- 	end

-- -- Talent updates
-- 	function self.getClassTalents()
-- 		local getTalent = getTalent

-- 		self.talent.plagueLeech 		= getTalent(1,2)
-- 		self.talent.unholyBlight 		= getTalent(1,3)
-- 		self.talent.lichborne 			= getTalent(2,1)
-- 		self.talent.antiMagicZone 		= getTalent(2,2)
-- 		self.talent.deathsAdvance 		= getTalent(3,1)
-- 		self.talent.asphyxiate 			= getTalent(3,3)
-- 		self.talent.bloodTap 			= getTalent(4,1)
-- 		self.talent.runicEmpowerment 	= getTalent(4,2)
-- 		self.talent.deathPact 			= getTalent(5,1)
-- 		self.talent.deathSiphon 		= getTalent(5,2)
-- 		self.talent.conversion 			= getTalent(5,3)
-- 		self.talent.gorefiendsGrasp 	= getTalent(6,1)
-- 		self.talent.remorselessWinter 	= getTalent(6,2)
-- 		self.talent.desecratedGround 	= getTalent(6,3)
-- 		self.talent.necroticPlague 		= getTalent(7,1)
-- 		self.talent.defile 				= getTalent(7,2)
-- 		self.talent.breathOfSindragosa 	= getTalent(7,3)
-- 	end

-- -- Diseases Update
-- 	function self.getMinDiseases()
-- 		local getDisease = getDisease	

-- 		self.disease.min.dyn10AoE 	= getDisease(10,true,"min")
-- 		self.disease.min.dyn30 		= getDisease(30,false,"min") 
-- 	end

-- 	function self.getMaxDiseases()
-- 		local getDisease = getDisease	

-- 		self.disease.max.dyn10AoE 	= getDisease(10,true,"max")
-- 		self.disease.max.dyn30 		= getDisease(30,false,"max") 
-- 	end

-- -- Rune Updates
-- 	function self.getRunes()
-- 		local getRuneInfo = getRuneInfo

-- 		self.rune.info = getRuneInfo()
-- 	end

-- 	function self.getRuneCounts()
-- 		local getRuneCount = getRuneCount

-- 		self.rune.count.all 	= getRuneCount("death")+getRuneCount("blood")+getRuneCount("frost")+getRuneCount("unholy")
-- 		self.rune.count.death 	= getRuneCount("death")
-- 		self.rune.count.blood 	= getRuneCount("blood")
-- 		self.rune.count.frost 	= getRuneCount("frost")
-- 		self.rune.count.unholy 	= getRuneCount("unholy")
-- 	end

-- 	function self.getRunePercents()
-- 		local getRunePercent = getRunePercent

-- 		self.rune.percent.death 	= getRunePercent("death")
-- 		self.rune.percent.blood 	= getRunePercent("blood")
-- 		self.rune.percent.frost 	= getRunePercent("frost")
-- 		self.rune.percent.unholy 	= getRunePercent("unholy")
-- 	end

-- ---------------
-- --- OPTIONS ---
-- ---------------

-- 	-- Class options
-- 	-- Options which every Rogue should have
-- 	function self.createClassOptions()

--         -- Class Wrap
--         local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options")
--         -- Horn of Winter
--         bb.ui:createCheckbox(section,"Horn of Winter","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Horn of Winter usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.")
--         bb.ui:checkSectionState(section)
-- 	end

-- ------------------------------
-- --- SPELLS - CROWD CONTROL --- 
-- ------------------------------
-- 	-- Asphyxiate
-- 	function self.castAsphyxiate(thisUnit)
-- 		if getTalent(3,3) and getDistance(thisUnit)<30 then
-- 			if castSpell(thisUnit,self.spell.asphyxiate,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Chains of Ice
-- 	function self.castChainsOfIce(thisUnit)
-- 		if self.level>=58 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and getDistance(thisUnit)<30 then
-- 			if castSpell(thisUnit,self.spell.chainsOfIce,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Death Grip
-- 	function self.castDeathGrip(thisUnit)
-- 		if self.inCombat then
-- 			local enemies = getEnemies("player",30)
-- 			if #enemies > 0 then
-- 				for i = 1, #enemies do
-- 					local thisUnit = enemies[i]
-- 					local distance = getDistance(thisUnit)
-- 					if self.level>=55 and self.cd.deathGrip==0 and not isMoving(thisUnit) and not isMoving("player") and hasThreat(thisUnit) and distance>=5 and distance<30 then
-- 						pullTarget = true
-- 						for x=1,#bb.friend do
-- 			            	local partyUnit = bb.friend[x].unit
-- 			            	local partyDist = getDistance(partyDist,thisUnit)
-- 			            	local partyDead = UnitIsDeadOrGhost(partyUnit)
-- 			            	if not partyDead and partyDist<5 then
-- 			            		pullTarget = false
-- 			            		break
-- 			            	end
-- 			            end
-- 			            if pullTarget == true then
-- 			            	if castSpell(thisUnit,self.spell.deathGrip,false,false,false) then return end
-- 			            end
-- 			        end
-- 			    end
-- 			end
-- 		end
-- 	end
-- 	-- Gorefiend's Grasp
-- 	function self.castGorefiendsGrasp()
-- 		-- local the variables to make a clean start every time
-- 		local bestUnit, bestUnitEnemies = nil, 0
-- 		-- cycle all the enemies
-- 		for i = 1, #bb.enemy do
-- 			-- check if the unit is close enough
-- 			if bb.enemy[i].distance < 8 and bb.enemy[i].inCombat then -- oh we filter these both places you are right but use the .inCombat as it is already part of the unit
-- 				-- define this ally values if it is close enough, we do the unit scan as second move as it will more ressource hunger
-- 				local thisUnit, thisUnitEnemiesOutOfRange, thisUnitEnemiesInRange = bb.enemy[i].unit, getEnemies(bb.enemy[i].unit, 20, true), getEnemies(bb.enemy[i].unit, 8, true)
-- 				local thisUnitEnemies = thisUnitEnemiesOutOfRange - thisUnitEnemiesInRange
-- 				-- if this ally as more units around it than our best Unit then we set this one as best
-- 				if thisUnitEnemies > bestUnitEnemies and hasThreat(thisUnit) then
-- 					bestUnit, bestUnitEnemies = thisUnit, thisUnitEnemies
-- 				end
-- 			end
-- 		end
-- 		-- cycle all the allies
-- 		for i = 1, #bb.friend do
-- 			-- check if the unit is close enough
-- 			if getDistance(bb.friend[i].unit) < 8 then
-- 				-- define this ally values if it is close enough, we do the unit scan as second move as it will more ressource hunger
-- 				local thisUnit, thisUnitEnemiesOutOfRange, thisUnitEnemiesInRange = bb.friend[i].unit, getEnemies(bb.friend[i].unit, 20, true), getEnemies(bb.friend[i].unit, 8, true)
-- 				local thisUnitEnemies = #thisUnitEnemiesOutOfRange - #thisUnitEnemiesInRange
-- 				-- if this ally as more units around it than our best Unit then we set this one as best
-- 				if thisUnitEnemies > bestUnitEnemies or (thisUnitEnemies >= bestUnitEnemies and thisUnit.role == "TANK") then	
-- 					bestUnit, bestUnitEnemies = thisUnit, thisUnitEnemies
-- 				end
-- 			end
-- 		end
-- 		-- if we found a best unit then we can cast on it
-- 		if bestUnit and self.talent.gorefiendsGrasp and self.cd.gorefiendsGrasp==0 then
-- 			if castSpell(self.units.dyn20AoE,self.spell.gorefiendsGrasp,false,false,false) then return end
-- 		end	
-- 	end

-- --------------------------
-- --- SPELLS - DEFENSIVE ---
-- --------------------------
-- 	-- Anti-Magic Shell
-- 	function self.castAntiMagicShell()
-- 		if (not getTalent(2,2)) and self.level>=68 and self.cd.antiMagicShell==0 then
-- 			if castSpell("player",self.spell.antiMagicShell,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Anti-Magic Zone
-- 	function self.castAntiMagicZone()
-- 		if getTalent(2,2) and self.cd.antiMagicShell==0 then
-- 			if castGround("player",self.spell.antiMagicZone,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Blood Presence
-- 	function self.castBloodPresence()
-- 		if self.level>=57 then
-- 			if castSpell("player",self.spell.bloodPresence,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Conversion
-- 	function self.castConversion()
-- 		if getTalent(5,3) then
-- 			if castSpell("player",self.spell.conversion,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Death Pact
-- 	function self.castDeathPact()
-- 		if getTalent(5,1) and self.cd.deathPact==0 then
-- 			if castSpell("player",self.spell.deathPact,true,false,false) then return end
--         end
-- 	end
-- 	-- Death Strike
-- 	function self.castDeathStrike()
-- 		if self.level>=56 and ((self.rune.count.frost>=1 and self.rune.count.unholy>=1) or (self.rune.count.frost>=1 and self.rune.count.death>=1) or (self.rune.count.death>=1 and self.rune.count.unholy>=1) or self.rune.count.death>=2) and getDistance(self.units.dyn5)<5 then
-- 			if castSpell(self.units.dyn5,self.spell.deathStrike,false,false,false) then return end
--         end
-- 	end
-- 	-- Icebound Fortitude
-- 	function self.castIceboundFortitude()
-- 		if self.level>=62 and self.cd.iceboundFortitude==0 then
-- 			if castSpell("player",self.spell.iceboundFortitude,true,false,false) then return end
--         end
--     end
--     -- Remorseless Winter
--     function self.castRemorselessWinter()
--     	if getTalent(6,2) and self.cd.remorselessWinter==0 and getDistance(self.units.dyn8AoE)<8 then
--     		if castSpell("player",self.spell.remorselessWinter,true,false,false) then return end
--     	end
--     end
-- --------------------------
-- --- SPELLS - OFFENSIVE ---
-- --------------------------
-- 	-- Army of the Dead
-- 	function self.castArmyOfTheDead()
-- 		if self.level>=80 and self.cd.armyOfTheDead==0 
-- 			and ((self.rune.count.blood>=1 and self.rune.count.frost>=1 and self.rune.count.unholy>=1) 
-- 				or (self.rune.count.death>=1 and self.rune.count.frost>=1 and self.rune.count.unholy>=1) 
-- 				or (self.rune.count.blood>=1 and self.rune.count.death>=1 and self.rune.count.unholy>=1) 
-- 				or (self.rune.count.blood>=1 and self.rune.count.frost>=1 and self.rune.count.death>=1) 
-- 				or (self.rune.count.death>=2 and self.rune.count.blood>=1) 
-- 				or (self.rune.count.death>=2 and self.rune.count.frost>=1) 
-- 				or (self.rune.count.death>=2 and self.rune.count.unholy>=1) 
-- 				or self.rune.count.death>=3)
-- 		then
-- 			if castSpell("player",self.spell.armyOfTheDead,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Blood Boil
-- 	function self.castBloodBoil()
-- 		if self.level>=55 and (self.rune.count.blood>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn10AoE)<10 and useCleave() then
-- 			if castSpell("player",self.spell.bloodBoil,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Blood Tap
-- 	function self.castBloodTap()
-- 		if getTalent(4,1) and self.charges.bloodTap>4 and getDistance(self.units.dyn5)<5 then
-- 			if castSpell("player",self.spell.bloodTap,true,false,false) then return end
-- 		end
-- 	end
-- 	-- Breath of Sindragosa
-- 	function self.castBreathOfSindragosa()
-- 		if getTalent(7,3) and self.cd.breathOfSindragosa==0 and self.power>15 and getDistance(self.units.dyn12)<12 and useCleave() then
-- 			if castSpell("player",self.spell.breathOfSindragosa,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Death and Decay
-- 	function self.castDeathAndDecay()
-- 		if (not getTalent(7,2)) and (self.rune.count.unholy>=1 or self.rune.count.death>=1) and self.cd.deathAndDecay==0 and (hasThreat(self.units.dyn30) or isDummy()) and getDistance(self.units.dyn30AoE)<30 and useCleave() and not isMoving(self.units.dyn30AoE) then
-- 			if castGroundAtBestLocation(self.spell.deathAndDecay,10,1,30) then return end
-- 		end
-- 	end
-- 	-- Death Siphon
-- 	function self.castDeathSiphon()
-- 		if getTalent(5,2) and self.rune.count.death>=1 and (hasThreat(self.units.dyn40) or isDummy()) and getDistance(self.units.dyn40)<40 then
-- 			if castSpell(self.units.dyn40,self.spell.deathSiphon,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Defile
-- 	function self.castDefile()
-- 		if getTalent(7,2) and (self.rune.count.unholy>=1 or self.rune.count.death>=1) and self.cd.defile==0 and (hasThreat(self.units.dyn30) or isDummy()) and getDistance(self.units.dyn30AoE)<30 and useCleave() and not isMoving(self.units.dyn30AoE) then
-- 			if castGroundAtBestLocation(self.spell.defile,8,1,30) then return end
-- 			--if castGround(self.units.dyn30AoE,self.spell.defile,30) then return end
-- 		end
-- 	end
-- 	-- Empower Rune Weapon
-- 	function self.castEmpowerRuneWeapon()
-- 		if self.level>=76 and self.cd.empowerRuneWeapon==0 and getDistance(self.units.dyn5)<5 then
-- 			if castSpell("player",self.spell.empowerRuneWeapon,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Frost Presense
-- 	function self.castFrostPresence()
-- 		if self.level>=55 then
-- 			if castSpell("player",self.spell.frostPresence,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Horn of Winter
-- 	function self.castHornOfWinter()
-- 		if self.level>=65 then
-- 	        if self.instance=="none" and not isBuffed("player",{self.spell.hornOfWinter,19506,6673}) then
-- 	        	if castSpell("player",self.spell.hornOfWinter,false,false,false) then return end
-- 	        else
-- 		        local totalCount = GetNumGroupMembers()
-- 		        local currentCount = currentCount or 0
-- 		        local needsBuff = needsBuff or 0
-- 		        for i=1,#bb.friend do
-- 		            local thisUnit = bb.friend[i].unit
-- 		            local distance = getDistance(thisUnit)
-- 		            local dead = UnitIsDeadOrGhost(thisUnit)
-- 		            if distance<30 then
-- 		                currentCount = currentCount+1
-- 		            end
-- 		            if not isBuffed(thisUnit,{self.spell.hornOfWinter,19506,6673}) and not dead and UnitIsPlayer(thisUnit) and not UnitInVehicle(thisUnit) then
-- 		            	needsBuff = needsBuff+1
-- 		            end
-- 		        end
-- 		        if currentCount>=totalCount and needsBuff>0 then
-- 		            if castSpell("player",self.spell.hornOfWinter,false,false,false) then return end
-- 		        end
-- 		    end
-- 	    end
-- 	end
-- 	-- Icy Touch
--     function self.castIcyTouch()
--         if self.level>=55 and (self.rune.count.frost>=1 or self.rune.count.death>=1) and (hasThreat(self.units.dyn5) or isDummy()) and getDistance(self.units.dyn5)<30 then
--             if castSpell(self.units.dyn5,self.spell.icyTouch,false,false,false) then return end
--         end
--     end
-- 	-- Outbreak
-- 	function self.castOutbreak()
-- 		if self.level>=81 and self.cd.outbreak==0 and (hasThreat(self.units.dyn30) or isDummy()) and getDistance(self.units.dyn30)<30 then
-- 			if castSpell(self.units.dyn30,self.spell.outbreak,true,false,false) then return end
-- 		end
-- 	end
-- 	-- Plague Leech
-- 	function self.castPlagueLeech()
-- 		if getTalent(1,2) and self.cd.plagueLeech==0 and ((self.debuff.frostFever and self.debuff.bloodPlague) or self.debuff.necroticPlague) and (hasThreat(self.units.dyn5) or isDummy()) and getDistance(self.units.dyn5)<30 then
-- 			if castSpell(self.units.dyn5,self.spell.plagueLeech,true,false,false) then return end
-- 		end
-- 	end
-- 	-- Plague Strike
-- 	function self.castPlagueStrike()
-- 		if self.level>55 and (self.rune.count.unholy>=1 or self.rune.count.death>=1) and getDistance(self.units.dyn5)<5 then
-- 			if castSpell(self.units.dyn5,self.spell.plagueStrike,true,false,false) then return end
-- 		end
-- 	end
-- 	-- Unholy Blight
-- 	function self.castUnholyBlight()
-- 		if getTalent(1,3) and self.cd.unholyBlight==0 and getDistance(self.units.dyn10AoE)<10 and useCleave() then
-- 			if castSpell("player",self.spell.unholyBlight,false,false,false) then return end
-- 		end
-- 	end

-- ------------------------
-- --- SPELLS - UTILITY ---
-- ------------------------
-- 	-- Dark Simulacrum
-- 	function self.castDarkSimulacrum(thisUnit)
-- 		if self.level>=85 and cd.darkSimulacrum==0 and self.power>20 and getDistance(thisUnit)<30 then
-- 			if castSpell(thisUnit,self.spell.darkSimulacrum,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Death's Advance
-- 	function self.castDeathsAdvance()
-- 		if getTalent(3,1) and self.cd.deathsAdvance==0 then
-- 			if castSpell("player",self.spell.deathsAdvance,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Desecrated Ground
-- 	function self.castDesecratedGround()
-- 		if getTalent(6,3) and self.cd.desecratedGround==0 then
-- 			if castSpell("player",self.spell.desecratedGround,true,false,false) then return end
-- 		end
-- 	end
-- 	-- Lichborne
-- 	function self.castLichborne()
-- 		if getTalent(2,1) and self.cd.lichborne==0 then
-- 			if castSpell("player",self.spell.lichborne,true,false,false) then return end
--         end
-- 	end
-- 	-- Mind Freeze
-- 	function self.castMindFreeze()
-- 		thisUnit = thisUnit
-- 		if self.level>=57 and self.cd.mindFreeze==0 and getDistance(thisUnit)<5 then
-- 			if castSpell(thisUnit,self.spell.mindFreeze,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Path of Frost
-- 	function self.castPathOfFrost()
-- 		if self.level>=66 and (self.rune.count.frost>=1 or self.rune.count.death>=1) then
-- 			if castSpell("player",self.spell.pathOfFrost,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Raise Ally
-- 	function self.castRaiseAlly()
-- 		if self.level>=72 and self.power>30 and self.cd.raiseAlly==0 and getDistance("target")<40 and UnitIsPlayer("target") and UnitIsDeadOrGhost("target") then
-- 			if castSpell("target",self.spell.raiseAlly,false,false,false,false,true) then return end
-- 		end
-- 	end
-- 	function self.castRaiseAllyMouseover()
-- 		if self.level>=72 and self.power>30 and self.cd.raiseAlly==0 and getDistance("mouseover")<40 and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") then
-- 			if castSpell("mouseover",self.spell.raiseAlly,false,false,false,false,true) then return end
-- 		end
-- 	end
-- 	-- Stangulate
-- 	function self.castStrangulate(thisUnit)
-- 		if self.level>=58 and self.cd.strangulate==0 and (self.rune.count.blood>=1 or self.rune.count.death>=1) and getDistance(thisUnit)<30 then
-- 			if castSpell(thisUnit,self.spell.strangulate,false,false,false) then return end
-- 		end
-- 	end
-- 	-- Unholy Presence
-- 	function self.castUnholyPresence()
-- 		if self.level>=64 then
-- 			if castSpell("player",self.spell.unholyPresence,false,false,false) then return end
-- 		end
-- 	end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
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

-- Return
	return self
end

end -- End Select 