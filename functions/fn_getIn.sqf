// #define DEBUG_MODE_FULL
#include "script_component.hpp"

private ["_vehicleBFT"];
params ["_vehicle","","_unit"];

if (_unit == player) then {
	_vehicleBFT = _vehicle getVariable [QGVAR(BFT), false];
	if (IS_ARRAY(_vehicleBFT) && {true in _vehicleBFT}) then {
		[_vehicle, true] call vk_fnc_setBFT;
	};
};