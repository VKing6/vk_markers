#define DEBUG_MODE_FULL
#include "script_component.hpp"

if (!isDedicated) then {

    [ vk_fnc_playerCheck, 0, []] call CBA_fnc_addPerFrameHandler;

    LOG("PostInit Started");

    GVAR(playerSide) = side player;

    {
        _x call FUNC(convertBFT);
    } forEach vehicles;

    GVAR(postInit) = true;
    LOG("PostInit complete");

    GVAR(markerLoopHandler) = [vk_fnc_markerLoop, 1, []] call CBA_fnc_addPerFrameHandler;
};
