/*
    File: createMarker.sqf
    Author: VKing

    Description:
    Internal function.
    Draw markers in game.

    Returns:
    Array of markers created
*/

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_name", "_mods", ["_type",west,[west,""]], ["_size",-1,[0]], ["_scale",1,[0]], ["_visibleTo",west,[west]], ["_text","",[""]], ["_pos","def"]];
TRACE_8("Params",_name,_mods,_type,_size,_scale,_visibleTo,_text,_pos);

if (_scale <= 0) then {_scale = 1}; //prevent unscale markers
if !(IS_ARRAY(_pos)) then {_pos = [0,0,0]};
if (isNil "_type") exitWith {ERROR("Wrong faction type given")};

private ["_name2","_name3","_marker","_returnArray","_unitType"];

#define __config configFile >> "cfgMarkers"

_returnArray = [];
_scale = _scale *2;
_unitType = "normal";


// Base marker box
_marker = createMarkerLocal [_name,_pos];
_marker setMarkerSizeLocal [_scale,_scale];
if ("airunit" in _mods) then {
    _unitType = "air";
    REM(_mods,"airunit");
    switch (_type) do {
        case west: {
            _marker setMarkerColorLocal "ColorBLUFOR";
            _marker setMarkerTypeLocal "vk_b_airunit";
        };
        case east: {
            _marker setMarkerColorLocal "ColorOPFOR";
            _marker setMarkerTypeLocal "vk_o_airunit";
        };
        case independent: {
            _marker setMarkerColorLocal "ColorIndependent";
            _marker setMarkerTypeLocal "vk_n_airunit";
        };
        case "unknown": {
            _marker setMarkerColorLocal "ColorUnknown";
            _marker setMarkerTypeLocal "vk_u_airunit";
        };
    };
} else {
    if ("groundunit" in _mods) then {
        _unitType = "ground";
        REM(_mods,"groundUnit");
        switch (_type) do {
            case west: {
                _marker setMarkerColorLocal "ColorBLUFOR";
                _marker setMarkerTypeLocal "vk_b_groundunit";
            };
            case east: {
                _marker setMarkerColorLocal "ColorOPFOR";
                _marker setMarkerTypeLocal "vk_o_groundunit";
            };
            case independent: {
                _marker setMarkerColorLocal "ColorIndependent";
                _marker setMarkerTypeLocal "vk_n_groundunit";
            };
            case "unknown": {
                _marker setMarkerColorLocal "ColorUnknown";
                _marker setMarkerTypeLocal "vk_u_groundunit";
            };
        };
    } else {
        switch (_type) do {
            case west: {
                _marker setMarkerColorLocal "ColorBLUFOR";
                _marker setMarkerTypeLocal "vk_b_empty";
            };
            case east: {
                _marker setMarkerColorLocal "ColorOPFOR";
                _marker setMarkerTypeLocal "vk_o_empty";
            };
            case independent: {
                _marker setMarkerColorLocal "ColorIndependent";
                _marker setMarkerTypeLocal "vk_n_empty";
            };
            case "unknown": {
                _marker setMarkerColorLocal "ColorUnknown";
                _marker setMarkerTypeLocal "vk_u_empty";
            };
        };
    };
};
PUSH(_returnArray,_marker);
TRACE_2("Created base marker",_name,_pos);

// Text
if (_text != "") then {
    _marker = createMarkerLocal [format ["%1_text",_name],_pos];
    _marker setMarkerSizeLocal [_scale/2,_scale/2];
    _marker setMarkerTypeLocal "vk_s_text";
    _marker setMarkerColorLocal "ColorBlack";
    _marker setMarkerTextLocal _text;
    PUSH(_returnArray,_marker);
    TRACE_2("Created text marker",_name,_text);
};

// Group size
if (_size >= 0 && _size <=11 && _unitType == "normal") then {
    _marker = createMarkerLocal [format ["%1_size",_name],_pos];
    _marker setMarkerSizeLocal [_scale,_scale];
    switch (_type) do {
        case west: {
            _marker setMarkerColorLocal "ColorBLUFOR";
            _marker setMarkerTypeLocal format ["vk_b_group_%1",_size];
        };
        case east: {
            _marker setMarkerColorLocal "ColorOPFOR";
            _marker setMarkerTypeLocal format ["vk_o_group_%1",_size];
        };
        case independent: {
            _marker setMarkerColorLocal "ColorIndependent";
            _marker setMarkerTypeLocal format ["vk_n_group_%1",_size];
        };
        case "unknown": {
            _marker setMarkerColorLocal "ColorUnknown";
            _marker setMarkerTypeLocal format ["vk_o_group_%1",_size];
        };
    };
    PUSH(_returnArray,_marker);
    TRACE_2("Created group marker",_name,_size);
};

// Marker content
{ // Begin forEach
    _name2 = format ["%1_%2",_name,tolower _x];
    switch (_type) do {
        case west: {
            _marker setMarkerColorLocal "ColorBLUFOR";
            _name3 = format ["vk_b_%1",tolower _x];
        };
        case east: {
            _marker setMarkerColorLocal "ColorOPFOR";
            _name3 = format ["vk_o_%1",tolower _x];
        };
        case independent: {
            _marker setMarkerColorLocal "ColorIndependent";
            _name3 = format ["vk_n_%1",tolower _x];
        };
        case "unknown": {
            _marker setMarkerColorLocal "ColorUnknown";
            _name3 = format ["vk_u_%1",tolower _x];
        };
    };
    if (_unitType != "normal") then {
        _name3 = format ["vk_v_%1",tolower _x];
    };
    if !(isClass (__config >> _name3)) then {
        _name3 = format ["vk_s_%1",tolower _x];
    };
    if !(isClass (__config >> _name3)) then {
        TRACE_1("Missing marker class",_name3);
    } else {
        _marker = createMarkerLocal [_name2,_pos];
        _marker setMarkerTypeLocal _name3;
        _marker setMarkerSizeLocal [_scale,_scale];
    };
    PUSH(_returnArray,_marker);
    TRACE_2("Created marker",_name2,_pos);
} forEach _mods;


TRACE_1("",_returnArray);

_returnArray
