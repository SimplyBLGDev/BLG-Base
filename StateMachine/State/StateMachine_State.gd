@icon("res://StateMachine/State/StateMachine_State.svg")
class_name StateMachine_State
extends Node

signal on_enter_state
signal on_exit_state

@onready var state_machine: StateMachine = Utils.find_ancestor_of_type(self, StateMachine)

func on_process(delta: float) -> void:
	pass


func on_physics_process(delta: float) -> void:
	pass


func on_input(_event: InputEvent) -> void:
	pass


func on_enter(from: StateMachine_State):
	pass


func on_exit(to: StateMachine_State):
	pass


func on_outbound_transition(to: StateMachine_State):
	pass


func change_state(to: StateMachine_State):
	if is_instance_valid(state_machine):
		state_machine.change_state(to)
	else:
		push_error("State ", self, " not initialized")


func change_state_name(name: StringName):
	if is_instance_valid(state_machine):
		state_machine.change_state_name(name)
	else:
		push_error("State ", self, " not initialized")
