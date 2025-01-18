class_name MapGen extends Node

@onready var tilemap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	#ResourceRepository.populate_database()
	mapfactory.build(tilemap)
	pass
