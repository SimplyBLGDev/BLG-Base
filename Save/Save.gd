## Define global save parameters here
class_name Save
extends Resource

const DEFAULT_FILE_NAME := "game.sav"
const EXCLUDED_PROPERTIES = ["RefCounted", "Resource", "resource_local_to_scene",
	"resource_path", "resource_name", "script", "Save.gd", "EXCLUDED_PROPERTIES",
	"FILEPATH", "DEFAULT_FILE_NAME"]
var FILEPATH: String

# Persistent variables go here, accesible in runtime as Kernel.Save.<your_var_here>

static func from_file(path: String) -> Save:
	var loaded_save := Save.new()
	if path == "":
		var game_directory := OS.get_executable_path().get_base_dir()
		loaded_save.FILEPATH = game_directory.path_join(DEFAULT_FILE_NAME)
	else:
		loaded_save.FILEPATH = path
	
	if not FileAccess.file_exists(loaded_save.FILEPATH):
		return loaded_save
	
	var file = FileAccess.open(path, FileAccess.READ)
	for property in loaded_save.get_property_list():
		if property["name"] in EXCLUDED_PROPERTIES:
			continue
		loaded_save.set(property["name"], file.get_var())
	
	return loaded_save


func write_to_disk():
	if not Kernel.launch_settings.enable_persistence:
		return
	
	var file = FileAccess.open(FILEPATH, FileAccess.WRITE)
	for property in get_property_list():
		if property["name"] in EXCLUDED_PROPERTIES:
			continue
		file.store_var(get(property["name"]))
