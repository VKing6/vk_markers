//#define DEBUG_MODE_FULL
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
            class addMarker {description = "Add an APP-6 marker";FILEPATCHING;};
            class createMarker {FILEPATCHING;};
            class deleteMarker {description = "Delete an APP-6 marker";FILEPATCHING;};
            class deleteMarker2 {FILEPATCHING;};
            class getIn {FILEPATCHING;};
            class killed {FILEPATCHING;};
            class markerLoop {FILEPATCHING;};
            class moveMarker {description = "Move an APP-6 marker";FILEPATCHING;};
            class playerCheck {FILEPATCHING;};
            class postInit {postInit = 1;FILEPATCHING;};
            class preInit {preInit = 1;FILEPATCHING;};
            class setBFT {description = "Set BLUFOR-tracker on a vehicle or unit";FILEPATCHING;};
        };
    };
};
