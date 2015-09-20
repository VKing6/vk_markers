// #define DEBUG_MODE_FULL
#include "script_component.hpp"


if (isDedicated) then {
	LOG("Server: Creating variables");
	ISNILS(GVAR(gKilledType),"remove");
	publicVariable QGVAR(gKilledType);
	GVAR(postInit) = true;
} else {
	TRACE_1("Client: Initializing variables",GVAR(gKilledType));
	
	if (isNil QGVAR(gKilledType)) then {
		GVAR(gKilledType) = "remove";
		publicVariable QGVAR(gKilledType);
	};
	GVAR(postInit) = false;
};


PREP(addMarker);
PREP(createMarker);
PREP(killed);
PREP(markerLoop);
vk_fnc_addMarker = FUNC(addMarker);


FUNC(deleteMarker) = {
	//PARAMS_1(_name);
    params ["_name"];
	private ["_markerData","_markerName"];
	{
		_markerData = _x getVariable QGVAR(markerData);
		_markerName = _markerData select 0;
		if (_name == _markerName) then {
			[QGVAR(deleteMarker), _markerData] call CBA_fnc_GlobalEvent;
			_x setVariable [QGVAR(markerData),nil,true];
			_x setVariable [QGVAR(markerArray),nil,true];
			TRACE_2("Deleting marker from unit",_name,_x);
			if (typeOf _x == "vk_helper_vehicle") then {
				deleteVehicle _unit;
			};
		};
	} forEach allUnits + vehicles;
};
vk_fnc_deleteMarker = FUNC(deleteMarker);
[QGVAR(deleteMarker), {_this call COMPILE_FILE(fnc_deleteMarker)}] call CBA_fnc_addEventHandler;

/*
FUNC(hideMarker) = {
	PARAMS_1(_name);
	private ["_markerData","_markerName"];
	{
		_markerData = _x getVariable [QGVAR(markerData),[""]];
		_markerName = _markerData select 0;
		TRACE_1("",_markerData);
		if (_name == _markerName) then {
			[_markerData select 0, _markerData select 1] call COMPILE_FILE(fnc_deleteMarker);
			_x setVariable [QGVAR(markerArray),nil,false];
			TRACE_2("Hiding marker from unit",_name,_x);
		};
	} forEach allUnits + vehicles;
};
*/

FUNC(playerCheck) = {
	LOG("Looking for player");
	if (!isNull player) then {
		TRACE_1("Player found",player);
		[(_this select 1)] call CBA_fnc_removePerFrameHandler;
	};
};
