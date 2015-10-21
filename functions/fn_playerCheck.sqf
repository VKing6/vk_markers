/*
    File: playerCheck.sqf
    Author: VKing

    Description:
    Internal function.
    Checks for player initialization

    Returns:
    None
*/

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

LOG("Looking for player");
if (!isNull player) then {
    TRACE_1("Player found",player);
    [(_this select 1)] call CBA_fnc_removePerFrameHandler;
};
