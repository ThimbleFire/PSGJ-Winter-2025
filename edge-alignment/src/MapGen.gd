class_name MapGen extends Node

@onready var tilemap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	#ResourceRepository.populate_database()
	mapfactory.build(tilemap)
	pass

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		mapfactory.next()
		pass
