class_name Utils_ClickCamera
extends Camera2D

signal on_click

@export var _cursor_position: GUIDEAction
@export var _relative_cursor_position: GUIDEAction
@export var _drag_delta: GUIDEAction
@export var _drag_start: GUIDEAction
@export var _drag: GUIDEAction
@export var _drag_end: GUIDEAction
@export var _click: GUIDEAction

@onready var node_dragger: RemoteTransform2D = %NodeDragger
@onready var dragger_offset: Node2D = %DragOffset

func _ready():
	_click.triggered.connect(click)
	_drag_start.triggered.connect(drag_start)
	_drag.triggered.connect(drag)
	_drag_end.triggered.connect(drag_end)


func click():
	on_click.emit()
	var clicked_node = get_node_at_cursor()
	if clicked_node and clicked_node.has_method(&"click"):
		clicked_node.click() 


func drag_start():
	var clicked_node = get_node_at_cursor()
	if not clicked_node:
		return
	
	if not clicked_node.is_in_group(Groups.DRAGGABLE):
		return
	
	var target := clicked_node.get_parent()
	
	if not target:
		return
	
	if target.has_method(&"drag_start"):
		target.drag_start()
	
	dragger_offset.global_position = _cursor_position.value_axis_2d
	node_dragger.global_position = target.global_position
	node_dragger.remote_path = target.get_path()


func drag():
	if node_dragger.remote_path != ^"":
		dragger_offset.global_position = _cursor_position.value_axis_2d


func drag_end():
	var node := get_dragged_node()
	if node and node.has_method(&"drag_end"):
		node.drag_end()
	
	node_dragger.remote_path = ^""
	node_dragger.position = Vector2.ZERO


func get_dragged_node() -> Node:
	if node_dragger.remote_path == ^"":
		return null
	
	var node := get_node(node_dragger.remote_path)
	return node


func get_node_at_cursor() -> Node:
	var click_pos := _cursor_position.value_axis_2d
	var clicked_node := Utils.get_top_node_at_point(get_world_2d().direct_space_state, click_pos)
	return clicked_node


func _physics_process(delta: float) -> void:
	print(_cursor_position.value_axis_2d)
