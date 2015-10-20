// #define DEBUG_MODE_FULL
#include "script_component.hpp"

params ["_unit"];
TRACE_1("HideMarker Params",_unit);
private ["_markerData"];
_markerData = _unit getVariable [QGVAR(markerData),[]];
[QGVAR(deleteMarker),[_markerData select 0, _markerData select 1]] call CBA_fnc_GlobalEvent;
_unit setVariable [QGVAR(markerArray),nil,false];
TRACE_2("Deleting marker from unit",_unit,_markerData select 0);