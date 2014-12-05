VK Markers by VKing (c) 2012-2015
kauestad at gmail

You may:
	Redistribute this package freely assuming proper credit is given and this readme is included.
	Reverse-engineer the scripts in this addon for the purpose of learning.
	
You may not:
	Reproduce or modify any graphical content in this addon in any way without permission from the author.
	Use this addon or any content therein for commercial or military purposes.
	Assume there is any warranty. There isn't.

Thanks to:
	Xeno
	Sickboy
	Jake Peril
	Krause
	Yaxxo
	Falcon
	Impulse 9
	And the United Operations community


/* ----------------------------------------------------------------------------
Function: vk_fnc_addMarker

Description:
	Creates an APP-6A marker at a position or attached to a unit.

Parameters:
		- Marker name [String]
		- Position [Position] or unit/vehicle [Unit]
			*If a position is given the marker will be static. If a unit or vehicle is given marker will track that object.
		- Marker type [Side or string]
			*Type of marker. Blue, red, or green for BLUFOR/West, OPFOR/East, or Independent/Resistance, respectivly. To use unknown/yellow style use "unknown".
		- Marker composition [Array of Strings]
			- Land group types: aa, aaa, airassault, armor, artillery, at, damaged, destroyed, engineer, hq, ifv, infantry, inst, maint, medic, mlrs, mortar, motorized, recon, reduced, reinforced, sam, signals, sf, sof, supply, wheeled
			- Air group/vehicle types: airunit, attack, cargo, fighter, fixed (wing), heavy, light, medium, rescue, rotary, scout, uav, utility, vstol
			- Left side types: a-m, 1-9, I-VI (symbol on the left side of the marker)
		- OPTIONAL: Group size [Number] 0-11
		- OPTIONAL: Marker scale [Number]
		- OPTIONAL: Visible to [Side or array of sides]
			*Define which sides should be able to see this marker. Default for static markers is all. For tracking markers this is the same side as the unit (note markers put on empty units do not show up unless you set this)
		- OPTIONAL: Marker text [String]
		- OPTIONAL: Marker is a BLUFOR-tracker marker (Only applicable to markers attached to units) [Bool]

Returns:
		Nothing.

Examples:
		(begin example)
				["m1",bradley1,west,["recon","arty","armor"],3] call vk_fnc_addMarker;
		(end)
		(begin example)
				["m2",getPos HQ,east,["hq","armor"],5,2,[west,east],"Enemy Regimental HQ"] call vk_fnc_addMarker;
		(end)
		(begin example)
				["m3",heli3,independent,["airunit","rotary","attack"],-1,1,[independent],"",true] call vk_fnc_addMarker;
		(end)

Author:
	(c) VKing, 2012-2015
---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
Function: vk_fnc_deleteMarker

Description:
	Deletes a previously added marker.

Parameters:
		- Marker name [String]

Returns:
		Nothing.

Examples:
		(begin example)
				["m1"] call vk_fnc_deleteMarker;
		(end)

Author:
	(c) VKing, 2012-2015
---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
BLUFOR tracker

Markers flagged as BLUFOR tracker (BFT) markers can only be seen by units inside vehicles that are equipped with BFT systems.
Vehicles can be equipped with BFT by giving it the variable vk_mods_markers_bft, with the following alternatives:
	- It can be set to boolean true, in which case all positions in the vehicle can see BFT markers.
	- It can set as the following array of bools: [Commander,Gunner,Driver,Cargo,Cargo group leader]. E.g.: _vehicle setVariable ["vk_mods_markers_bft",[true,false,false,true,true],true];
		In the example above, the commander and any group leaders in the cargo can see BFT markers. The gunner, driver, and any non-leaders in the cargo can not.
		
By setting vk_mods_markers_bft true on a player unit (not vehicle), the player can see all BFT markers at all times.

---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
Behaviour of killed units:

A marker attached to a unit that's killed or destroyed will by default be removed.
This can be changed by setting the variable "vk_mods_markers_killedType" for the unit, or the variable "vk_mods_markers_gKilledType" globally.
The available options are:
	"remove" - Default. Deletes marker.
	"static" - Marker is recreated as a static marker where the unit died.
	"destroy" - As static, but a black 'X' is added to the marker.
In a mission with respawn, the killedType can be set to anything else and the marker should be kept with the unit when it respawns, but this functionality is currently untested.

---------------------------------------------------------------------------- */