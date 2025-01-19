class_name MapGen extends Node

@onready var tilemap: TileMapLayer = $TileMapLayer

func _ready() -> void:
	mapfactory.build(tilemap)
