class_name Debug
extends Node


static func spawn():
	return load("res://debug/Debug.tscn").instantiate()


func _ready():
	Kernel.debug = self
