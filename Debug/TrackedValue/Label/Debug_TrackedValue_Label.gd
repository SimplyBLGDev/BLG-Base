class_name Debug_TrackedValue_Label
extends Debug_TrackedValue

@onready var label: Label = %Label

static func instantiate(id: StringName, initial_value) -> Debug_TrackedValue_Label:
	var instance: Debug_TrackedValue_Label = load("res://Debug/TrackedValue/Label/Debug_TrackedValue_Label.tscn").instantiate()
	instance.id = id
	instance.update_value(initial_value)
	return instance


func update_value(new_value):
	last_value = new_value
	label.text = id + ": " + str(last_value)
