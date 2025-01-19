class_name MapFactory extends Node

var available_entrances: int = 0
var placed_rooms: int = 0
var room_limit = 256
var board_size = 32

func build(tilemap: TileMapLayer) -> void:
	placed_rooms = 0
	available_entrances = 0

	var rand = RandomNumberGenerator.new()
	var rooms: Array[Room] = [Room.new()]
	rooms.front().Init_Start(tilemap)
	var prototypes: Array = rooms.front().get_prototypes()
	print("added ghost. Count at: ", prototypes.size())

	while !prototypes.is_empty():
		var index: int = rand.randi_range(0, prototypes.size() - 1)
		var prototype = prototypes[index]

		var parent: Room = prototype.parent

		var child = Room.new()
		child.Init_Room(parent, prototype.parent_output, tilemap)

		var child_prototypes: Array[Room] = child.get_prototypes()

  var result: bool
		result = room_collide(child, rooms)
		if result: 
			continue

		result = rooms_collide(child_prototypes, rooms)
		if result:
			continue

		result = rooms_collide(child_prototypes, prototypes)
		if result:
			continue
		print("removed ghost. Count at: ", prototypes.size())
		prototypes.erase(prototype)

		result = room_collide(child, prototypes)
		if result:
			prototypes.push_back(prototype)
			print("added ghost. Count at: ", prototypes.size())
			continue

		rooms.push_back(child)
		parent.remove_access_point(child.parent_output["direction"])
		prototypes.append_array(child.get_prototypes())
		print("added ghost. Count at: ", prototypes.size())
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