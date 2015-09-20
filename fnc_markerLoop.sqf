#include "script_component.hpp"
private ["_markerArray","_markerName","_unit","_markerData","_visibleTo","_doUpdate","_doCreate","_markerUnit"];

{ // Begin ForEach; Create and update dynamic markers
	_unit = _x;
	_markerArray = _unit getVariable QGVAR(markerArray);
	_markerData = _unit getVariable QGVAR(markerData);
	_markerName = _markerData select 0;
	_markerUnit = _markerData select 7;
	_markerBFT = _unit getVariable QGVAR(markerBFT);
	// TRACE_5("",_unit,_markerData,_markerArray,_visibleTo,_markerBFT);
	_doUpdate = false;
	_doCreate = false;
	
	if (!isNil "_markerData") then {
		_visibleTo = _markerData select 5;
		if (GVAR(playerSide) in _visibleTo) then {
			if (!isNil "_markerarray") then {
                if (getMarkerPos _markerName distance2D getPos _markerUnit > 10) then {
                    _doUpdate = true;
                };
                TRACE_2("Update marker", _unit, _markerArray);
				if (_doUpdate) then {
					{
						_x setMarkerPosLocal (getpos _unit);
					} forEach _markerArray;
				};
			} else {
				if (!isNil "_markerData") then {
                    _doCreate = true;
                    TRACE_2("Create marker", _unit, _markerData);
					if (_doCreate) then {
						_pos = getPos _unit;
						PUSH(_markerData,_pos);
						_markerArray = _markerData call FUNC(createMarker);
						_unit setVariable [QGVAR(markerArray),_markerArray];
					};
				};
			};
		};
	};
} forEach allUnits + vehicles;