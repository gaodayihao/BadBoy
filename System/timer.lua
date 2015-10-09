--[[ Start different c_timer for the events]]
-- 1 / Times_per_Second = how often the function should be executed
-- 0.25 -> 4 times per second

-- Enemies Table
tickerEnemiesTable     = C_Timer.NewTicker(0.25, function() makeEnemiesTable(maxDistance) end)

-- Healing Engine
tickerHealingEngine    = C_Timer.NewTicker(0.25, function() nNova:Update() end)

-- Helper-Engines

--- Add extra check:
-- if helper is checked in option -> start timer
-- if helper is NOT checked in option-> cancel timer
tickerProfessionHelper = C_Timer.NewTicker(0.5,function() ProfessionHelper() end)

--- Add extra check:
-- if event = zone change and salvage yard -> start timer
-- if event = zone change and  NOT salvage yard -> cancel timer
tickerSalvageHelper    = C_Timer.NewTicker(0.5, function() SalvageHelper() end)

-- Standard BB update
tickerBadBoyUpdate     = C_Timer.NewTicker(0.2, function() BadBoyUpdate() end)
