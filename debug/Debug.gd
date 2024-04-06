class_name Debug
extends Node


static func instantiate():
	return load("res://Debug/Debug.tscn").instantiate()


func _ready():
	Kernel.debug = self
