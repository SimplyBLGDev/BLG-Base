class_name Debug_TrackedValue_Angle2D
extends Debug_TrackedValue

@onready var id_label: Label = %Label
@onready var angle_display: Control = %AngleDisplay
@onready var degrees: Label = %Degrees
@onready var vector: Label = %Vector

static func instantiate(id: StringName, initial_value) -> Debug_TrackedValue_Angle2D:
	var instance: Debug_TrackedValue_Angle2D = load("res://Debug/TrackedValue/Angle2D/Debug_TrackedValue_Angle2D.tscn").instantiate()
	instance.id = id
	
	return instance


func _ready():
	id_label.text = id + ":"


func update_value(new_value):
	super.update_value(new_value)
	degrees.text = str(rad_to_deg(last_value)) + "º"
	vector.text = str(Vector2.from_angle(last_value))
	queue_redraw()


func _draw() -> void:
	var center: Vector2 = Utils.get_relative_position_2d(self, angle_display) + angle_display.size * 0.5
	var radius := angle_display.size.x * 0.5
	var angle: float = last_value
	
	draw_circle(center, radius, Color.WHITE, true)
	draw_line(center, center + Vector2.from_angle(angle) * radius, Color.RED, 2.0)
