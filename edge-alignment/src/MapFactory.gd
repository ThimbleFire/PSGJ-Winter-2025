class_name MapFactory extends Node

var available_entrances: int = 0
var placed_rooms: int = 0
var room_limit = 16
var board_size = 128

func build(tilemap: TileMapLayer) -> void:
	placed_rooms = 0
	available_entrances = 0

	var rand = RandomNumberGenerator.new()
	var rooms: Array[Room] = [Room.new()]
	rooms.front().Init_Start(tilemap)
	var prototypes: Array = rooms.front().get_prototypes()

	while !prototypes.is_empty():
		var index: int = rand.randi_range(0, prototypes.size() - 1)
		var prototype = prototypes[index]

		var parent: Room = prototype.parent

		var child = Room.new()
		child.Init_Room(parent, prototype.parent_output, true, tilemap)

		var result = is_in_bounds([child])
		if !result:
			continue

		var child_prototypes: Array[Room] = child.get_prototypes()

		result = is_in_bounds(child_prototypes)
		if !result:
			continue

		result = room_collide(child, rooms)
		if result: 
			continue

		result = rooms_collide(child_prototypes, rooms)
		if result:
			continue

		prototypes.erase(prototype)

		result = room_collide(child, prototypes)
		if result:
			prototypes.push_back(prototype)
			continue

		rooms.push_back(child)
		parent.remove_access_point(child.parent_output["direction"])
		prototypes.append_array(child.get_prototypes())
		child.build()
		child.remove_access_point(child.input_direction)

	print("Placed rooms: ", placed_rooms)

func rooms_collide(children: Array[Room], rooms: Array[Room]) -> bool:
	for room: Room in children:
		if room_collide(room, rooms):
			return true
	return false

func room_collide(room: Room, rooms: Array[Room]) -> bool:
	for other: Room in rooms:
		if room.rect.intersects(other.rect):
			if other.parent == room:
				continue
			return true
	return false
	
func is_in_bounds(rooms:Array[Room]) -> bool:
	for room in rooms:
		if room.left < 2 or room.left > mapfactory.board_size - 2:
			return false
		if room.top < 2 or room.top > mapfactory.board_size - 2:
			return false
		if room.right < 2 or room.right > mapfactory.board_size - 2:
			return false
		if room.bottom < 2 or room.bottom > mapfactory.board_size - 2:
			return false
	return true
