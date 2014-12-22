class cfgVehicles {
	class Logic;
	class Module_F: Logic {
		class ArgumentsBaseUnits {
			ckass Units;
		};
		class ModuleDescription {
			class AnyBrain;
		};
	};
	class vk_markerModule: Module_F {
		scope = 2;
		displayName = "APP-6A marker";
		icon = "\x\vk_mods\addons\markers\data\s\igConvert.paa"
		category = "Intel";
		
		function = "vk_fnc_markerModule";
		functionPriority = 3;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 1;
		
		class Arguments: ArgumentsBaseUnits {
		
		};
		
		class ModuleDescription: ModuleDescription {
		
		};
		
	};
};