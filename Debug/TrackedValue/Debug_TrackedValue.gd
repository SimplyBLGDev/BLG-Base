class_name Debug_TrackedValue
extends Control

@export var id: StringName
var last_value


func update_value(new_value):
	last_value = new_value
