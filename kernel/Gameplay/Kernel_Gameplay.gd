class_name Kernel_Gameplay
extends Kernel


static func instantiate() -> Kernel_Gameplay:
	return load("res://Kernel/Gameplay/Kernel_Gameplay.tscn").instantiate()


func _ready():
	if Kernel.launch_settings.custom_initial_scene:
		var instance: Node = Kernel.launch_settings.custom_initial_scene.instantiate()
		add_child(instance)
		return
	
	# Default initial scene here
