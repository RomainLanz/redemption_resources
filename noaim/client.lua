--[[------------------------------------------------------------------------
    Remove Reticle on ADS (Third Person)
------------------------------------------------------------------------]]--
local scopedWeapons =
{
    100416529,  -- WEAPON_SNIPERRIFLE
    205991906,  -- WEAPON_HEAVYSNIPER
    3342088282  -- WEAPON_MARKSMANRIFLE
}

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do
        if ( hash == v ) then
            return true
        end
    end

    return false
end

function ManageReticle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        local hash = GetSelectedPedWeapon(ped)
        if not HashInTable( hash )  then
            HideHudComponentThisFrame( 14 )
        end
    end
end

Citizen.CreateThread( function()
    while true do
        Wait(0)
        ManageReticle()
    end
end )
