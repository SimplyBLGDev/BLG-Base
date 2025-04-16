## Allows for the skipping of a Sequence element with a key press
extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if get_parent().visible and get_parent().has_signal(&"finished"):
			get_parent().finished.emit()
