
# Style Guide

## File, Folder, and Class Names

- **.gd files** must always be named exactly the same as their class name.
- **Class names** (and their corresponding filenames) must be capitalized and written in **PascalCase**.
- Namespaces correspond to folders within the project structure, unless it is a generic or utility class.
- Files are organized through folders known as _namespaces_, files contained within these namespaces belong to it and are prefixed by all its namespaces. For example, if there is an `ItemLabel` class as part of the HUD system within the UI system, it should be named `UI_HUD_ItemLabel` and located at `res://UI/HUD/UI_HUD_ItemLabel.gd`.
	- If a script is named the same as its namespace, it should not repeat its name. Instead, it should be treated as the root of the namespace, rather than a member of it. This script will still be placed in the root of the namespace's folder. For example, the `Kernel.gd` file should be located at `res://Kernel/Kernel.gd` rather than `res://Kernel/Kernel_Kernel.gd`.
- **Folder names** used as namespaces should also be capitalized. Namespaces represent subsystems or areas of the software and should never represent a file type (e.g., avoid creating namespaces for all scripts, all images, all audio files, etc.).

> Namespaces are delimited by underscores. Therefore Class names cannot contain underscores to avoid ambiguity.

## Variable Names

- Variables must always use **snake_case**, written entirely in lowercase, even in acronyms i.e. *hud* and *ui*.
- Variables must always be explicitly _typed_ unless there is a compelling reason not to do so. Examples:
```swift
var result_of_function := function_with_a_return_type()
var typecast_var: Player = find_objects_in_group("player")[0]
var new_variable := 5.0
const CONSTANT_NAME := 10
static var variable_name := "A static variable"
```

## Globals

### Autoloads

Autoloads are godot nodes or scripts which _always_ exist during the project's runtime, their main advantages revolve around the ability to access the autoload as an instance, which always exists.

However, these instances are permanently taking resources, can't be disposed of during runtime, and may create errors by making assumptions about the software's state at inapropiate times.

Because of this we can use a system that allows us to combine the advantages of autoloads with the ability to free these scripts when not in use, we call this system the _Kernel System_.

### Kernel System

Via the _Kernel System_, we create _kernels_ for each part of the game which are managed and declared in the `Kernel.gd` script. The Kernel is not an Autoload and kernels individual kernels can be discarded and replaced at will. We can reference these scripts through i.e.
```swift
Kernel.MainMenu
Kernel.Gameplay
```

### Node Groups and Other Constant Values

Use the global constants in the `Groups.gd` file within the `Framework` folder for referencing node groups or metadata field names:
```swift
# WRONG
var enemies_in_scene := get_nodes_in_group("enemy")

# WRONG
const ENEMY_GROUP := "enemy"
var enemies_in_scene := get_nodes_in_group(ENEMY_GROUP)

# CORRECT
var enemies_in_scene := get_nodes_in_group(Groups.ENEMY)
```

New groups can be declared within `Groups.gd`:
```swift
const ENEMY := "enemy"
```

> This practice keeps group name string constants consistent across the project, facilitating tracking and modification of node group names if necessary. Similar systems can be used for metadata fields, input maps, and other engine-related constants. Keep script names consistent and declare contents as constant variables.

> Constants may also be placed in Kernel classes. If a constant is required only during _Gameplay_, it may be placed in the Gameplay Kernel.

## Main Scene and Launch Settings

- The main scene should always be `MAINSCENE.tscn`, acting as the root, it manages the kernel, debug system (when enabled), and launch settings.
- Launch settings are a resource exported in `MAINSCENE.tscn`, it includes options for the game's starting state, facilitating testing and modifying the initial state of the project without the need to handle scripts.
	- Different launch setting presets can be saved as `.tres` resources and swapped as needed.

## Functions

- Function names should follow the same conventions as variable names: **snake_case()**.
- Function parameters must always be typed explicitly.
- Use an underscore (_) on internal functions to mark them as 'private'.
- Document the effects, usage, and parameters of functions using **docstrings**.

If a function returns a value, declare the return type explicitly in the signature:
```swift
## Description or instructions of example_function(), it will popup when hovering over the function name
func example_function(example_input: String) -> String:
	return "_" + example_input

func _private_function():
	return "This function shouldn't be called from outside this very script (or its inheritors)"
```

