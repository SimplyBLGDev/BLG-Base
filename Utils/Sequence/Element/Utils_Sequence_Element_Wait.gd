class_name Utils_Sequence_Element_Wait
extends Node

signal finished

@export var duration := 1.0


func sequence_play():
	await get_tree().create_timer(duration).timeout
	finished.emit()
