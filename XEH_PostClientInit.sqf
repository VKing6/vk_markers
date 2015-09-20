// #define DEBUG_MODE_FULL
#include "script_component.hpp"


private ["_visibleTo","_gPlayerBFT"];
if (!isDedicated) then {

	[FUNC(playerCheck), 0, []] call CBA_fnc_addPerFrameHandler;
	
	LOG("PostInit Started");
			
	GVAR(playerSide) = side player;
	
	GVAR(postInit) = true;
	LOG("PostInit complete");
			
	GVAR(markerLoopHandler) = [FUNC(markerLoop), 2, []] call CBA_fnc_addPerFrameHandler;
};