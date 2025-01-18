class_name MapGen extends Node

func _ready() -> void:
	#ResourceRepository.populate_database()
	mapfactory.build()
	pass
