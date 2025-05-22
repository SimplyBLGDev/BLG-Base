class_name Kernel_Gameplay
extends Kernel

@export var default_mapping_context: GUIDEMappingContext

static func instantiate() -> Kernel_Gameplay:
	return load("res://Kernel/Gameplay/Kernel_Gameplay.tscn").instantiate()


func _ready():
	GUIDE.enable_mapping_context(default_mapping_context)
	if Kernel.launch_settings.custom_initial_scene:
		var instance: Node = Kernel.launch_settings.custom_initial_scene.instantiate()
		add_child(instance)
		return
	
	# Default initial scene here
