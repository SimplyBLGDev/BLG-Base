class_name Kernel_Gameplay
extends Kernel


static func instantiate() -> Kernel_Gameplay:
	return load("res://kernel/Gameplay/Kernel_Gameplay.tscn").instantiate()


func _ready():
	Kernel.set_current_kernel(self)
