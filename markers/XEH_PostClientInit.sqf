//#define DEBUG_MODE_FULL
#include "script_component.hpp"


[] spawn {
	private ["_visibleTo","_gPlayerBFT"];
	if (!isDedicated) then {
		if (isNull player) then {
			waitUntil {!isNull player};
		};
		LOG("PostInit Started");
		
		GVAR(playerSide) = side player;
		GVAR(playerBFT) = false;
		
		_gPlayerBFT = player getVariable QGVAR(BFT);
		if (isNil "_gPlayerBFT") then {
			GVAR(gPlayerBFT) = false;
		} else {
			GVAR(gPlayerBFT) = _gPlayerBFT;
		};

		if (vehicle player != player) then {
			[vehicle player,"",player] call COMPILE_FILE(fnc_getIn);
		};

		{ // Create static markers
			_visibleTo = _x select 5;
			if (GVAR(playerSide) in _visibleTo) then {
				TRACE_1("Creating static marker",_x);
				_x call FUNC(createMarker);
			};
		} forEach GVAR(static_markers_2);
		TRACE_1("Created local static markers",GVAR(static_markers_2));
		
		GVAR(postInit) = true;
		LOG("PostInit complete");
		
		GVAR(static_markers) = GVAR(static_markers_2);
		publicVariable QGVAR(static_markers);
		
		[] call FUNC(markerLoop);
		// [] call FUNC(mapLoop);
	};
};
