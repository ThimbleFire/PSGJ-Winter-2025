class_name Room

var width: int
var height: int
var chunk
var left: int = 0
var top: int = 0
var parent
var parent_output: AccessPoint
var input_direction: Vector2i

var rect:
  get:
    return Rect.new(position.x, position.y, width, height)

var get_random_access_point():
  get:
    var rand = RandomNumberGenerator.new()
    return chunk.entrance[rand.rangei(0, chunk.entrance.size()-1)]

func collides_with(other: Room) -> bool:
  return rect.overlaps(other.rect)

func Init_Start() -> void:
  chunk = ResourceRepository.Town

  self.left = BoardManager.width / 2
  self.top = BoardManager.height / 2

  width = chunk.width
  height = chunk.height

  build()

func Init_Ghost(parent: Room, access_point: AccessPoint) -> void:
  var radius_x = 3
  var radius_y = 3

  parent_output = access_point
  var offset: Vector2i = parent_output.direction
  input_direction = -parent_output.direction

  width = 1 + radius_x * 2
  height = 1 + radius_y * 2

  top = parent.center_y - radius_y
  left = parent.center_x - radius_x

  left += offset.x * (radius_x + parent.radius_x + 1)
  top += offset.y * (radius_y + parent.radius_y + 1)

  self.parent = parent

func Init_Room(parent: Room, access_point: AccessPoint, bool t) -> void:
  parent_output = access_point
  offset: Vector2i = parent_output.direction
  input_direction = -parent_output.direction
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
  if entrance_direction == direction:
    chunk.entrance.erase(entrance_direction)
  MapFactory.available_entrances -= 1

func build() -> void:
  # use the global tilemap ref to add the room to the game

  MapFactory.available_entrances += chunk.entrance.size()
  MapFactory.placed_rooms += 1
  pass
