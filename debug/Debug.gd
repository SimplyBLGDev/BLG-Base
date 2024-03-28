class_name Debug
extends Node


static func instantiate():
	return load("res://debug/Debug.tscn").instantiate()


func _ready():
	Kernel.debug = self
