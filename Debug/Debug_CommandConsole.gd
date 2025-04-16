class_name Debug_CommandConsole
extends LineEdit

var expression := Expression.new()
var command_history: Array[String] = []
var command_history_ix := 0


func toggle():
	if visible:
		visible = false
		return
	command_history_ix = len(command_history)
	text = ""
	visible = true
	grab_focus()


func _on_text_submitted(new_text: String):
	var command := build_command(new_text)
	expression.parse(command)
	expression.execute([], Kernel.Debug.commands)
	
	if new_text != "":
		command_history.append(new_text)
	
	Kernel.Debug.print_to_cmd_log(">" + new_text, "#10127080")
	
	toggle()
	clear()


func build_command(from: String) -> String:
	var words: PackedStringArray = from.split(" ")
	var function_name := words[0]
	var arguments := words.slice(1)
	
	for i in range(len(arguments)):
		if arguments[i].begins_with('"') and arguments[i].ends_with('"'):
			break
		arguments[i] = '"' + arguments[i].c_escape() + '"'
	
	return function_name + '(' + ', '.join(arguments) + ')'


func _input(event: InputEvent):
	if event is InputEventKey and event.is_pressed():
		_input_key(event)


func _input_key(event: InputEventKey):
	var e: InputEventKey = event
	match e.keycode:
		KEY_UP:
			var new_ix: int = max(command_history_ix - 1, 0)
			scroll_command_history(new_ix)
		KEY_DOWN:
			scroll_command_history(command_history_ix + 1)


func scroll_command_history(ix: int):
	var available_commands := len(command_history)
	
	if ix >= available_commands: # Special case, allow input of new command
		text = ""
		return
	
	command_history_ix = posmod(command_history_ix, len(command_history) - 1)
	text = command_history[command_history_ix]
