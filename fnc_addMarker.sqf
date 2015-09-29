// #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_name", "_unit", "_type", "_mods", ["_groupSize",-1,[0]], ["_scale",1,[0]], ["_visibleTo",nil,[west,[],""]], ["_text","",[""]], ["_bft",false,[false]]];
TRACE_9("Params",_name,_unit,_type,_mods,_groupsize,_scale,_visibleto,_text,_bft);

private ["_pos","_data","_uTypes"];

// Delete duplicates
_mods = _mods arrayIntersect _mods;
#define REM(arr,var) arr deleteAt (arr find var)

// No caps!
{_mods set [_forEachIndex,toLower _x]} forEach _mods;


_uTypes = ["groundunit","uaaa","uapc","uapc_w","uarty","uarty_sp","uifv","uifv_w","umedic","umlrs","umortar","umortar_sp","usp","utank","utank_h","utank_m","utank_l","uutility","uwheeled"];

// Alternate spellings
{
	switch (_x) do {
		case "infantry": {_mods set [_foreachIndex, "inf"]};
		case "armour": {_mods set [_foreachIndex, "armor"]};
		case "motorized": {_mods set [_foreachIndex, "motor"]};
		case "artillery": {_mods set [_foreachIndex, "arty"]};
		case "engineer": {_mods set [_foreachIndex, "eng"]};
		case "maintenance": {_mods set [_foreachIndex, "maint"]};
		case "installation": {_mods set [_foreachIndex, "inst"]};
		case "medical": {_mods set [_foreachIndex, "medic"]};
		case "fixedwing": {_mods set [_foreachIndex, "fixed"]};
		case "rotwing": {_mods set [_foreachIndex, "rotary"]};
		case "unitair": {_mods set [_foreachIndex, "airunit"]};
		case "airvehicle": {_mods set [_foreachIndex, "airunit"]};
		case "unitland": {_mods set [_foreachIndex, "groundunit"]};
		case "unitground": {_mods set [_foreachIndex, "groundunit"]};
		case "landunit": {_mods set [_foreachIndex, "groundunit"]};
	};
} forEach _mods;

// Air unit markers
if ("airunit" in _mods) then {
	if ("fixed" in _mods) then {
		REM(_mods,"fixed");
	};
	if (!("rotary" in _mods) && "attack" in _mods) then {
		REM(_mods,"attack");
		_mods pushBack "fattack";
	};
	if (!("rotary" in _mods) && "cargo" in _mods) then {
		REM(_mods,"cargo");
		_mods pushBack "fcargo";
	};
	if (!("rotary" in _mods) && "uav" in _mods) then {
		REM(_mods,"uav");
		_mods pushBack "fuav";
	};
};

// Ground unit markers
if ("groundunit" in _mods) then {
	if ("armor" in _mods) then {
		if (count (["arty","mortar","aaa","aa"] arrayIntersect _mods) > 0 && !("wheeled" in _mods)) then {
			_mods pushBack "usp";
		} else {
			if !(count (["ifv","inf"] arrayIntersect _mods) > 0) then {
				_mods pushBack "utank";
			};
		};
	};
	if ("wheeled" in _mods) then {
		_mods pushBack "uwheeled";
	};
	if ("inf" in _mods && !("ifv" in _mods)) then {
		if ("armor" in _mods) then {
			if ("wheeled" in _mods) then {
				_mods pushBack "uapc_w";
			} else {
				_mods pushBack "uapc";
			};
		} else {
			_mods pushBack "uutility";
		};
	};
	if ("ifv" in _mods) then {
		if ("wheeled" in _mods) then {
			_mods pushBack "uifv_w";
		} else {
			_mods pushBack "uifv";
		};
	};
	if ("arty" in _mods) then {
		if (count (["uwheeled","usp"] arrayIntersect _mods) > 0) then {
			_mods pushBack "uarty_sp";
		} else {
			_mods pushBack "uarty";
		};
	};
	if ("mortar" in _mods) then {
		if (count (["uwheeled","usp"] arrayIntersect _mods) > 0) then {
			_mods pushBack "umortar_sp";
		} else {
			_mods pushBack "umortar";
		};
	};
	if ("aaa" in _mods || "aa" in _mods) then {
		if (count (["uwheeled","usp"] arrayIntersect _mods) > 0) then {
			_mods pushBack "uaaa_sp";
		} else {
			_mods pushBack "uaaa";
		};
	};
	if ("medic" in _mods) then {
		_mods pushBack "umedic";
	};
	if ("mlrs" in _mods) then {
		_mods pushBack "umlrs";
	};
	if ("utility" in _mods && !("uutility" in _mods)) then {
		_mods pushBack "uutility";
	};
	if ("heavy" in _mods) then {
		_mods pushBack "utank_h";
	};
	if ("medium" in _mods) then {
		_mods pushBack "utank_m";
	};
	if ("light" in _mods) then {
		_mods pushBack "utank_l";
	};
	
	// Remove unused types
	_mods = _mods arrayIntersect _uTypes;
};

