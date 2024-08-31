## Root of the entire game
class_name MAINSCENE
extends Node

@export var launch_settings: LaunchSettings

func _ready():
	if not launch_settings:
		assert(false, "No Launch Settings, check MAINSCENE")
	
	Kernel.MAINSCENE = self
	
	initialize_window()
	initialize_persistence()
	initialize_systems()
	initialize_kernel()


func initialize_window():
	get_viewport().size = launch_settings.render_size
	
	var diff = Vector2i((launch_settings.window_size - DisplayServer.window_get_size()) * 0.5)
	DisplayServer.window_set_size(launch_settings.window_size)
	DisplayServer.window_set_position(DisplayServer.window_get_position() - diff)


func initialize_systems():
	if launch_settings.enable_debug:
		add_child(Debug.instantiate())


func initialize_persistence():
	if launch_settings.custom_save:
		Kernel.set_save(launch_settings.custom_save)
	else:
		Kernel.set_save(Save.from_file(""))


func initialize_kernel():
	Kernel.change_kernel(launch_settings.initial_kernel)
