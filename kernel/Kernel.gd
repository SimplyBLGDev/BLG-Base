class_name Kernel
extends Node

enum KERNEL_LIST { GAMEPLAY }

static var _current_kernel: Kernel
static var Example: Kernel_Gameplay:
	get:
		assert(_current_kernel, "There's no kernel")
		assert(_current_kernel is Kernel_Gameplay, "Current Kernel is not gameplay")
		return _current_kernel as Kernel_Gameplay
static var debug: Debug:
	get:
		assert(debug, "Debug is not enabled")
		return debug


static func get_current_kernel() -> Kernel:
	return _current_kernel


static func set_current_kernel(new_kernel: Kernel):
	_current_kernel = new_kernel


func _ready():
	assert(false, "Base Kernel node instanced or, derived kernel doesn't initialize properly")
