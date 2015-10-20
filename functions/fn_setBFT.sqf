// #define DEBUG_MODE_FULL
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
