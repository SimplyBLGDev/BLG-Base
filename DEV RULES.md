
# STYLE GUIDE
## FILE AND CLASS NAMES
*.gd* files are ALWAYS named the same as their class name (exactly the same)
class_names (and by extension filenames) are capitalized and if multiple words are necessary they are written in **PascalCase**.

If there's a dependent related class make them belong to their 'namespace' (named prefix within the filename) for example, if there's an Item label class as part of the HUD class which in turn is part of the UI class it may be called UI_HUD_ItemLabel and it will be in the file *UI_HUD_ItemLabel.gd*.

>Namespaces are delimited by underscores, class names cannot contain underscores to avoid ambiguity.

## VARIABLE NAMES
Variables always use **snake_case**, entirely in lowercase, even for initials like *hud* and *ui*.

Variables are always typed (unless there's a __really__ good reason not to), examples:
```swift
var result_of_function := function_with_a_return_type()
var casted_var: Player = find_objects_in_group("player")[0]
var new_variable := 5.0
const CONSTANT_NAME := 10
static var variable_name := "A static variable"
```

## GLOBALS
Globals are necessary in all games, but there are points in the game even in which things that normally are globally required don't exist yet (let's say a player variable could normally be global but when in the bootup menu it wouldn't exist and referencing it could lead to errors), because of this we use the _Kernel System_, creating _kernels_ for each part of the game (we could have a kernel for the main menu and a different kernel for the gameplay) and we can reference them with.
```swift
Kernel.MainMenu
Kernel.Gameplay
```
This is all managed and declared in the **Kernel.gd** script.

Kernel acts as a singleton but it is not, the kernels appear and are destroyed and as such no unnecessary objects exist in memory; It is NOT an Autoload.

## MAINSCENE and LAUNCHSETTINGS
The main scene is always MAINSCENE.tscn which is a node that will be root to everything, it manages the _kernel_, the _debug_ (when enabled) and holds the _launch settings_.

Launch settings is a resource exported in MAINSCENE.tscn that contains dropdowns and inputs for the starting state of the game, useful for things such as starting level and parameters, always as an export, this will allow the developers, even non-programmers to easily change the starting state of the game for testing without having to worry about versioning and manually editing gd files.

## GITIGNORE
The gitignore contains the LAUNCHSETTINGS.tres file, so as to avoid merge conflicts for different testing environments but this file needs to be uploaded to the initial repo first, make sure to manually commit it if it's not present in the repo.

## AUTOLOADS
Always avoid using Autoloads, use the Kernel system instead.

## FUNCTIONS
Function names use the same conventions as variable names, __snake_case()__.

The parameters of a function are always typed.

If a function returns a value declare the return type in the signature, example:
```swift
func example_function(example_input: String) -> String:
	return "_" + example_input
```

## SCENES
If a scene contains specific nodes that need references NEVER use $, always use Unique names (%) and save them to a variable before using them, example:
```swift
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
> Do not be afraid of making small scripts for individual nodes within a scene if advantageous (you can even make them built-in if they're small and useless outside of the scene).

> Do not be afraid of generating sub-scenes, very big scenes are a bad idea.

> Do NOT access nodes of a child subscene directly, create a script in the subscene that has a reference to its child and use that instead.

> Do not be afraid of chaining signals or methods across multiple nested subscenes.

## NODES
Nodes follow PascalCase, the root of a scene should be named the same as its script (excluding namespaces) for example:

A script name _UI_HUD_ItemLabel.gd_ belongs to the root of the scene _UI_HUD_ItemLabel.tscn_ and the root node of the scene is called _ItemLabel_.

## MAGIC CONSTANTS
Never have 'magic numbers' or 'magic strings' in the script, unless it is evident from the context what it does, example:
```swift
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
```swift
# WRONG
if Input.is_action_pressed("attack"):
	pass

# CORRECT
if Input.is_action_pressed(&"attack"):
	pass
```

## INSTANTIATING PACKED SCENES
When spawning PackedScenes it is a common error to hardcode the path to the tscn file on whatever script spawns it, this can bring problems if the file is moved and as such we'll use instead a static _instantiate()_ implementation.

Every node that can be spawned will have the following piece of code as it's first function.
```swift
class_name Enemy
extends Node2D

static func instantiate() -> Enemy:
	return load("res://Entities/Enemy.tscn").instantiate()
```
It can then be spawned by doing
```swift
class_name EnemySpawner
extends Node2D

func spawn_enemy():
	var new_enemy := Enemy.instantiate()
	add_child(new_enemy)
```
Thanks to this system if the route of the enemy scene is changed it can be updated in _Enemy.gd_ and we don't have to worry about it anywhere else.

Please note that the _instantiate()_ function is static and also that it uses load() instead of preload().

## KEEP THINGS CLEAN
use double empty lines between FUNCTIONS
```swift
func func_A():
	pass


func func_B():
	pass
```
Always leave a newline at the end of the file (very important for versioning).
```swift
func last_function_in_the_file():
	pass

```
Keep gd file headers consistent, follow this order:

```gdscript
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
```

Always keep a scene and the script for its root in the same folder.

>Try to remove all print()s and commented lines before commiting to the repo, commented lines are only acceptable in the context of a piece of code that has been TEMPORARILY disabled and WILL be enabled in the near future
Follow these guidelines as closely as possible and if you find a piece of code that doesn't follow it try to correct it ASAP.

## FOR NON PROGRAMMING DEVELOPERS AND ASSET MAKERS
On the root of the repository there's a _.concept_ folder, this folder is not read nor compiled by godot and should be used to contain any assets that needs versioning/sharing with the team but don't need to be included in the godot project, such as:
- Photoshop files
- Text files for organization, TODO Lists etc.
- In progress assets

>Please keep filenames descriptive and the folder structure clean.

## CLEAN CODE
If a function has more than 15 lines of code start thinking about the DRY principle and if possible break it up into smaller functions with descriptive names.

Use comments only when the line of code or method in question is obtuse to figure out.

If there are multiple tightly related variables in the same class consider splitting those variables into a resource, if you're always passing the same set of parameters through multiple functions, pack them on a resource.

Do not use comments if a more descriptive variable name/function name would explain it, do not use comments if breaking a piece of the code into another function would explain it.

Do not be afraid of having short functions.

Do not be afraid of having resources with only a few parameters for holding data.

## COMMITING TO THE REPO
Always check what files are modified and uncheck any and all files you don't intend to change with your push, this specially includes:
- Temporary adjustments you did locally in your end for testing.
- TSCN (Godot scenes) files that you didn't modify the nodes for (please pay close attention).
- Files that you changed by accident.
