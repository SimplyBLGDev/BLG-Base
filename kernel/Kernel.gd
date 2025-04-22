@icon("res://Kernel/Kernel.svg")
class_name Kernel
extends Node

enum KERNEL_TYPE { GAMEPLAY }
static var _KERNELTYPE_DICT = {
	KERNEL_TYPE.GAMEPLAY: Kernel_Gameplay,
}

static var MAINSCENE: MAINSCENE
static var launch_settings: LaunchSettings:
	get():
		return MAINSCENE.launch_settings


static var _current_kernel: Kernel
static var Gameplay: Kernel_Gameplay:
	get:
		assert(_current_kernel, "There's no kernel")
		assert(_current_kernel is Kernel_Gameplay, "Current Kernel is not gameplay")
		return _current_kernel as Kernel_Gameplay
static var Audio: Audio
static var Debug: Debug
static var Save: Save


static func get_current_kernel() -> Kernel:
	return _current_kernel


static func change_kernel(new_kernel: KERNEL_TYPE):
	if _current_kernel:
		_current_kernel.queue_free()
	_current_kernel = _KERNELTYPE_DICT[new_kernel].instantiate()
	MAINSCENE.add_child(_current_kernel)


static func set_audio(audio: Audio):
	Kernel.Audio = audio


static func set_save(save: Save):
	Kernel.Save = save


func _ready():
	assert(false, "Base Kernel node instanced or, derived kernel doesn't initialize properly")
