@icon("res://Utils/SmoothValue/Utils_SmoothValue.svg")
class_name Utils_SmoothValue
extends Node

enum VALUE_TYPE {
	GENERIC, ANGLE, VECTOR2_ANGLE
}

@export var value_type: VALUE_TYPE:
	set(value):
		value_type = value
		smooth_func = update_smoothing_function()
@export var target_instance: Node
@export var property_path: StringName
@export var smoothness: float

var target_value
var smooth_func: Callable = smooth_generic

func update_smoothing_function() -> Callable:
	match value_type:
		VALUE_TYPE.GENERIC: return smooth_generic
		VALUE_TYPE.ANGLE: return smooth_angle
		VALUE_TYPE.VECTOR2_ANGLE: return smooth_v2_angle
		_: return smooth_generic


func _process(delta: float):
	if not target_instance or not property_path or not smooth_func:
		return
	
	var current_value = target_instance.get(property_path)
	var new_value = smooth_func.call(current_value, target_value, smoothness * delta)
	target_instance.set(property_path, new_value)


func smooth_generic(from, to, t: float):
	return lerp(from, to, t)


func smooth_angle(from: float, to: float, t: float) -> float:
	return lerp_angle(from, to, t)


func smooth_v2_angle(from: Vector2, to: Vector2, t: float) -> Vector2:
	var f_angle := from.angle()
	var t_angle := to.angle()
	var f_mag := from.length()
	var t_mag := to.length()
	
	var angle := smooth_angle(f_angle, t_angle, t)
	var mag := lerpf(f_mag, t_mag, t)
	
	return Vector2.from_angle(angle) * mag
