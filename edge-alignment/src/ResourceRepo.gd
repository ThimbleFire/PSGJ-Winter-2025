class_name ResourceRepo extends Node

var database: SQLite

func _ready() -> void:
	database = SQLite.new()
	database.path = "res://access_points.db"
	database.open_db()

func load_file(path: String, serialize_direction: bool) -> Dictionary:
	var dataFile = FileAccess.open(path, FileAccess.READ)
	var parsedResult = JSON.parse_string(dataFile.get_as_text())
	if !(parsedResult is Dictionary):
		printerr("Can't load json file at path: ", path)
	if serialize_direction:
		var arr = parsedResult["access_points"]
		for i in arr:
			i["direction"] = Vector2i.UP if i["direction"] == 0 else Vector2i.RIGHT if i["direction"] == 1 else Vector2i.DOWN if i["direction"] == 2 else Vector2i.LEFT
	return parsedResult

func populate_database() -> void:
	var keystone_path = "res://Tiled Data/"
	database.query("DELETE FROM AccessPoints;")
	database.query("DELETE FROM AccessPointCounts;")
	
	var dir = DirAccess.open(keystone_path)
	if not dir:
		print("failed to open directory")
		return
		
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file.ends_with(".json"):
			print("loading ", keystone_path, file)
			var data: Dictionary = load_file(keystone_path + file, false)
			for access_point in data["access_points"]:
				access_point["path"] = file 
				database.insert_row("AccessPoints", access_point)
			database.insert_row("AccessPointCounts", {"path": file, "access_point_count": data["access_points"].size()})
		file = dir.get_next()
	dir.list_dir_end()
	database.close_db()

func get_filtered(doorway) -> Dictionary:
	var dir: int = 0 if doorway == Vector2i.UP else 1 if doorway == Vector2i.RIGHT else 2 if doorway == Vector2i.DOWN else 3
	
	#mapfacotry.placed_rooms + mapfactory.available_entrances <= room_limit? if true: return paths where access_point_count is greater than 1, else return access_point_count where access_point_count is equal to 1 
	var query = """
		SELECT path
		FROM AccessPointCounts
		WHERE (CASE 
		WHEN (? + ? <= ?) THEN access_point_count > 1
		ELSE access_point_count = 1
		END)
		"""
		
	var result = database.query_with_bindings(query, [mapfactory.placed_rooms, mapfactory.available_entrances, mapfactory.room_limit])
	if !result:
		print("no valid paths found")
	
	var rooms_whos_exit_points_do_not_exceed_room_limit: Array = database.query_result
	
	query = """
		SELECT path
		FROM AccessPoints
		WHERE direction == ?
		"""
	result = database.query_with_bindings(query, [dir])
	if !result:
		print("no valid paths found")
		
	var suitable_rooms: Array = database.query_result
	
	return load_file("res://Tiled Data/" + suitable_rooms.pick_random()["path"], true)

func _exit_tree() -> void:
	database.close_db()
