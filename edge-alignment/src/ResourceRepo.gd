class_name ResourceRepo extends Node

var database: SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://access_points.db"
	database.open_db()

func load_file(path: String, serialize_direction: bool) -> Dictionary:
	var dataFile = FileAccess.open("res://Tiled Data/" + path, FileAccess.READ)
	var parsedResult = JSON.parse_string(dataFile.get_as_text())
	if !(parsedResult is Dictionary):
		printerr("Can't load json file at path: ", path)
	var result = database.query_with_bindings("SELECT direction FROM AccessPoints WHERE path = ?", [path])
	if !result:
		print("no direction where path is ", path)
		return {}	
	parsedResult["access_points"] = database.query_result.duplicate()
	if serialize_direction:
		var arr = parsedResult["access_points"]
		for i in arr:
			i["direction"] = Vector2i.UP if i["direction"] == 0 else Vector2i.RIGHT if i["direction"] == 1 else Vector2i.DOWN if i["direction"] == 2 else Vector2i.LEFT
	return parsedResult

func get_filtered(doorway) -> Dictionary:
	var dir: int = 0 if doorway == Vector2i.UP else 1 if doorway == Vector2i.RIGHT else 2 if doorway == Vector2i.DOWN else 3
	var query = """
	SELECT path
	FROM AccessPointCounts
	WHERE (CASE 
	WHEN (? >= ?) THEN access_point_count = 1
	ELSE access_point_count > 1 AND access_point_count < ?
	END)
	"""
	var result = database.query_with_bindings(query, [mapfactory.placed_rooms + mapfactory.available_entrances, mapfactory.room_limit, mapfactory.room_limit - mapfactory.placed_rooms + mapfactory.available_entrances])
	var rooms: Array = database.query_result.duplicate()
	query = """
	SELECT path, direction
	FROM AccessPoints
	WHERE direction == ?
	"""
	database.query_with_bindings(query, [dir])
	var query_result: Array = database.query_result
	var suitable_rooms: Array = []
	for room in rooms:
		for row in query_result:
			if row["path"] == room["path"]:
				suitable_rooms.append(room)
				break	
	var path = suitable_rooms.pick_random()["path"]
	print("selected chunk: ", path)
	return load_file(path, true)

func _exit_tree() -> void:
	database.close_db()
