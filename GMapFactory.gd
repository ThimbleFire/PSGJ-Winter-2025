class_name MapFactory

var available_entrances: int = 0
var placed_rooms: int = 0

func build(seed: int = 0) -> void:
  placed_rooms = 0
  available_entrances = 0

  var rand = RandomNumberGenerator.new()
  var rooms = [Room.new()]
  var prototypes = rooms.front().get_prototypes()

  while !prototypes.is_empty():
    var index: int = rand.rangei(0, prototypes.size() - 1)
    var prototype = prototypes[index]

    var parent: Room = prototype.parent

    var child = Room.new()
    child.initialize(parent, prototype.parent_output, true)

    child_prototypes = child.get_prototypes()

    var result = room_collide(child, rooms)
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

  print("Placed rooms: ", placed_rooms, " / ", BoardManager.room_limit)

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
