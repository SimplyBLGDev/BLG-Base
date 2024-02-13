# STYLE GUIDE
## FILE AND CLASS NAMES
.gd files are ALWAYS named the same as their class name (exactly the same)
class_names (and by extension filenames) are capitalized and if multiple words are necessary they AreWrittenLikeThis
If there's a related class that they depend on then make them belong to their 'namespace' (just a prefix) for example, if there's an Item label class as part of the HUD class which in turn is part of the UI it may be called UI_HUD_ItemLabel and it will be in the file UI_HUG_ItemLabel.gd

## VARIABLE NAMES
variables are in lower case and in case of multiple words are written_like_this, entirely in lowercase, even for words like hud and ui
variables are always typed (unless there's a __really__ good reason not to), examples:
```
var result_of_function := function_with_a_return_type()
var casted_var: Player = find_objects_in_group("player")[0]
var new_variable := 5.0
const CONSTANT_NAME := 10
static var variable_name := "A static variable"
```

## GLOBALS
Globals are necessary in all games, but there are points in the game even in which things that normally are globally required don't exist yet (let's say a player variable could normally be global but when in the bootup menu it wouldn't exist yet and referencing it could lead to errors), because of this we use the Kernel System instead
create kernels for each part of the game (we could have a kernel for the main menu and a different kernel for the gameplay) and we can reference them with
```
Kernel.MainMenu
Kernel.Gameplay
```
This is all managed and declared in the Kernel.gd script
Kernel acts as a singleton but it is not, the kernels appear and are destroyed and as such no unnecessary objects exist in memory, it is NOT in the Autoload

## MAINSCENE and LAUNCHSETTINGS
The main scene is always MAINSCENE.tscn which is a node that will be root to everything, it manages the kernel, the debug (when enabled) and holds the launch settings
Launch settings is a resource exported in MAINSCENE.tscn that contains dropdowns and inputs for the starting stage of the game, put things such as starting level in the launch settings, always as an export, this will allow the developers to change this resource without having to worry about versioning and manually editing gd files

## GITIGNORE
the gitignore contains the MAINLAUNCHSETTINGS.tres file, so as to avoid merge conflicts for simply different testing environments but this file needs to be uploaded to the initial repo first, make sure to manually commit it if it's not present in the repo

## AUTOLOADS
Always avoid using Autoloads, use the Kernel system instead

## FUNCTIONS
Function names use the same conventions as variable names they_are_written_like_this()
The parameters of a function are always typed
If a function returns a value declare the return type in the signature, example:
```
func example_function(example_input: String) -> String:
	return "_" + example_input
```

## SCENES
If the scene contains specific nodes that need references NEVER use $, always use Unique names (%) and save them to a variable before using them, example:
```
# WRONG
func update_label(new_text: String):
	$Path/To/Label.text = new_text

# WRONG
var label: Label = $Path/To/Label
func update_label(new_text: String):
	label.text = new_text

# WRONG
func update_label(new_text: String):
	%Label.text = new_text

# CORRECT
var label: Label = %Label
func update_label(new_text: String):
	label.text = new_text
```
Do not be afraid of making small scripts for individual nodes within a scene if advantageous (you can even do them buil-in if they're that small)
Do not be afraid of generating sub-scenes, very big scenes are a bad idea
Do NOT access nodes of a child subscene directly, create a script in the subscene that has a reference to IT'S child and use that instead
Do not be afraid of chaining signals or methods across multiple nested subscenes

## NODES
Nodes follow ThisNamingConvention, the root of a scene should be named the same as it's script (excluding namespaces) for example
Script name UI_HUD_ItemLabel.gd belongs to the root of the scene UI_HUD_ItemLabel.tscn and the root node of the scene is called ItemLabel

## MAGIC CONSTANTS
Never have 'magic numbers' or 'magic strings' in the script, unless it is evident from the context what it does, example:
```
# WRONG
player.magazines -= 1
player.ammo += 15

# CORRECT
const MAGAZINE_CAPACITY := 15
...
player.magazines -= 1
player.ammo += MAGAZINE_CAPACITY
```
If godot treats something as a string name, use the string name, for example, in inputs:
```
# WRONG
if Input.is_action_pressed("attack"):
	pass

# CORRECT
if Input.is_action_pressed(&"attack"):
	pass
```

## INSTANTIATING PACKED SCENES
In the case of spawning PackedScenes it is a common problem to hardcode the path to the tscn file on whatever node spawns it, this can bring problems if the file is moved and as such we'll use instead the static instantiate() system
Every node that can be spawned will have the following piece of code as it's first function
```
class_name Enemy
extends Node2D

static func instantiate() -> Enemy:
	return load("res://Entities/Enemy.tscn").instantiate()
```
It can then be spawned by doing
```
class_name EnemySpawner
extends Node2D

func spawn_enemy():
	var new_enemy := Enemy.instantiate()
	add_child(new_enemy)
```
thanks to this if change the route to the enemy scene it can be updated in Enemy.gd and we don't have to worry about it anywhere else
Please note that the create() function is static and also note that it uses load() instead of preload()

## KEEP THINGS CLEAN
use double empty lines between FUNCTIONS
```
func func_A():
	pass


func func_B():
	pass
```
Always leave a newline at the end of the file (very important for versioning)
```
func last_function_in_the_file():
	pass

```
Keep headers gd files headers consistent, follow this order:
class_name
extends
<blank line>
static variables
<blank line>
@export variables
<blank line>
variables
<blank line>
@onready variables
<blank line>
static functions
lifetime functions (_ready, _process, _physics_process, _init, etc.)
other functions
<ending newline>
Always keep a scene and the script for the root of that scene in the same folder

Try to remove all print()s and commented lines before commiting to the repo, commented lines are only acceptable in the context of a piece of code that has been TEMPORARILY disabled and WILL be enabled in the near future
Follow these guidelines as closely as possible and if you find a piece of code that doesn't follow it try to correct it ASAP

## FOR NON PROGRAMMING DEVELOPERS AND ASSET MAKERS
On the root of the repository there's a folder .concept, this folder is not read by godot and should be used to contain any asset that needs versioning/sharing with the team but doesn't straight up go into the godot project such as:
- Photoshop files
- Text files for organization, TODO Lists etc.
- In progress assets
- Please keep filenames descriptive and the folder structure clean

## CLEAN CODE
If a function has more than 15 lines of code start thinking about the DRY principle and if possible break it up into smaller functions with descriptive names
Use comments only when the line of code is obscure in it's effects
If there are multiple variables that are tightly related among other variables that aren't in the same class, split those variables into a resource, if you're always passing the same set of parameters through multiple functions, join them through a resource
Do not use comments if a more descriptive variable name/function name would explain it, do not use comments if breaking a piece of the code into another function would explain it
Do not be afraid of having short functions
Do not be afraid of having resources with only a few parameters that only hold data

## COMMITING TO THE REPO
Always check what files are modified and uncheck any and all files you don't intend to change with your push this specially includes:
- Temporary adjustments you did in your end for you
- TSCN (Godot scenes) files that you didn't modify the nodes for (please pay close attention)
- Files that you changed by accident and are not sure what you changed
