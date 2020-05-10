/*
    File: killed.sqf
    Author: VKing

    Description:
    Internal function.
    Handles killed eventHandler

    Returns:
    None
*/

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_unit"];
TRACE_1("Params",_unit);

private ["_markerData","_markerArray","_killedType","_pos","_bft"];

_markerData = _unit getVariable QGVAR(markerData);
_markerArray = _unit getVariable QGVAR(markerArray);
_killedType = _unit getVariable QGVAR(killedType);

if (isNil "_markerData") exitWith {
    TRACE_1("No markerData for unit",_unit);
    if (!isNil "_markerArray") exitWith {
        _unit setVariable [QGVAR(markerArray),nil,true];
    };
};
if (isNil "_markerArray") exitWith {
    TRACE_1("No markerArray for unit",_unit);
    _unit setVariable [QGVAR(markerData),nil,true];
};

_markerData params ["_name", "_mods", "_type", "_size", "_scale", "_visibleTo", "_text"];
_pos = getPos _unit;
_bft = _unit getVariable [QGVAR(markerBFT),false];

if (isNil "_killedType") then {
    _killedType = GVAR(gKilledType);
};
TRACE_1("",_killedType);
switch (_killedType) do {
    case "static": {
        LOG("Recreate marker as static");
        _unit call vk_fnc_deleteMarker;
        [_pos,_type,_mods,_size,_scale,_visibleTo,_text,_bft] call vk_fnc_addMarker;
    };
    case "destroy": {
        LOG("Adding destroyed marker");
        _unit call vk_fnc_deleteMarker;
        _mods pushback "destroyed";
        [_pos,_type,_mods,_size,_scale/2 max 0.9,_visibleTo,_text,_bft] call vk_fnc_addMarker;
    };
    case "remove": {
        LOG("Remove marker");
        _unit call vk_fnc_deleteMarker;
    };
};
