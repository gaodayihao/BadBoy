


-- Functions from coders for public use

--[[                                                                                                ]]
--[[ ragnar                                                                                         ]]
--[[                                                                                                ]]
function unitLookup(Unit,returnType)
	for k, v in pairs(br.enemy) do
		if br.enemy[k].guid == Unit or br.enemy[k].unit == Unit then
			if returnType == "guid" then
				return br.enemy[k].guid
			elseif returnType == "table" then
				return i
			else
				return br.enemy[k].unit
			end
		end
	end
end

function getUnitCount(ID,maxRange,tapped)
	local counter = 0
	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		local thisUnitID = br.enemy[k].id
		if thisUnitID == ID then
			if getDistance("player",br.enemy[k].unit) < maxRange then
				if (tapped == true and UnitIsTappedByPlayer(thisUnit)) or tapped == nil or tapped == false then
					counter = counter + 1
				end
			end
		end
	end
	return counter
end

function isCCed(Unit)
	local CCTable = {84868, 3355, 19386, 118, 28272, 28271, 61305, 61721, 161372, 61780, 161355, 126819, 161354, 115078, 20066, 9484, 6770, 1776, 51514, 107079, 10326, 8122, 154359, 2094, 5246, 5782, 5484, 6358, 115268, 339};
	for i=1, #CCTable do
		if UnitDebuffID(Unit,CCTable[i]) then
			return true
		end
	end
	return false
end

