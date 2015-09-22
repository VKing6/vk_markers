// #define DEBUG_MODE_FULL
#include "script_component.hpp"
// PARAMS_3(_vehicle,_pos,_unit);

private ["_vehicleBFT";
params ["_vehicle","","_unit"];

if (_unit == player) then {
	_vehicleBFT = _vehicle getVariable [QGVAR(BFT), false];
	if (IS_ARRAY(_vehicleBFT) && {true in _vehicleBFT}) then {
		_vehicleBFT = true;
	};
	TRACE_1("",_vehicleBFT);
	
	if (_vehicleBFT) then {
		GVAR(playerBFT) = true;
	};
};