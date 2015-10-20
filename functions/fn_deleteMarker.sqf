// #define DEBUG_MODE_FULL
#include "script_component.hpp"

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
