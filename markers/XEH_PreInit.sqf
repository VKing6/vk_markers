//#define DEBUG_MODE_FULL
#include "script_component.hpp"


if (isServer) then {
	LOG("Server: Creating variables");
	ISNILS(GVAR(static_markers),[]);
	ISNILS(GVAR(gKilledType),"remove");
	publicVariable QGVAR(static_markers);
	publicVariable QGVAR(gKilledType);
} else {
	TRACE_1("Client: Creating variables",GVAR(static_markers));
	ISNILS(GVAR(static_markers),[]);
	ISNILS(GVAR(gKilledType),"remove");
	
	GVAR(static_markers_2) = GVAR(static_markers);
	
	publicVariable QGVAR(static_markers);
	publicVariable QGVAR(gKilledType);
	
	QGVAR(static_markers) addPublicVariableEventHandler {
		private ["_newArray","_newMarker","_visibleTo"];
		_newArray = _this select 1;
		if (count _newArray < 1) exitWith {}; // Array too small
		_newMarker = _newArray select (count _newArray-1);
		_visibleTo = _newMarker select 5;
		if (GVAR(postInit)) then {
			if (GVAR(playerSide) in _visibleTo) then {
				TRACE_1("Creating propogated marker",_this);
				_this call FUNC(createMarker);
			};
		} else {
			if !(_newMarker in GVAR(static_markers_2)) then {
				PUSH(GVAR(static_markers_2),_newMarker);
				GVAR(static_markers) = GVAR(static_markers_2);
			};
		};
	};
};

GVAR(postInit) = false;


PREP(addMarker);
PREP(createMarker);
PREP(killed);
PREP(markerLoop);
PREP(mapLoop);
vk_fnc_addMarker = FUNC(addMarker);


FUNC(globalMarker) = {
	private ["_visibleTo"];
	_visibleTo = _this select 5;
	if (GVAR(postInit)) then {
		if (GVAR(playerSide) in _visibleTo) then {
			TRACE_1("Creating propogated marker",_this);
			_this call FUNC(createMarker);
		};
	};
};
[QGVAR(globalMarker), {_this call FUNC(globalMarker)}] call CBA_fnc_addEventHandler;

FUNC(deleteMarker) = {
	PARAMS_1(_name);
	private ["_remArray","_markerData","_markerName"];
	_remArray = [];
	for "_i" from 0 to (count GVAR(static_markers) - 1) do {
		if ((GVAR(static_markers) select _i) select 0 == _name) then {
			PUSH(_remArray,_i);
			[QGVAR(deleteMarker), GVAR(static_markers) select _i] call CBA_fnc_GlobalEvent;
			TRACE_2("Deleting static marker",_i,_name);
		};
	};
	TRACE_2("Before Removeindex",GVAR(static_markers),_remArray);
	GVAR(static_markers) = [GVAR(static_markers),_remArray] call BIS_fnc_removeIndex;
	publicVariable QGVAR(static_markers);
	{
		_markerData = _x getVariable [QGVAR(markerData),[""]];
		_markerName = _markerData select 0;
		if (_name == _markerName) then {
			[QGVAR(deleteMarker), _markerData] call CBA_fnc_GlobalEvent;
			_x setVariable [QGVAR(markerData),nil,true];
			_x setVariable [QGVAR(markerArray),nil,true];
			TRACE_2("Deleting marker from unit",_name,_x);
		};
	} forEach allUnits + vehicles;
};
vk_fnc_deleteMarker = FUNC(deleteMarker);
[QGVAR(deleteMarker), {_this call COMPILE_FILE(fnc_deleteMarker)}] call CBA_fnc_addEventHandler;

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
