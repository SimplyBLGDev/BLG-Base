class_name StateMachine_Transition_Condition
extends StateMachine_Transition

## Expression to be evaluated, variables are taken from this transition's
## state machine's evaluation context
@export_multiline var condition := ""
## If enabled the expression will be evaluated in physics process() instead of process()
@export var check_on_physics_process := false

var evaluation_context: Node
var expression := Expression.new()

# Called by StateMachine when it is ready
func setup():
	set_process(not check_on_physics_process)
	set_physics_process(check_on_physics_process)
	get_state().on_enter_state.connect(check_expression)
	evaluation_context = get_evaluation_context()
	expression.parse(condition)


func _process(delta: float) -> void:
	check_expression()


func _physics_process(delta: float) -> void:
	check_expression()


func check_expression():
	if not enabled:
		return
	
	var result = expression.execute([], evaluation_context)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return
	
	if result:
		trigger()
