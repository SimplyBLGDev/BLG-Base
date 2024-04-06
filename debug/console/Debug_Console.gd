class_name Debug_Console
extends Control

var commands: Dictionary

@onready var code_edit: CodeEdit = %CodeEdit
@onready var commands_previews: RichTextLabel = %CommandsPreview


func _on_code_edit_text_changed():
	_update_commands_preview()


func _get_possible_commands(hint: String) -> Array[String]:
	var start_with_hint: Array[String] = []
	var contain_hint: Array[String] = []
	
	for _command in commands:
		var command = _command as String
		command = command
		if command.begins_with(hint):
			start_with_hint.append(command)
		elif command.contains(hint):
			contain_hint.append(command)
	
	var result: Array[String] = start_with_hint + contain_hint
	return result


func _generate_commands_preview(hint: String) -> String:
	if hint == '':
		return ''
	
	var autocompletion := _get_possible_commands(hint)
	var final_text := '\n'.join(autocompletion)
	
	return final_text.replace(hint, '[b]{0}[/b]'.format([hint]))


func _update_commands_preview():
	var last_word := Utils.get_last_word(code_edit.text)
	commands_previews.text = _generate_commands_preview(last_word)