// Special graphics &&/|| combinations
if (("sam" in _mods || "aaa" in _mods) && !("aa" in _mods)) then {
	_mods pushBack "aa";
};
if ("aa" in _mods && "armor" in _mods) then {
	REM(_mods,"armor");
	_mods pushBack "armoraa";
};
if ("eng" in _mods && "armor" in _mods) then {
	REM(_mods,"eng");
	_mods pushBack "engarmor";
};
if ("maint" in _mods && "armor" in _mods) then {
	REM(_mods,"maint");
	_mods pushBack "maintarmor";
};
if ("medic" in _mods && ("fixed" in _mods || "rotary" in _mods )) then {
	REM(_mods,"medic");
	_mods pushBack "airmed";
};
if ("sof" in _mods && ("fixed" in _mods || "rotary" in _mods )) then {
	REM(_mods,"sof");
	_mods pushBack "airsof";
};
if ("reduced" in _mods && "reinforced" in _mods) then {
	REM(_mods,"reduced");
	REM(_mods,"reinforced");
	_mods pushBack "rereduced";
};
if ("damaged" in _mods) then { // Ensure graphics is last i.e. on top
	REM(_mods,"damaged");
	_mods pushBack "damaged";
};
if ("destroyed" in _mods) then {
	REM(_mods,"destroyed");
	_mods pushBack "destroyed";
};

if (IS_STRING(_type)) then {
	_type = toLower _type;
	switch (_type) do {
		case "west": {_type = west};
		case "blufor": {_type = west};
		case "east": {_type = east};
		case "opfor": {_type = east};
		case "independent": {_type = independent};
		case "resistance": {_type = independent};
	};
};

if (IS_ARRAY(_unit)) then { // Positions
    _pos = [_unit select 0, _unit select 1, -5];
    _unit = createVehicle ["vk_helper_vehicle",_pos, [], 0, "NONE"];
	hideObjectGlobal _unit;
	[0, {_this enableSimulationGlobal false}, _unit] call CBA_fnc_globalExecute;
    if (isNil "_visibleTo") then {
        _visibleTo = [west, east, independent];
    };
    TRACE_3("Convert array to helper unit",_unit, getpos _unit, _visibleTo);
};


if (isNil "_visibleTo") then {
    _visibleTo = [side _unit];
    // TRACE_1("Default",_visibleTo);
};
if (!IS_ARRAY(_visibleTo)) then {
    _visibleTo = [_visibleTo];
    // TRACE_1("toArray",_visibleTo);
};
_data = [_name,_mods,_type,_groupSize,_scale,_visibleTo,_text,_unit];
TRACE_1("",_data);
_unit setVariable [QGVAR(markerData),_data,true];
_unit setVariable [QGVAR(markerBFT),_bft,true];

_name
