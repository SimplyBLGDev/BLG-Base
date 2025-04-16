class_name ControlAnimator_Animation
extends Resource

var tween: Tween
var phantom: Control


func _init(tween: Tween, phantom: Control) -> void:
	self.tween = tween
	self.phantom = phantom
