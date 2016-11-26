function DeathKnightFrost() -- Change to ClassSpec() (IE: MageFire())
    if GetSpecializationInfo(GetSpecialization()) == 251 then -- Change to spec id
        if br.player == nil or br.player.profile ~= "Frost" then -- Change "Frost" to spec (IE: "Fire")
            br.player = cFrost:new("Frost") -- Change cFrost to cSpec (IE: cFire) and Change "Fury" to spec (IE: "Fire")
            setmetatable(br.player, {__index = cFrost}) -- Change cFrost to cSpec (IE: cFire)

            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end

        br.player:update()
    end
end