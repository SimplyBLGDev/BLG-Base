## `sequence_play()`s all children in order
class_name Utils_Sequence
extends Node

signal step
signal finished

@export var autoplay := false


func _ready():
	if autoplay:
		play()


func play():
	for element in get_children():
		if element.has_method("sequence_play"):
			await element.sequence_play()
			if element is CanvasItem:
				element.hide()
			element.process_mode = Node.PROCESS_MODE_DISABLED
			step.emit()
	
	finished.emit()
