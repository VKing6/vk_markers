#define PREFIX vk_mods
#define COMPONENT markers

// #define DEBUG_MODE_FULL

#define CREATEHELPER(unit,pos) unit = createVehicle ["vk_helper_vehicle",[pos select 0, pos select 1, -5], [], 0, "NONE"]; \
	hideObjectGlobal unit; \
	[0, {_this enableSimulationGlobal false}, unit] call CBA_fnc_globalExecute

#include "\x\cba\addons\main\script_macros_common.hpp"