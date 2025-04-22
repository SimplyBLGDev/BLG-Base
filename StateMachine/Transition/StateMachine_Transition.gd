@icon("res://StateMachine/Transition/StateMachine_Transition.svg")
class_name StateMachine_Transition
extends Node

signal triggered

var enabled := false

@export var target: StateMachine_State


func setup():
	pass


func trigger():
	if enabled:
		get_state().change_state(target)
		triggered.emit()


func get_evaluation_context() -> Node:
	return get_state_machine().evaluation_context


func get_state_machine() -> StateMachine:
	return get_state().state_machine


func get_state() -> StateMachine_State:
	return get_parent()
