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
	pass


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
