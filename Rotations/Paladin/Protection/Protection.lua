function PaladinProtection() 
    if GetSpecializationInfo(GetSpecialization()) == 66 then 
        if br.player == nil or br.player.profile ~= "Protection" then
            br.player = cPalProtection:new("Protection") 
            setmetatable(br.player, {__index = cPalProtection})
            br.player:createOptions()
            br.player:createToggles()
            br.player:update()
        end
        br.player:update()

    end --Class Check End
end --Spec Function End