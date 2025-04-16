class_name ControlAnimator_AnimationTrigger
extends Control

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var duration := 0.2

var target: Control:
	get:
		return get_parent() as Control

func _ready():
	assert(get_parent() is Control, "Parent is not Control")
	
	target.focus_entered.connect(on_focus_entered)
	target.focus_exited.connect(on_focus_exited)


func on_focus_entered():
	print("S")
	ControlAnimator.apply_animation(target, position, rotation, scale, duration)


func on_focus_exited():
	print("D")
	ControlAnimator.remove_animation(target, duration)
