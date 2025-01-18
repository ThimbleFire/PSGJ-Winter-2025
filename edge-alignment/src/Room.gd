class_name Room

var width: int
var height: int
var chunk: Dictionary
var left: int = 0
var top: int = 0
var parent
var parent_output: Dictionary
var input_direction: Vector2i

var rect:
	get:
		return Rect2i(left, top, width, height)

var get_random_access_point:AccessPoint:
	get:
		var rand = RandomNumberGenerator.new()
		return chunk.entrance[rand.rangei(0, chunk.entrance.size()-1)]
		
var center_x: int:
	get:
		return left + width / 2
		
var center_y: int:
	get:
		return top + height / 2
		
var radius_x: int:
	get:
		return (width - 1) / 2
		
var radius_y: int:
	get:
		return (height - 1) / 2

var center_world: Vector2i:
	get:
		return Vector2i(center_x, center_y)

var position: Vector2i:
	get:
		return Vector2i(left, top)
		
var is_ghost: bool:
	get:
		return chunk == null

func get_prototypes() -> Array[Room]:
	var prototypes: Array[Room]
	for access_point in chunk["access_points"]:
		if access_point["direction"] == input_direction:
			continue
		
		var prototype: Room = Room.new()
		prototype.Init_Ghost(self, access_point)
		prototypes.push_back(prototype)
	return prototypes

func collides_with(other: Room) -> bool:
	return rect.overlaps(other.rect)

func Init_Start() -> void:
	chunk = ResourceRepository.load_file("res://Tiled Data/crossroad.json")

	width = chunk.width
	height = chunk.height

	build()

func Init_Ghost(parent: Room, access_point: Dictionary) -> void:
	var radius_x = 3
	var radius_y = 3

	parent_output = access_point
	var offset: Vector2i = parent_output["direction"]
	input_direction = -parent_output["direction"]

	width = 1 + radius_x * 2
	height = 1 + radius_y * 2

	top = parent.center_y - radius_y
	left = parent.center_x - radius_x

	left += offset.x * (radius_x + parent.radius_x + 1)
	top += offset.y * (radius_y + parent.radius_y + 1)

	self.parent = parent

func Init_Room(parent: Room, access_point: Dictionary, t: bool) -> void:
	parent_output = access_point
	var offset: Vector2i = parent_output["direction"]
	input_direction = -parent_output["direction"]
	chunk = ResourceRepository.get_filtered(input_direction)

	var radius_x = chunk.radius_x
	var radius_y = chunk.radius_y

	width = 1 + radius_x * 2
	height = 1 + radius_y * 2

	top = parent.center_y - radius_y
	left = parent.center_x - radius_x

	left += offset.x * (radius_x + parent.radius_x + 1)
	top += offset.y * (radius_y + parent.radius_y + 1)

	self.parent = parent

func remove_access_point(direction: Vector2i) -> void:
	# this will need to be changed
	chunk.entrance.erase(direction)
	mapfactory.available_entrances -= 1

func build() -> void:
	# use the global tilemap ref to add the room to the game
	mapfactory.available_entrances += chunk["access_points"].size()
	mapfactory.placed_rooms += 1
