class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};
class Extended_PostInit_EventHandlers {
    class ADDON {
        clientInit = QUOTE(call COMPILE_FILE(XEH_postClientInit));
    };
};
class Extended_GetIn_Eventhandlers {
    class AllVehicles {
        class ADDON {
            clientGetIn = QUOTE(_this call COMPILE_FILE(fnc_getIn));
        };
    };
};
class Extended_Killed_EventHandlers {
    class AllVehicles {
        class ADDON {
            killed = QUOTE(_this call FUNC(killed));
        };
    };
};
