// #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_unit","_pos"];
TRACE_2("MoveMarker Params",_unit,_pos);
private ["_bit","_markerData","_bft","_pointer"];
_markerData = _unit getVariable [QGVAR(markerData),[]];
_markerData params ["_name", "_mods", "_type", "_size", "_scale", "_visibleTo", "_text"];
_bft = _unit getVariable [QGVAR(markerBFT),false];
_bit = 0;
if (typeOf _unit == "vk_helper_vehicle") then {
    ADD(_bit,1);
} else {
    ADD(_bit,0);
};
if (IS_OBJECT(_pos)) then {
    ADD(_bit,0);
} else {
    ADD(_bit,2);
};
switch (_bit) do {
    case 3: {_unit setPos _pos; _pointer = _unit};
    case default {_unit call vk_fnc_deleteMarker; _pointer = [_pos,_type,_mods,_size,_scale,_visibleTo,_text,_bft] call vk_fnc_addMarker};
};
_pointer
