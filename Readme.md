# APP-6A NATO-standard tactical markers
**By VKing** (kauestad at gmail)
(c) 2012-2015

## Licence

You may:

* Redistribute this package freely assuming proper credit is given and this readme is included.
* Reverse-engineer the scripts in this addon for the purpose of learning.
	
You may _not_:

* Reproduce or modify any graphical content in this addon in any way without permission from the author.
* Use this addon or any content therein for commercial or military purposes.
* Assume there is any warranty.

Thanks to:
* Xeno
* Sickboy
* Jake Peril
* Krause
* Yaxxo
* Falcon
* Impulse 9
* And the United Operations community


## Functions

### vk_fnc_addMarker

Creates an APP-6A marker at a position or attached to a unit.

#### Parameters

1. Marker name _[String]_
2. Position _[Position]_ or unit/vehicle _[Unit]_
	- If a position is given the marker will be static. If a unit or vehicle is given marker will track that object.
3. Marker type _[Side or string]_
	- Type of marker. BLUFOR/West, OPFOR/East, or Independent/Resistance for blue, red, or green markers, respectivly. To use unknown/yellow style use "unknown".
4. Marker composition _[Array of Strings]_
	- Land group types: aa, aaa, airassault, armor, artillery, at, damaged, destroyed, engineer, hq, ifv, infantry, inst, maint, medic, mlrs, mortar, motorized, recon, reduced, reinforced, sam, signals, sf, sof, supply, wheeled
	- Air group/vehicle types: airunit, attack, cargo, fighter, fixed (wing), heavy, light, medium, rescue, rotary, scout, uav, utility, vstol
	- Left side types: a-m, 1-9, I-VI (symbol on the left side of the marker)
5. OPTIONAL: Group size _[Number]_ 0-11, from fire team to army group. -1 for none.
6. OPTIONAL: Marker scale _[Number]_ default 1
7.  OPTIONAL: Visible to _[Side or array of sides]_
	- Define which sides should be able to see this marker. Default for static markers is all. For tracking markers this is the same side as the unit. Markers put on empty units do not show up unless you set this.
8.  OPTIONAL: Marker text _[String]_
9.  OPTIONAL: Marker is a BLUFOR-tracker marker _[Bool]_

#### Returns

* Nothing.

#### Examples

* ["m1",bradley1,west,["recon","arty","armor"],3] call vk_fnc_addMarker;
* ["m2",getPos HQ,east,["hq","armor"],5,2,_[west,east],"Enemy Regimental HQ"]_ call vk_fnc_addMarker;
* ["m3",heli3,independent,["airunit","rotary","attack"],-1,1,[independent],"",true] call vk_fnc_addMarker;


### vk_fnc_deleteMarker

Deletes a marker.

#### Parameters

* Marker name _[String]_

#### Returns
* Nothing.

#### Examples
1. ["m1"] call vk_fnc_deleteMarker;

## BLUFOR tracker

Markers flagged as BLUFOR tracker (BFT) markers can only be seen by units inside vehicles that are equipped with BFT systems.
Vehicles can be equipped with BFT by setting the variable **vk_mods_markers_bft** to true

By setting vk_mods_markers_bft true on a player unit (not vehicle), the player can see all BFT markers at all times.


## Behaviour of killed units:

A marker attached to a unit that's killed or destroyed will by default be removed.
This can be changed by setting the variable **vk_mods_markers_killedType** for the unit, or the variable **vk_mods_markers_gKilledType** globally.
The available options are:

* remove - Default. Deletes marker.
* static - Marker is recreated as a static marker where the unit died.
* destroy - As static, but a black 'X' is added to the marker to represent a destroyed unit.
	
In a mission with respawn, the killedType can be set to _nil_ and the marker should be kept with the unit when it respawns, but this functionality is untested.

## Changelog

* 300
	- Initial conversion from Arma 2.
	- Added Independent style markers.

* 301
	* Some backend cleanup.
	* Improved readability of some symbols.
	* Added "cargo" symbol for air groups and air vehicles.
	* Added "fighter" symbol for air vehicles.
	* Added markers for air vehicles
		- To use add "airunit" to the mod array.
	* Added unknown style markers
		- Use "unknown" as type instead of a side.
	
* 302
	* Added missing unknown installation icon.

* 303
	* Fixed an issue that would occationally cause RPT spam when deleting or hiding markers.

* 304
	* Fixed a race condition that could prevent variables from being properly initialized.

* 305
	* Fixed an issue that could create errors when loading a mission.
	* Fixed an issue that would spam chat with error messages.

* 400
	* Simplified code
		- Removed BFT functionality.
		- Changed static markers to work as unit markers attached to spawned helper vehicle.

* 401
	* Reimplemented BFT
		- Removed functionality that let different seats in a vehicle have BFT. Vehicles are now all or nothing.
