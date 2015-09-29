// #define DEBUG_MODE_FULL
#include "script_component.hpp"

if (!isDedicated) then {

	[FUNC(playerCheck), 0, []] call CBA_fnc_addPerFrameHandler;
	
	LOG("PostInit Started");
			
	GVAR(playerSide) = side player;
	
	if (vehicle player != player) then {
		[vehicle player,"",player] call COMPILE_FILE(fnc_getIn);
	};
	
	GVAR(postInit) = true;
	LOG("PostInit complete");
			
	GVAR(markerLoopHandler) = [FUNC(markerLoop), 1, []] call CBA_fnc_addPerFrameHandler;
};