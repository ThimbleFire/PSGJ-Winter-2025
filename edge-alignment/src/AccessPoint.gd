class_name AccessPoint

enum Axis {
	VERTICAL, HORIZONTAL
}

func _init(point: Dictionary) -> void:
	var dir_x = point["direction"][0]
	var dir_y = point["direction"][1]
	direction = Vector2i(dir_x, dir_y)
	axis = point["axis"]
	length = point["length"]

var direction: Vector2i
var axis: Axis
var length: int
