/*
    File: addMarker.sqf
    Author: VKing

    Description:
    Create an APP-6 marker at a position or attached to a unit.
    See github.com/VKing6/vk_markers for more information.

    Parameter(s):
        0: <object> or <position> position to place marker or unit to attach to
        1: <side> or <string> type of marker (blufor, opfor, independent. "unknown")
        2: <array> composition of marker (see readme)
        3: (Optional) <scalar> group size (0-11, -1 for none)
        4: (Optional) <scalar> marker scale
        5: (Optional) <array> sides marker is visible to
        6: (Optional) <string> marker text
        7: (Optional) <bool> blufor-tracking marker
        8: (Optional) <string> killed type

    Returns:
    Marker vehicle handle

    Examples
    * _m1 = [bradley1, west, ["recon","arty","armor","2"], 3] call vk_fnc_addMarker;
    * _marker2 = [getPos HQ, east, ["hq","armor","III"],5,2, [west,east],"Regimental CP"] call vk_fnc_addMarker;
    * _heliMarker = [heli3, independent, ["airunit","rotary","attack"],-1,1, [independent], "", true] call vk_fnc_addMarker;
*/

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

private ["_name","_unit","_type","_mods","_groupSize","_scale","_visibleTo","_text","_bft","_killedType"];

if (typeName (_this select 0) == "OBJECT" || typeName (_this select 0) == "ARRAY") then {
    LOG("OBJECT/ARRAY");
    params ["_unit2", "_type2", "_mods2", ["_groupSize2",-1,[0]], ["_scale2",1,[0]], ["_visibleTo2",nil,[west,[],""]],
        ["_text2","",[""]], ["_bft2",false,[false]],["_killedType2",nil,[""]]];
    _name = format ["%1",_unit2];
    _unit=_unit2; _type=_type2; _mods=_mods2; _groupSize=_groupSize2;
    _scale=_scale2; _text=_text2; _bft=_bft2;
    if (!isNil "_visibleTo2") then {_visibleTo = _visibleTo2};
    if (!isNil "_killedType2") then {_killedType = _killedType2;};
} else {
    LOG("STRING");
    params ["_name2", "_unit2", "_type2", "_mods2", ["_groupSize2",-1,[0]], ["_scale2",1,[0]],
        ["_visibleTo2",nil,[west,[],""]], ["_text2","",[""]], ["_bft2",false,[false]],["_killedType2",nil,[""]]];
    _name=_name2; _unit=_unit2; _type=_type2; _mods=_mods2; _groupSize=_groupSize2;
    _scale=_scale2; _text=_text2; _bft=_bft2;
    if (!isNil "_visibleTo2") then {_visibleTo = _visibleTo2};
    if (!isNil "_killedType2") then {_killedType = _killedType2;};
};
TRACE_9("Params 1",_name,_unit,_type,_mods,_groupsize,_scale,_visibleto,_text,_bft);
TRACE_1("Params 2",_killedType);

private ["_data","_uTypes"];

// Delete duplicates
_mods = _mods arrayIntersect _mods;
#define REM(arr,var) arr deleteAt (arr find var)

// No caps!
{_mods set [_forEachIndex,toLower _x]} forEach _mods;

_uTypes = ["groundunit","uaaa","uapc","uapc_w","uarty","uarty_sp","uifv","uifv_w","umedic","umlrs",
    "umortar","umortar_sp","usp","utank","utank_h","utank_m","utank_l","uutility","uwheeled","damaged","destroyed",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "II", "III", "IV", "V", "VI"];

// Alternate spellings
{
    switch (_x) do {
        case "infantry": {_mods set [_forEachIndex, "inf"]};
        case "armour": {_mods set [_forEachIndex, "armor"]};
        case "motorized": {_mods set [_forEachIndex, "motor"]};
        case "artillery": {_mods set [_forEachIndex, "arty"]};
        case "engineer": {_mods set [_forEachIndex, "eng"]};
        case "maintenance": {_mods set [_forEachIndex, "maint"]};
        case "installation": {_mods set [_forEachIndex, "inst"]};
        case "medical": {_mods set [_forEachIndex, "medic"]};
        case "fixedwing": {_mods set [_forEachIndex, "fixed"]};
        case "rotwing": {_mods set [_forEachIndex, "rotary"]};
        case "unitair": {_mods set [_forEachIndex, "airunit"]};
        case "airvehicle": {_mods set [_forEachIndex, "airunit"]};
        case "unitland": {_mods set [_forEachIndex, "groundunit"]};
        case "unitground": {_mods set [_forEachIndex, "groundunit"]};
        case "landunit": {_mods set [_forEachIndex, "groundunit"]};
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
    _unit = createVehicle ["vk_helper_vehicle",[_unit select 0, _unit select 1, -5], [], 0, "NONE"];
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
if !(isNil "_killedType") then {
    _unit setVariable [QGVAR(killedType),_killedType,true];
};

_unit
