# godot-toolbox-project
![Godot Toolbox Project](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo256.png "Godot Toolbox Project")


Project template for the [Godot Game Engine](https://godotengine.org/) featuring a main menu, audio and keybinding settings, a pause screen and some demo 2D games.
Contains easy-to-use components for UI, state management, persistent storage, and the game itself.


## Contents
* Menu, UI and Theme
	* Menu
	* GameUI
	* Components
* Settings
	* Key Bindings
	* Audio
* Game Modules
	* Levels
	* Signals
	* Entities
* Demo Levels
* Global Managers
	* D for Debug
	* C for Config
	* PersistenceMngr
	* ScreenMngr
	* SignalMngr
	* StateMngr

## Menu, UI and Theme

### Menu

The game comes with a basic menu that lets you navigate through:
* MainMenu
* OptionsMenu
* OptionsAudioMenu
* OptionsControlsMenu

These are all implemented as Screens *[scenes/screens/]*.

### GameUI

Additionally, there are also in-game ui components *[scenes/game/]* like:

* PauseMenu
* GameOver
* A GameUI equipped with a healthbar and a score indicator

### Theme

The Menu, the GameUI and all sub-components use a single theme resource.
It is globally used and can be found in *[assets/theme.tres]*

### Components

Check *[scenes/ui/components]* for re-useable components.
All menu-relevant components can be found in *[scenes/ui/menu]*

## Settings

TODO

### Key Bindings

TODO

### Audio

TODO

## Game Modules

The best way to explore the game modules is to play the levels.
There are several top-level concepts and some base scenes suited for inheriting.

### Levels
The world is broken up into levels, aka sub scenes located in *[scenes/game/levels/]*. In this demo each level showcases a different map and mechanic and they can be changed by the press of a button

### Signals
Some global signals coordinate game and level events.
They can be found in *[scripts/globals/Config.gd]*

```gdscript
signal game_started()
signal game_paused(pause_on)
signal game_ended()
signal level_started(root_node)
signal level_restarted()
```

They can be used to initialize levels, respawn enemies, disable interactions, ...

```gdscript
# connect to global Signal
func _ready():
	SignalMngr.connect("level_started", self, "_on_level_started")

# On level started
func _on_level_started(_level):
	respawn()
```
### Entities
The entity is a scene and script hierarchy to refactor common behavior from Enemies and the Player.

Entities are associated with:
* **health** Has max_health, a signal ```health_changed(health_now, health_max)``` and an overwritable ```_on_die()```.
* **team** Can be compared to another entities team for interactions, e.g. damage.
* **contact** an ```Area2D``` additionally to the physics collision, to trigger game-events between Entities. Query ```Entity.contacts``` to get a list of currently active contacts

The Player is additionally equipped with:
* a ```Camera2D```
* funcs for walking ```process_walk(delta)```, ```process_walk_topdown(delta)```, ```process_walk_platformer(delta)```
* funcs for jumping ```process_jump```
* funcs for controlling the AnimatedSprite
* two ```LevelCameras```

In this demo, the Player provides **2 control schemes**, **2 different cameras** and **4 skins**.

## Demo Levels

A total of 5 levels with different settings can be found, some with specials. Some of the most notable:
* Platformers
	* darkness and light *[scenes/game/levels/PlatformerDarkCave]*
	* a parallax background *[scenes/game/levels/PlatformerParallax]*
	* a [3x3 autotile](https://kidscancode.org/godot_recipes/2d/autotile_intro/) TileMap *[scenes/game/levels/PlatformerAutotile]*
* Platformers
	* an isometric TileMap *[scenes/game/levels/TopDownIsometric]*
	* a [3x3 autotile](https://kidscancode.org/godot_recipes/2d/autotile_intro/) TileMap *[scenes/game/levels/TopDownMysteryDungeon]*

## Global Managers
For global access, these Managers are put into the projects autoload.

### D for Debug

Contains custom debug print functions.
Each print has a topic (of enum D.LogCategory or a string) and D.LogLevel

Use the short-hand fcts ```D.w``` and ```D.e``` for warnings and errors.
```gdscript
# output grounded pos in topic "Player"
D.l("Player", ["grounded", position])

# equivalent
D.l(D.LogCategory.GAME, ["Savefile could not be found", state])
D.w(D.LogCategory.GAME, ["Savefile could not be found", state], LogLevel.WARN)
```
The Config file allows filtering the debug output by topic and LogLevel

### C for Config

Contains global settings that can be accessed
```gdscript
health = 100 if C.is_debug else 3
```
Of special interest is the enum ```C.Screen``` and their respective scenes ```C.SCREEN_SCENES```

### PersistenceMngr

Loads and saves state on the users physical file system. Use for settings, game progression, scores, ...

Consider the following (semi-structured) state:
```gdscript
var default_audio = {
	"Master" : 80,
	"Music" : 100,
	"Effects" : 100
}
```

Given a *unique name* and the *default* state, one can add a persistent state object:

```gdscript
var state = PersistenceMngr.add_state("settingsAudio", default_audio)
state.connect("changed", self, "_on_settingsAudio_update")
```

Use flags to customize further details:
```gdscript
# saves state after every PersistenceMngr.set_state(...)
PersistenceMngr.add_state("settingsAudio", default_audio, PersistenceMngr.SAVE_ON_SET)
# also loades state immeditately
PersistenceMngr.add_state("settingsAudio", default_audio, PersistenceMngr.SAVE_ON_SET | PersistenceMngr.LOAD_ON_START)
```


The ```PersistenceMngr``` acts a global interface to query state objects using a unique id.
The getter functions as a singleton, ensuring that previously saved states are loaded from the disk.

```gdscript
# Get the current master volume setting
print(PersistenceMngr.get_state("settingsAudio"))
# outputs {"Master":80, ...}
print(PersistenceMngr.get_state("settingsAudio").Master)
# outputs 80
print(PersistenceMngr.get_state("settingsAudio.Master"))
# outputs 80
```

There is a respective ```set_val("settingsAudio", {"Master":80,...})``` to overwrite previously created states

### ScreenMngr

Basically a scene manager to globally allow switching scenes in a push and pop manner.

The screens are indexed using the enum ```C.Screen``` and the respective preloaded screens ```C.SCREEN_SCENES``` are configured in the Config file *[scripts/globals/Config.gd]*
```gdscript
# Open settings screen
ScreenMngr.push_screen(C.Screen.OptionsMenu)

# Pop back to previous screen (will be re-instantiated!)
ScreenMngr.pop_screen()
```

### SignalMngr
Global "connecting-point" for main signals like:

```gdscript
# Screen lifecycle
signal screen_entered(screen)
signal screen_left(screen)

# Game lifecycle
signal game_started
signal game_paused(pause_on)
signal game_ended

signal level_started(root_node)
signal level_restarted()
```

### StateMngr


## Assets
All assets used have been declared royalty free and useable for commercial use. Check out their original art to use and find more like these:

Seamless parallax layer sprites  
[Ansimuz](https://ansimuz.itch.io/mountain-dusk-parallax-background)

Players, Enemies, Icons  
[0x72](https://0x72.itch.io/dungeontileset-ii)

Isometric topdown tileset  
[ToxSickProductions](https://opengameart.org/users/toxsickproductionscom)

Music
[Monolith OST](https://arcofdream.itch.io/monolith-ost)

Soundeffects
[Kastenfrosch](https://freesound.org/people/Kastenfrosch/packs/10069/)
[LittleRobotSoundFactory](https://freesound.org/people/LittleRobotSoundFactory/packs/16687/)
