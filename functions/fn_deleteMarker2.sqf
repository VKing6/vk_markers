/*
    File: deleteMarker2.sqf
    Author: VKing

    Description:
    Internal function.
    Delete markers in game.

    Returns:
    None
*/

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_name", "_mods"];
TRACE_2("Params",_name,_mods);

deleteMarkerLocal _name;
deleteMarkerLocal format ["%1_size",_name];
deleteMarkerLocal format ["%1_text",_name];
{
    deleteMarkerLocal format ["%1_%2",_name,_x];
    TRACE_2("Deleted",_name,_x);
} forEach _mods;
