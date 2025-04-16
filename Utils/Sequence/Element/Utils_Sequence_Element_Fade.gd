class_name Utils_Sequence_Element_Fade
extends TextureRect

signal finished

@export var fade_in_duration := 1.0
@export var visible_duration := 2.0
@export var fade_out_duration := 1.0


func _ready() -> void:
	modulate = Color.TRANSPARENT
	hide()


func sequence_play():
	show()
	var tween := create_tween()
	
	tween.tween_property(self, "modulate", Color.WHITE, fade_in_duration)
	tween.tween_interval(visible_duration)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_out_duration)
	tween.play()
	
	await tween.finished
	finished.emit()
