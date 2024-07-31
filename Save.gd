## Define global save parameters here
class_name Save
extends Resource


var excluded_properties = ["RefCounted", "Resource", "resource_local_to_scene",
	"resource_path", "resource_name", "script", "Save.gd", "excluded_properties",
	"FILEPATH"]
var FILEPATH = OS.get_executable_path().get_base_dir().path_join("savefile.sav")

var test_save_data := "This is global persistent data, for node data use metadata"

func _init():
	Kernel.save_data = self


func load():
	if not FileAccess.file_exists(FILEPATH):
		return
	
	var file = FileAccess.open(FILEPATH, FileAccess.READ)
	for property in get_property_list():
		if property["name"] in excluded_properties:
			continue
		set(property["name"], file.get_var())


func save():
	var file = FileAccess.open(FILEPATH, FileAccess.WRITE)
	for property in get_property_list():
		if property["name"] in excluded_properties:
			continue
		file.store_var(get(property["name"]))
