class_name Debug_TrackedValue_Container
extends GridContainer

var tracked_values: Dictionary[StringName, Debug_TrackedValue] = {}

func visualize_value(id: StringName, value: Variant):
	if id not in tracked_values:
		var instance := Debug_TrackedValue_Label.instantiate(id, value)
		add_child(instance)
		tracked_values[id] = instance
	
	tracked_values[id].update_value(value)

func visualize_angle2d(id: StringName, value: float):
	if id not in tracked_values:
		var instance := Debug_TrackedValue_Angle2D.instantiate(id, value)
		add_child(instance)
		tracked_values[id] = instance
	
	tracked_values[id].update_value(value)
