# Godot Toolbox Project

![Godot Toolbox Project](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo256.png "Godot Toolbox Project")

Project template for the [Godot Game Engine](https://godotengine.org/) taking care of things so you can focus on the game.

Features a main menu, extensive settings, in-game UI, a custom and easy-to-change theme and some demo levels.

Additionally there are some re-usable components for UI, state management, persistent storage, and the game itself.

Both controller (Control menu) and mobile (Touch button and joystick) support are taken care of.


## Contents
* Setup
* UI
	* Theme
	* Menu
	* GameUI
	* MobileUI
* Settings
	* Controls
	* Video
	* Audio
* Demo Levels
* Global Managers
	* D for Debug
	* C for Config
	* PersistenceMngr
	* ScreenMngr
	* SignalMngr
	* StateMngr

## ![](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo32.png "") Setup

Just download or fork the whole thing and editor delete what you want.

See *[scripts/globals/Config.gd]* for some basic options.

## ![](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo32.png "") UI

### Theme

The Menu, the GameUI and all sub-components use a single theme resource.
It is globally used and can be found in *[assets/theme.tres]*.
Changing the looks is easy, just modify this [theming atlas](https://github.com/AnJ95/godot-toolbox-project/blob/master/assets/theme.png).

### Menu

The game comes with a main menu that lets you navigate through options, an about screen, a level selection and the game.
These are all implemented as Screens *[scenes/screens/]*.
The menu can be navigated using a controller.

### GameUI

Additionally, there are in-game ui components *[scenes/game/]* like:

* PauseMenu
* GameOver
* A GameUI equipped with a healthbar and a score indicator

![GameOver dialog](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_game3.png "GameOver dialog")

### MobileUI

A joystick and one button currently enable for platformer controls on mobile.
However, you could go for an extra button or joypad if you needed them.

![Mobile controls](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_game4.png "Mobile controls")

They trigger the same InputEvents a key stroke would fire and their respective InputMap action can be configured via export variables.

![Mobile joystick configuration](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_mobilecontrols.png "Mobile joystick configuration")

## ![](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo32.png "") Settings

![Settings screen](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_settings.png "Settings screen")

Video, audio and controls settings can all be adjusted and are saved using the PersistenceMngr.

### Controls

![Controls screen](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_controls.png "Controls screen")

The controls default is taken from the project settings ```InputMap```.
Changes by the user do affect said ```InputMap``` and can therefore be polled using ```Input.is_action_pressed()```.

### Audio

Three Sliders give the option for main, music and soundeffects volume. Make sure to set the corresponding ```bus``` in any ```AudioStreamPlayers``` you create.

### Video

Currently only Fullscreen and VSync options, but can be extended easily.

## ![](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo32.png "") Demo Levels

A game setup can be found in *[scenes/game]*, but you can delete everything in that folder, just make sure to add you game into *[scenes/screens/ScreenGame.tscn]*.

The world is broken up into levels, aka sub scenes located in *[scenes/game/levels/]*. In this demo each level showcases a different map and mechanic and they can be changed by the pressing 1 (or by collecting all coins ;) ).

![TopDown with a 3x3 autotile tileset](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_game2.png "TopDown with a 3x3 autotile tileset")

A total of 5 levels with different settings can be found, some with specials. Some of the most notable:
* Platformers
	* darkness and light *[scenes/game/levels/PlatformerDarkCave]*
	* a parallax background *[scenes/game/levels/PlatformerParallax]*
	* a [3x3 autotile](https://kidscancode.org/godot_recipes/2d/autotile_intro/) TileMap *[scenes/game/levels/PlatformerAutotile]*
* TopDown
	* an isometric TileMap *[scenes/game/levels/TopDownIsometric]*
	* a [3x3 autotile](https://kidscancode.org/godot_recipes/2d/autotile_intro/) TileMap *[scenes/game/levels/TopDownMysteryDungeon]*

![Platformer with parallax and enemy](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/readme/screenshot_game1.png "Platformer with parallax and enemy")

The Player and the Enemy are both inheriting from the abstract Entity class, which refactors common behavior like basic physics, health, damage, collision and more.
In this demo, the Player provides 2 control schemes, and 4 skins.

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
D.l(D.LogCategory.GAME, ["Savefile could not be found", state], LogLevel.WARN)
D.w(D.LogCategory.GAME, ["Savefile could not be found", state])
```
The Config file allows filtering the debug output by topic and LogLevel

### C for Config

Contains global settings for hiding menus, the title song, default settings, screens, levels and more.

Since the config is global, it can be accessed:
```gdscript
health = 100 if C.is_debug else 3
```

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

All screens must inherit *[scenes/screen/Screen.tscn]*.

```gdscript
# Open settings screen
ScreenMngr.push_screen(C.SCREEN_OPTIONS_MENU)

# Go to custom screen
ScreenMngr.push_screen(load("res://scenes/screens/my_custom_screen.tscn"))

# Pop back to previous screen (without re-instantiating it!)
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

Is already used for a lot of components, esp. to notify game elements.

### StateMngr
Creates the state objects for the ```PersistenceMngr``` and holds some global variables.

## ![](https://raw.githubusercontent.com/AnJ95/godot-toolbox-project/master/assets/logo/logo32.png "") Assets
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

Theme, Logo, the dungeon tileset  
Me