## Scenes

- Never use `$` (nor `get_node`) for specific node references within a scene. Use unique names (%) and save them to a variable before using them:
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

> Do not hesitate to create small scripts for individual nodes within a scene if advantageous, even making them built-in if not useful outside the scene.

>Avoid creating very large scenes, consider generating sub-scenes.

> Do not access nodes of a child subscene directly; create a script in the subscene with a reference to its child and use that instead.

> Do not hesitate to chain signals or methods across multiple nested subscenes.

## Nodes

Nodes must follow PascalCase. The root of a scene should be named the same as its script (excluding namespaces), for example a script named `UI_HUD_ItemLabel.gd` should belong to the root of the scene `UI_HUD_ItemLabel.tscn`, and the root node of the scene should be called `ItemLabel`, `HUD_ItemLabel`, or `UI_HUD_ItemLabel` (specify namespaces if necessary for clarity).

## Constants

Avoid 'magic numbers' and 'magic strings' in scripts, unless their meaning is evident from the context:
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

If Godot treats something as a string name, use the string name, for example, in inputs:
```swift
# WRONG
if Input.is_action_pressed("attack"):
	pass

# CORRECT
if Input.is_action_pressed(&"attack"):
	pass
```

## Instantiating Scenes

Avoid hardcoding the path to the tscn file when spawning PackedScenes. Instead, use a static `instantiate()` implementation:
```swift
class_name Entities_Enemy
extends Node2D

static func instantiate() -> Entities_Enemy:
	return load("res://Entities/Enemy.tscn").instantiate()
```

Spawn the node using:
```swift
class_name EnemySpawner
extends Node2D

func spawn_enemy():
	var new_enemy := Entities_Enemy.instantiate()
	add_child(new_enemy)
```

This ensures that if the route of the enemy scene changes, it can be updated in `Enemy.gd` without concerns elsewhere. Note that the `instantiate()` function is static and uses `load()` instead of `preload()`.

## Maintain Clean Code

- Use double empty lines between functions:
```swift
func func_A():
	pass


func func_B():
	pass
```
- Always leave a newline at the end of the file (important for versioning):
```swift
func last_function_in_the_file():
	pass
```
- Follow this order for gd file headers:
```swift
class_name

extends

constants

signals

static variables

@export variables

variables

@onready variables

static functions

lifetime functions (_init, _ready, _process, _physics_process, etc.)

other functions

<ending newline>
```

- Keep a scene and the script used on its root in the same folder and with the same name. 

- Remove all `print()` statements and commented lines before committing to the repo. Commented lines are acceptable only if the code has been temporarily disabled and will be enabled soon.

## Clean Code Practices

- For functions exceeding 15 lines, consider the DRY principle and break them into smaller functions with descriptive names.
- Use comments only for lines of code or methods that are difficult to understand.
- For multiple tightly related variables in the same class, consider creating a resource. Pack commonly passed parameters into a resource.
- Avoid comments if a more descriptive variable or function name would suffice. Similarly, break down code into functions rather than using comments.
- Do not hesitate to have short functions or resources with only a few parameters for holding data.

# For Non-Programming Developers and Asset Makers

## .concept Folder

The `.concept` folder at the root of the repository is not read or compiled by Godot. Use it to store assets that need versioning/sharing with the team but not inclusion in the Godot project, such as:
- Photoshop files
- Text files for organization, TODO lists, etc.
- In-progress assets

> Keep filenames descriptive and the folder structure clean.

## Asset File Paths

When incorporating or exporting assets for the project, adhere to the project's file structure:
- Folders (or _namespaces_) represent a software subsystem, a gameplay mechanic, or an area of the game. Assets used exclusively by a namespace should be within it.
- Assets used by multiple unrelated namespaces should be placed in the _Assets_ folder in the root of the project.
- Asset names must use **PascalCase** without underscores, spaces, or special characters.
- Asset names should include all namespaces, separated by underscores (e.g., a font used by the HUD should be at `res://UI/HUD/UI_HUD_Font.ttf`).
- Keep filenames descriptive.

## Committing to the Repo

- Always check modified files and uncheck any files not intended in your commit before pushing. This includes:
- Temporary local adjustments for testing.
- TSCN (Godot scenes) files that you didn't modify the nodes of (pay close attention).
- Files that you changed by accident.
