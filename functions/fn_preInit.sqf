// #define DEBUG_MODE_FULL
#include "script_component.hpp"


if (isDedicated) then {
    LOG("Server: Creating variables");
    ISNILS(GVAR(gKilledType),"remove");
    publicVariable QGVAR(gKilledType);
    GVAR(postInit) = true;
} else {
    TRACE_1("Client: Initializing variables",GVAR(gKilledType));

    if (isNil QGVAR(gKilledType)) then {
        GVAR(gKilledType) = "remove";
        publicVariable QGVAR(gKilledType);
    };
    GVAR(postInit) = false;
};

[QGVAR(deleteMarker), {_this call vk_fnc_deleteMarker2}] call CBA_fnc_addEventHandler;
