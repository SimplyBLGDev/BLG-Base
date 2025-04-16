class_name Debug_Commands
extends Node


func clear():
	clearconsole()


func clearconsole():
	(get_parent() as Debug_CommandConsole).clear()


func setspeed(speed = "1.0"):
	if not speed.is_valid_float():
		Kernel.Debug.print_to_cmd_log("Speed must be valid float")
		return
	
	var new_speed := float(speed)
	Engine.time_scale = new_speed


func language(locale):
	if locale == "":
		Kernel.Debug.print_to_cmd_log("Invalid locale")
		return
	
	TranslationServer.set_locale(locale)
	
	var current_locale := TranslationServer.get_locale()
	Kernel.Debug.print_to_cmd_log("Locale set to {0}".format(current_locale))
