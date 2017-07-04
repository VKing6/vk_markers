/*
    File: SetBFT.sqf
    Author: VKing

    Description:
    Set BLUFOR-tracker state for a vehocle.
    See github.com/VKing6/vk_markers for more information.

    Parameter(s):
        0: <object> vehicle or unit
        1: (Optional) <bool> new state (if blank state will be toggled)

    Returns:
    None

    Examples
    * _marker2 call vk_fnc_deleteMarker;
    * heli3 call vk_fnc_deleteMarker;
*/

#define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_unit",["_newState",nil,[true,nil]]];
TRACE_2("SetBFT Params",_unit,_newState);

if (isNil "_newState") then {
    _state = _unit getVariable [QGVAR(BFT),false];
    _newState = !_state;
};
_unit setVariable [QGVAR(BFT),_newState,true];
TRACE_1("fnc_setBFT",_newState);
_newState
