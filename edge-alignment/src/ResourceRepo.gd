class_name ResourceRepo extends Node

func load_file(path: String) -> Dictionary:
	var dataFile = FileAccess.open(path, FileAccess.READ)
	var parsedResult = JSON.parse_string(dataFile.get_as_text())
	if !(parsedResult is Dictionary):
		printerr("Can't load json file at path: ", path)
	for i in parsedResult["access_points"]:
		i["direction"] = Vector2i(i["direction"][0], i["direction"][1])
	return parsedResult

func load_candidate(parentDir: AccessPoint) -> void:
	pass
