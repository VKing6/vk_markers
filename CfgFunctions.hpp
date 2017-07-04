#define DEBUG_MODE_FULL
#include "script_component.hpp"
#ifdef DEBUG_MODE_FULL
    #define FILEPATCHING recompile = 1
#else
    #define FILEPATCHING
#endif

class cfgFunctions {
    class VK {
        class markers {
            file = "x\vk_mods\addons\markers\functions";
            class addMarker {FILEPATCHING; description = "Add an APP-6 marker";};
            class convertBFT {FILEPATCHING;};
            class createMarker {FILEPATCHING;};
            class deleteMarker {FILEPATCHING; description = "Delete an APP-6 marker";};
            class deleteMarker2 {FILEPATCHING;};
            class killed {FILEPATCHING;};
            class markerLoop {FILEPATCHING;};
            class moveMarker {FILEPATCHING; description = "Move an APP-6 marker";};
            class playerCheck {FILEPATCHING;};
            class postInit {FILEPATCHING; postInit = 1;};
            class preInit {FILEPATCHING; preInit = 1;};
            class setBFT {FILEPATCHING; description = "Set BLUFOR-tracker on a vehicle or unit";};
        };
    };
};
