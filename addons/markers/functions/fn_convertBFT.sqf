/*
    File: convertBFT.sqf
    Author: VKing

    Description:
    Internal function.
    Converts old type vehicle BFT array to fnc_setBFT

    Returns:
    None
*/

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

private ["_vehicleBFT"];
params ["_vehicle"];
_vehicleBFT = _vehicle getVariable [QGVAR(BFT), false];
TRACE_2("ConvertBFT",_vehicle,_vehicleBFT);
if (IS_ARRAY(_vehicleBFT) && {true in _vehicleBFT}) then {
    [_vehicle, true] call vk_fnc_setBFT;
};
