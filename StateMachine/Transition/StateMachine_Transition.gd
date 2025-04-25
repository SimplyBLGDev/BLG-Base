@icon("res://StateMachine/Transition/StateMachine_Transition.svg")
class_name StateMachine_Transition
extends Node

signal triggered

var enabled := false

@export var target: StateMachine_State
@export var await_exit_method := false # Optionally awaitable method to execute before completing transition


func setup():
	pass


func trigger():
	if enabled:
		enabled = false
		if await_exit_method:
			await get_state().on_outbound_transition(target)
		
		get_state().change_state(target)
		triggered.emit()


func get_evaluation_context() -> Node:
	return get_state_machine().evaluation_context


func get_state_machine() -> StateMachine:
	return get_state().state_machine


func get_state() -> StateMachine_State:
	return get_parent()
