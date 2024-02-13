## Allows defining initial launch conditions for the game at large
## Use for things like initial level, custom behaviour, etc.
class_name LaunchSettings
extends Resource

var kernel_list = {
	Kernel.KERNEL_LIST.GAMEPLAY: Kernel_Gameplay
}

@export var debug_enabled := true
@export var initial_kernel := Kernel.KERNEL_LIST.GAMEPLAY


## Spawns and returns kernel
func get_kernel() -> Kernel:
	return kernel_list[initial_kernel].create()
