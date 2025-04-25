@icon("res://Debug/Debug.svg")
class_name Debug
extends Node

@onready var command_log: RichTextLabel = %CommandLog
@onready var command_console: LineEdit = %CommandConsole
@onready var tracked_label_container: GridContainer = %TrackedLabelContainer
@onready var hud: CanvasLayer = %hud
@onready var commands: Debug_Commands = %Commands

static func instantiate() -> Debug:
	return load("res://Debug/Debug.tscn").instantiate()


func _ready():
	Kernel.Debug = self
	command_console.hide()


func track_property(from, property: StringName, header: String = ""):
	var new_label := Debug_TrackedValueLabel.instantiate()
	new_label.header = (header if header != "" else from.name + '::' + property) + ': '
	new_label.from = from
	new_label.property = property
	tracked_label_container.add_child(new_label)


func print_to_cmd_log(text: String, color := "white") -> void:
	command_log.text += "[color={0}]{1}[/color]\n".format([color, text])


func clear_cmd_log() -> void:
	command_log.clear()


func hide_UI():
	hud.hide()


func _input(event: InputEvent):
	if event.is_action_pressed(&"debug"):
		get_viewport().set_input_as_handled()
		var console_node: LineEdit = command_console
		console_node.toggle()
