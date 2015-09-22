// #define DEBUG_MODE_FULL
#include "script_component.hpp"


private ["_gPlayerBFT"];
if (!isDedicated) then {

	[FUNC(playerCheck), 0, []] call CBA_fnc_addPerFrameHandler;
	
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
	
	GVAR(postInit) = true;
	LOG("PostInit complete");
			
	GVAR(markerLoopHandler) = [FUNC(markerLoop), 2, []] call CBA_fnc_addPerFrameHandler;
};