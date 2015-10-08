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

FUNC(playerCheck) = {
	LOG("Looking for player");
	if (!isNull player) then {
		TRACE_1("Player found",player);
		[(_this select 1)] call CBA_fnc_removePerFrameHandler;
	};
};

FUNC(hideMarker) = {
	params ["_unit"];
	TRACE_1("HideMarker Params",_unit);
	private ["_markerData"];
	_markerData = _unit getVariable [QGVAR(markerData),[]];
	[QGVAR(deleteMarker),[_markerData select 0, _markerData select 1]] call CBA_fnc_GlobalEvent;
	_unit setVariable [QGVAR(markerArray),nil,false];
	TRACE_2("Deleting marker from unit",_unit,_markerData select 0);
};

[QGVAR(deleteMarker), {_this call COMPILE_FILE(fnc_deleteMarker)}] call CBA_fnc_addEventHandler;
FUNC(deleteMarker) = {
	params ["_unit"];
	TRACE_1("DeleteMarker Params",_unit);
	private ["_markerData","_markerName"];
	if (IS_STRING(_unit)) then {
		{
			_markerData = _x getVariable [QGVAR(markerData),[]];
			_markerName = _markerData select 0;
			TRACE_1("",_markerData);
			if (_unit == _markerName) then {
				[QGVAR(deleteMarker), _markerData] call CBA_fnc_GlobalEvent;
				_x setVariable [QGVAR(markerData),nil,true];
				_x setVariable [QGVAR(markerArray),nil,true];
				TRACE_2("Deleting marker from unit",_unit,_x);
				if (typeOf _x == "vk_helper_vehicle") then {
					deleteVehicle _x;
				};
			};
		} forEach allUnits + vehicles;
	} else {
		_markerData = _unit getVariable [QGVAR(markerData),[]];
		[QGVAR(deleteMarker), _markerData] call CBA_fnc_GlobalEvent;
		_unit setVariable [QGVAR(markerData),nil,true];
		_unit setVariable [QGVAR(markerArray),nil,true];
		TRACE_2("Deleting marker from unit",_unit,_markerData select 0);
	};
};

FUNC(setBFT) = {
	params ["_unit",["_newState",nil,[true,nil]]];
	TRACE_2("SetBFT Params",_unit,_newState);
	if (isNil "_newState") then {
		_state = _unit getVariable [QGVAR(BFT),false];
		_newState = !_state;
	};
	_unit setVariable [QGVAR(BFT),_newState,true];
	TRACE_1("fnc_setBFT",_newState);
	_newState
};

FUNC(moveMarker) = {
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
		case default {_unit call FUNC(deleteMarker); _pointer = [_pos,_type,_mods,_size,_scale,_visibleTo,_text,_bft] call FUNC(addMarker)};
	};
	_pointer
};

vk_fnc_addMarker = FUNC(addMarker);
vk_fnc_deleteMarker = FUNC(deleteMarker);
vk_fnc_setBFT = FUNC(setBFT);
vk_fnc_moveMarker = FUNC(moveMarker);
