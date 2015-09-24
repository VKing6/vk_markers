# APP-6 NATO-standard tactical markers
**By VKing** (kauestad at gmail)
(c) 2012-2015

## 1. Licence

You may:

* Redistribute this package freely assuming proper credit is given and this readme is included.
* Reverse-engineer the scripts in this addon for the purpose of learning.
	
You may _**not**_:

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
* NouberNou
* And the [United Operations](http://unitedoperations.net) community


## 2. Functions

### **vk_fnc_addMarker**

Creates an APP-6 marker at a position or attached to a unit.

#### Parameters

1. Marker name _[String]_
2. Position _[Position]_ or unit/vehicle _[Unit]_
	- If a position is given the marker will be static. If a unit or vehicle is given marker will track that object.
3. Marker type _[Side or string]_
	- Type of marker. BLUFOR/West, OPFOR/East, or Independent/Resistance for blue, red, or green markers, respectivly. To use unknown/yellow style use "unknown".
4. Marker composition _[Array of Strings]_
	- See section 8 below for a list of markers
5. OPTIONAL: Group size _[Number]_ 0-11, from fire team to army group. -1 for none.
6. OPTIONAL: Marker scale _[Number]_ default 1
7.  OPTIONAL: Visible to _[Side or array of sides]_
	- Define which sides should be able to see this marker. Default for static markers is all. For tracking markers this is the same side as the unit. Markers put on empty units do not show up unless you set this.
8.  OPTIONAL: Marker text _[String]_
9.  OPTIONAL: Marker is a BLUFOR-tracker marker _[Bool]_

#### Returns

* Nothing.

#### Examples

* ["m1", bradley1, west, ["recon","arty","armor","2"], 3] call vk_fnc_addMarker;
* ["m2", getPos HQ, east, ["hq","armor","III"],5,2, [west,east],"Regimental CP"] call vk_fnc_addMarker;
* ["m3", heli3, independent, ["airunit","rotary","attack"],-1,1, [independent], "", true] call vk_fnc_addMarker;
    

### **vk_fnc_deleteMarker**

Deletes a marker.

#### Parameters

1. Marker name _[String]_

#### Returns
* Nothing.

#### Examples
* ["m1"] call vk_fnc_deleteMarker;


## 3. Special combinations

Some combinations of composition markers will create special combinations to make the marker more readable. For example, adding the _armor_ and _engineer_ markers together will change the engineering marker to fit inside the ovaloid armor marker.

The following combinations are implemented:
* _armor_ and _aa_
* _armor_ and _engineer_
* _armor_ and _maint_
* _medic_ and _fixed_ or _rotary_
* _sof_ and _fixed_ or _rotary_
* _reduced_ and _reinforced_


## 4. Vehicle markers

In addition to markers denoting groups, there are also markers for individual vehicles. 

For air vehicles add the _airunit_ type. For ground vehicles add the _groundunit_ type. Otherwise proceed as normal and the game should figure out making the vehicle you want.


## 5. BLUFOR tracker

Markers flagged as BLUFOR tracker (BFT) markers can only be seen by units inside vehicles that are equipped with BFT systems.

Vehicles can be equipped with BFT by setting the variable **vk_mods_markers_bft** to true.

By setting vk_mods_markers_bft true on a player unit (not vehicle), the player can see all BFT markers at all times.


## 6. Behaviour of killed units:

A marker attached to a unit that's killed or destroyed will by default be removed.
This can be changed by setting the variable **vk_mods_markers_killedType** for the unit, or the variable **vk_mods_markers_gKilledType** globally.

The available options are:
* _remove_ - Default. Deletes marker.
* _static_ - Marker is recreated as a static marker where the unit died.
* _destroy_ - As static, but a black 'X' is added to the marker to represent a destroyed unit.
	
In a mission with respawn, the killedType can be set to _nil_ and the marker should be kept with the unit when it respawns, but this functionality is untested.

## 7. Changelog

* 300
	- Initial conversion from Arma 2.
	- Added Independent style markers.
* 301
	- Some backend cleanup.
	- Improved readability of some symbols.
	- Added "cargo" symbol for air groups and air vehicles.
	- Added "fighter" symbol for air vehicles.
	- Added markers for air vehicles
		- To use add "airunit" to the mod array.
	- Added unknown style markers
		- Use "unknown" as type instead of a side.
* 302
	- Added missing unknown installation icon.
* 303
	- Fixed an issue that would occationally cause RPT spam when deleting or hiding markers.
* 304
	- Fixed a race condition that could prevent variables from being properly initialized.
* 305
	- Fixed an issue that could create errors when loading a mission.
	- Fixed an issue that would spam chat with error messages.
* 400
	- Simplified code
		- Removed BFT functionality.
		- Changed static markers to work as unit markers attached to spawned helper vehicle.
* 401
	- Reimplemented BFT
		- Removed functionality that let different seats in a vehicle have BFT. Vehicles are now all or nothing.
	- Tweaked Air assault and Amphibious graphics.
	- Added ground vehicle markers.
	
	
## 8. List of valid markers

### Group symbols

```
aa
aaa
airassault
airborne
amphib
at
armor/armour
arty
eng/engineer
hq
ifv
inf/infantry
inst/installation
maint/maintenance
medic/medical
mlrs
mortar
motor/motorized
recon
sam
signals
sf
sof
supply
wheeled

fixed/fixedwing
rotary/rotwing
attack
cargo
rescue
scout
uav
utility

heavy
medium
light
vstol

damaged
destroyed
reduced
reinforced
```

In addition, the numbers 1-9, letters a-m (except i), and roman numerals I-VI can be added to the array (as strings).

### Vehicle symbols

These symbols are automatically generated when the _airunit_ or _groundunit_ symbol is added in combinations with the above markers, but can be added directly if wanted.

```
uaaa
uaaa_sp
uapc
uapc_w
uarty
uarty_sp
uifv
uifv_w
umedic
umlrs
umortar
umortar_sp
usp
utank
utank_h
utank_m
utank_l
uutility
uwheeled
```
