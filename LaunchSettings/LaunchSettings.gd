## Allows defining initial launch conditions for the game at large
## Use for things like initial level, custom behaviour, etc.
class_name LaunchSettings
extends Resource

@export var enable_debug := false
@export var enable_persistence := true
@export var custom_save: Save
@export var custom_initial_scene: PackedScene
@export var initial_kernel := Kernel.KERNEL_TYPE.GAMEPLAY
