## Root of the entire game
extends Node

@export var launch_settings: LaunchSettings

func _ready():
	if launch_settings.debug_enabled:
		add_child(Debug.instantiate())
	if launch_settings.persistence_enabled:
		add_child(Persistence.instantiate())
	add_child(launch_settings.get_kernel())
