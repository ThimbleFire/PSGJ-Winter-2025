class_name MapFactory extends Node

var available_entrances: int = 0
var placed_rooms: int = 0

func build() -> void:
	placed_rooms = 0
	available_entrances = 0

	var rand = RandomNumberGenerator.new()
	var rooms = [Room.new()]
	rooms.front().Init_Start()
	var prototypes = rooms.front().get_prototypes()

	while !prototypes.is_empty():
		var index: int = rand.randi_range(0, prototypes.size() - 1)
		var prototype = prototypes[index]

		var parent: Room = prototype.parent

		var child = Room.new()
		child.Init_Room(parent, prototype.parent_output, true)

		var child_prototypes: Array[Room] = child.get_prototypes()

		var result: bool = room_collide(child, rooms)
		if result: 
			continue

		result = rooms_collide(child_prototypes, rooms)
		if result:
			continue

		prototypes.erase(prototype)

		result = room_collide(child, prototypes)
		if result:
			prototypes.add(prototype)
			continue

		rooms.push_back(child)
		parent.remove_access_point(child.parent_output.direction)
		prototypes.add_range(child.get_prototypes())
		child.build()
		child.remove_access_point(child.input_direction)

	print("Placed rooms: ", placed_rooms)

func rooms_collide(children: Array[Room], rooms: Array[Room]) -> bool:
	for room in children:
		if room_collide(room, rooms):
			return true
	return false

func room_collide(room: Room, rooms: Array[Room]) -> bool:
	for item in rooms:
		if room.collides_with(item):
			if item.parent == room:
				continue
		return true
	return false