function castGroundAtBestLocation(spellID, radius, minUnits, maxRange, minRange, spellType)
	-- description:
		-- find best position for AoE spell and cast it there

	-- return:
		-- true/nil

	-- example:
		-- castGroundAtBestLocation(121536,2,10,40)


	local function isNotBlacklisted(checkUnit)
		local blacklistUnitID = {
		}
		if checkUnit == nil then return false end
		for i = 1, #blacklistUnitID do
			if GetObjectID(checkUnit) == blacklistUnitID[i] then return false end
		end
		return true
	end

	-- begin
	if minRange == nil then minRange = 0 end
	local allUnitsInRange = {}
	-- Make function usable between enemies and friendlies
	if spellType == "heal" then	unitTable = br.friend else unitTable = br.enemy end
	-- fill allUnitsInRange with data from enemiesEngine/healingEngine
	--Print("______________________1")
	-- for i=1,#unitTable do
	for k, v in pairs(unitTable) do
		local thisUnit = unitTable[k].unit
		local thisDistance = getDistance(thisUnit)
		local hasThreat = isValidUnit(thisUnit) or UnitIsFriend(thisUnit,"player") --hasThreat(br.enemy[i].unit)
		--Print(thisUnit.." - "..thisDistance)
		if isNotBlacklisted(thisUnit) then
			--Print("blacklist passed")
			if thisDistance < maxRange and thisDistance >= minRange and hasThreat then
				--Print("distance passed")
				if not UnitIsDeadOrGhost(thisUnit) and (getFacing("player",thisUnit) or UnitIsUnit(thisUnit,"player")) and getLineOfSight(thisUnit) and not isMoving(thisUnit) then
					--Print("ghost passed")
					if UnitAffectingCombat(thisUnit) or (spellType == "heal" and getHP(Unit) < 100) or isDummy(thisUnit) then
						--Print("combat and dummy passed")
						table.insert(allUnitsInRange,thisUnit)
					end
				end
			end
		end
	end
	-- check units in allUnitsInRange against each them
	--Print("______________________2")
	local goodUnits = {}
	for i=1,#allUnitsInRange do
		local thisUnit = allUnitsInRange[i]
		local unitsAroundThisUnit = {}
		--Print("units around "..thisUnit..":")
		for j=1,#allUnitsInRange do
			local checkUnit = allUnitsInRange[j]
			--Print(checkUnit.."?")
			if getDistance(thisUnit,checkUnit) < radius then
				--Print(checkUnit.." added")
				table.insert(unitsAroundThisUnit,checkUnit)
			end
		end
		if #goodUnits <= #unitsAroundThisUnit then
			--Print("units around check: "..#unitsAroundThisUnit.." >= "..#goodUnits)
			if tonumber(minUnits) <= #unitsAroundThisUnit then
				--Print("enough units around: "..#unitsAroundThisUnit)
				goodUnits = unitsAroundThisUnit
			end
		end
	end
	-- where to cast
	--Print("______________________3")
	if #goodUnits > 0 then
		--Print("goodUnits > 0")
		if #goodUnits > 1 then
			--Print("goodUnits > 1")
			local mX, mY,mZ = 0,0,0
			for i=1,#goodUnits do
				local thisUnit = goodUnits[i]
				local thisX,thisY,thisZ = GetObjectPosition(thisUnit)
				if mX == 0 or mY == 0 or mZ == 0 then
					mX,mY,mZ = thisX,thisY,thisZ
				else
					mX = 0.5*(mX + thisX)
					mY = 0.5*(mY + thisY)
					mZ = 0.5*(mZ + thisZ)
				end
			end
			--Print(mX.." "..mY.." "..mZ)
			if mX ~= 0 and mY ~= 0 and mZ ~= 0 then
				CastSpellByName(GetSpellInfo(spellID))
				ClickPosition(mX,mY,mZ)
				return true
			end
		else
			local thisX,thisY,thisZ = GetObjectPosition(goodUnits[1])
			CastSpellByName(GetSpellInfo(spellID))
			ClickPosition(thisX,thisY,thisZ);
			return true
		end
	end
end


function isUnitThere(unitNameOrID,distance)
	-- description:
		-- check if Unit with ID or name is around

	-- return:
		-- true/nil

	-- example:
		-- isUnitThere("Shadowfel Warden")

	if type(unitNameOrID)=="number" then
		for k, v in pairs(br.enemy) do
			local thisUnit = br.enemy[k].unit
			if GetObjectID(thisUnit) then
				if distance==nil or getDistance("player",thisUnit) < distance then
					return true
				end
			end
		end
	end
	if type(unitNameOrID)=="string" then
		for k, v in pairs(br.enemy) do
			local thisUnit = br.enemy[k].unit
			if UnitName(thisUnit)==unitNameOrID then
				if distance==nil or getDistance("player",thisUnit) < distance then
					return true
				end
			end
		end
	end
end

function getTooltipSize(SpellID)
	-- description
		-- get the dmg or heal value from a tooltip

	-- return:
		-- number

	-- example:
		-- getTooltipSize(2061)

	_, _, n1, n2 = GetSpellDescription(SpellID):find("(%d+),(%d%d%d)")
	return tonumber(n1..n2)
end

function castBossButton(target)
	if target==nil then
		RunMacroText("/click ExtraActionButton1")
		return true
	else
		TargetUnit(target)
		RunMacroText("/click ExtraActionButton1")
		return true
	end
end

-- get threat situation on player and return the number
function getThreat()
	if UnitThreatSituation("player") ~= nil then
		return UnitThreatSituation("player")
	end
	-- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
	-- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
	-- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
	-- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
	return 0
end

function RaidBuff(BuffSlot,myBuffSpellID)
	-- description:
		-- check for raidbuff and cast if missing

	-- returns:
		-- true: 	someone was without buff and spell casted
		-- false: 	"BuffSlot" or "myBuffSpellID" is missing
		-- nil: 	all raidmembers in range are buffed

	-- example:
		-- Check for Stamina as Priest:
			-- Buffslot Stamina: 2
			-- Power Word: Fortitude Spell ID: 21562
			-- RaidBuff(2,21562)
	-- Buffslots:
		-- 1 Stats
		-- 2 Stamina
		-- 3 Attack Power
		-- 4 Haste
		-- 5 Spell Power
		-- 6 Critical Strike
		-- 7 Mastery
		-- 8 Multistrike
		-- 9 Versatility

	if BuffSlot==nil or myBuffSpellID==nil then return false end

	local id = BuffSlot
	local SpellID = myBuffSpellID
	local bufftable = {
		stats = {1126,115921,116781,20217,160206,159988,160017,90363,160077},
		stamina = {21562,166928,469,160199,50256,160003,90364},
		attackPower = {57330,19506,6673},
		spellPower = {1459,61316,109773,160205,128433,90364,126309},
		mastery = {155522,24907,19740,116956,160198,93435,160039,128997,160073},
		haste = {55610,49868,113742,116956,160203,128432,160003,135670,160074},
		crit = {17007,1459,61316,116781,160200,90309,126373,160052,90363,126309,24604},
		multistrike = {166916,49868,113742,109773,172968,50519,57386,58604,54889,24844},
		versatility = {55610,1126,167187,167188,172967,159735,35290,57386,160045,50518,173035,160007}
	}

	if id == 1 then
		chosenTable = bufftable.stats
	elseif id == 2 then
		chosenTable = bufftable.stamina
	elseif id == 3 then
		chosenTable = bufftable.attackPower
	elseif id == 4 then
		chosenTable = bufftable.spellPower
	elseif id == 5 then
		chosenTable = bufftable.mastery
	elseif id == 6 then
		chosenTable = bufftable.haste
	elseif id == 7 then
		chosenTable = bufftable.crit
	elseif id == 8 then
		chosenTable = bufftable.multistrike
	elseif id == 9 then
		chosenTable = bufftable.versatility
	end


	if GetNumGroupMembers()==0 then
		if not UnitIsDeadOrGhost("player") then
			if not GetRaidBuffTrayAuraInfo(id) then
				if castSpell("player",SpellID) then return true end
			end
		end
	else
		if UnitIsDeadOrGhost("player") then
			return false
		else
			for index=1,GetNumGroupMembers() do
				local name, _, subgroup, _, _, _, zone, online, isDead, _, _ = GetRaidRosterInfo(index)
				if online and not isDead and 1==IsSpellInRange(select(1,GetSpellInfo(SpellID)), "raid"..index) then
					local playerBuffed=false
					for auraIndex=1,#chosenTable do
						if getBuffRemain("raid"..index,chosenTable[auraIndex])>0 then break end
						if getBuffRemain("raid"..index,chosenTable[auraIndex])<=0 then
							if castSpell("player",spellID,true,false) then return true end
						end
					end
				end
			end
		end
	end
end

function getUnitCluster(minUnits,maxRange,radius)
	-- Description:
		-- returns the enemy with minUnits around in maxRange

	-- rerturns:
		-- "0x0000000110E4F09C"

	-- how to use:
		-- castSpell(getUnitCluster(2,10),SpellID,...,...)
		-- use "getUnitCluster(minUnits,maxRange)" instead of "target"

	if type(minUnits) ~= "number" then return nil end
	if type(maxRange) ~= "number" then return nil end
	if type(radius) ~= "number" then return nil end

	local enemiesInRange = 0
	local theReturnUnit

	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		local thisEnemies = getNumEnemies(thisUnit,radius)
		if getLineOfSight(thisUnit) == true then
		if getDistance("player",thisUnit) < maxRange then
				if thisEnemies >= minUnits and thisEnemies > enemiesInRange then
					theReturnUnit = thisUnit
				end
			end
		end
	end
	return select(1,theReturnUnit)
end

function getBiggestUnitCluster(maxRange,radius)
	-- Description:
		-- returns the enemy with most enemies in radius in maxRange from player

	-- rerturns:
		-- "0x0000000110E4F09C"

	-- how to use:
		-- castSpell(getBiggestUnitCluster(40,10),SpellID,...,...)
		-- use "getBiggestUnitCluster(maxRange,radius)" instead of "target"

	if type(maxRange) ~= "number" then return nil end
	if type(radius) ~= "number" then return nil end

	local enemiesInRange = 0
	local theReturnUnit

	for k, v in pairs(br.enemy) do
		local thisUnit = br.enemy[k].unit
		if getLineOfSight(thisUnit) == true then
			if getDistance("player", thisUnit) < maxRange then
				if getNumEnemies(thisUnit,radius) > enemiesInRange then
					theReturnUnit = thisUnit
				end
			end
		end
	end
	return select(1,theReturnUnit)
end



--[[                                                                                                ]]
--[[ Defmaster                                                                                      ]]
--[[                                                                                                ]]

function SalvageHelper()
	-- Description:
		-- salvage your boxes from garrision mission
		-- only when in 'Salvage Yard'
		-- abort if empytSlots in inventory < 3
		-- salvageWaiting = wait x sec before starting again

	-- Returns:
		-- nothing

	if isChecked("Salvage") and GetMinimapZoneText() == "Salvage Yard" then

		local salvageWaiting = getValue("Salvage")

		if (salvageTimer == nil or (GetTime() - salvageTimer > salvageWaiting)) and not castingUnit() then
			local freeSlots = 0

			for i=1,5 do
				freeSlots = freeSlots + GetContainerNumFreeSlots(i-1)
			end

			if freeSlots > 3 then
				-- Bag of Salvaged Goods
				if GetItemCount(114116, false, false) > 0 then
					UseItemByName(114116)
				-- Crate of Salvage
				elseif GetItemCount(114119, false, false) > 0 then
					UseItemByName(114119)
				-- Big Crate of Salvage
				elseif GetItemCount(114120, false, false) > 0 then
					UseItemByName(114120)
				end
			else
				salvageTimer = GetTime() -- if no more free slots, start timer
                -- TEMP ! Trys to sell to close merchant (needs addon which sells items when opening merchant window)
                CloseMerchant()
                for i=1, GetObjectCount() do
                    -- Locals
                    local thisObject = GetObjectWithIndex(i)
                    if ObjectIsType(thisObject, ObjectTypes.Unit) then
                        -- Locals
                        local guid = UnitGUID(thisObject)
                        local objectName = ObjectName(thisObject)
                        local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                        objectID = tonumber(objectID)

                        if objectID == 77378 and GetDistanceBetweenObjects("player", thisObject) < 6 then
                            ObjectInteract(thisObject)
                            return
                        end
                    end
                end
                -- TEMP !
			end -- freeSlots
		end -- gettime()
	end -- isChecked()
end -- salvage()

-- Used to merge two tables
function mergeTables(a, b)
	if a == nil then a = {} end
    if type(a) == 'table' and type(b) == 'table' then
        for k,v in pairs(b) do 
        	if type(v)=='table' and type(a[k] or false)=='table' then
        		mergeTables(a[k],v) 
        	else
        		a[k]=v 
        	end 
        end
    end
    return a
end

-- Used by new Class Framework to put all seperat Spell-Tables into new spell table
function mergeSpellTables(tSpell, tCharacter, tClass, tSpec)
  tSpell = mergeTables(tSpell, tCharacter)
  tSpell = mergeTables(tSpell, tClass)
  tSpell = mergeTables(tSpell, tSpec)
  return tSpell
end
function mergeIdTables(idTable)
	local class = select(2,UnitClass("player"))
	local spec = GetSpecializationInfo(GetSpecialization())
	if br.idList.Shared ~= nil then
		idTable = mergeTables(idTable, br.idList.Shared)
	end
	if br.idList[class] ~= nil then
		if br.idList[class].Shared ~= nil then
			idTable = mergeTables(idTable, br.idList[class].Shared)
			if br.idList[class].Shared.abilities ~= nil then
				idTable = mergeTables(idTable, br.idList[class].Shared.abilities)
			end
		end
		if br.idList[class][spec] ~= nil then
			idTable = mergeTables(idTable, br.idList[class][spec])
			if br.idList[class][spec].abilities ~= nil then
				idTable = mergeTables(idTable, br.idList[class][spec].abilities)
			end
		end
	end
	return idTable
end

--- Checks if a table contains given value
-- local myTable = {"hello", "world"}
-- inTable(myTable, "hello") == true
-- inTable(myTable, "WHAT?") == false
-- TODO: check if tContains() does the same wow api
function inTable(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

--- Inserts table values into a table
--  No nested table (table in a table)
function insertTableIntoTable(originalTable, insertTable)
    for i = 1,#insertTable do
        table.insert(originalTable, insertTable[i])
    end
end

--- Returns if specified trinket is equipped in either slot
-- if isTrinketEquipped(124518) then trinket = "Libram of Vindication" end
function isTrinketEquipped(trinket)
	if (GetInventoryItemID("player", 13) == trinket or GetInventoryItemID("player", 14) == trinket) then
		return true
	else
		return false
	end
end

--- Return true if player has buff X
-- Parameter: ID
-- hasBuff(12345)
function hasBuff(spellID)
    local buffs, i = { }, 1
    local buff = UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(11,UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then return true end
        end
    end
    return false
end

--- Cancel the giving BuffID
-- Parameter: ID
-- cancelBuff(12345)
function cancelBuff(spellID)
    local buffs, i = { }, 1
    local buff = UnitBuff("player", i)
    while buff do
        buffs[#buffs + 1] = buff
        i = i + 1
        buff = select(11,UnitBuff("player", i))
        if buff ~= nil then
            if buff == spellID then
                CancelUnitBuff("player", i)
                return true
            end
        end
    end
    return false
end

--[[ DBM Timer ]]--

br.DBM = {}

--- Return: All current DBM Timer
function br.DBM:getBars()
    if DBM then
        if not br.DBM.Timer then
            br.DBM.Timer = {}
        else
            wipe(br.DBM.Timer)
        end

        for bar in pairs(DBM.Bars.bars) do
            local number = string.match(bar.id ,"%d+")
            table.insert(br.DBM.Timer, {id = bar.id,timer = bar.timer,spellid = number})
        end
    end
end

--- Usage:
-- 1 - br.DBM:getPulltimer() -> return (number) pulltimer count
-- 2 - br.DBM:getPulltimer(5) -> return (boolean) if pulltimer is below given time TRUE else FALSE
-- specificID can be set if Pulltimer is NOT "Pull in"
function br.DBM:getPulltimer(time, specificID)
    if br.DBM.Timer then
        specificID = specificID or "Pull in"
        local hasPulltimer = false
        local isBelowTime = false
        local pullTimer = 0

        for i = 1, #br.DBM.Timer do
            -- Check if a Pulltimer is present
            if br.DBM.Timer[i].id == specificID then
                hasPulltimer = true
                pullTimer = br.DBM.Timer[i].timer

                -- if a time is given set var to true
                if time then
                    if pullTimer <= time then
                        isBelowTime = true
                    end
                end
            end
        end

        -- if a time is given return true if pulltimer and below given time
        -- else return time
        if time ~= nil then
            if hasPulltimer and isBelowTime then
                return true
            else
                return false
            end
        else
            if hasPulltimer then
                return pullTimer
            end
        end
    end
    return 999 -- return number to avoid conflicts but to high so it should never trigger
end

--- Usage:
-- 1 - br.DBM:getTimer(spellID) -> return (number) the count of given spell ID timer
-- 2 - br.DBM:getTimer(spellID, time) -> return (boolean) TRUE if spellid is below given time else FALSE
function br.DBM:getTimer(spellID, time)
    if br.DBM.Timer then
        local hasTimer = false
        local isBelowTime = false
        local currentTimer = 0

        for i = 1, #br.DBM.Timer do
            -- Check if timer with spell id is present
            if br.DBM.Timer[i].spellid == spellID then
                hasTimer = true
                currentTimer = br.DBM.Timer[i].timer

                -- if a time is given set var to true
                if time then
                    if currentTimer <= time then
                        isBelowTime = true
                    end
                end
            end
        end

        -- if a time is given return true if timer and below given time
        -- else return time
        if time ~= nil then
            if hasTimer and isBelowTime then
                return true
            else
                return false
            end
        else
            if hasTimer then
                return currentTimer
            end
        end
    end
    return 999 -- return number to avoid conflicts but to high so it should never trigger
end
