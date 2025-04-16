class_name Debug_TrackedValueLabel
extends Label

@export var header: String
@export var property: StringName
var from


static func instantiate() -> Debug_TrackedValueLabel:
	return load("res://Debug/TrackedValueLabel/Debug_TrackedValueLabel.tscn").instantiate()


func _process(delta):
	text = header + str(from.get(property))
