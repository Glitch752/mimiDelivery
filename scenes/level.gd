@tool

extends Node2D

@export_tool_button("Generate map")
var generate_map = _generate_map

@export var map_size: Vector2i = Vector2i.ONE * 20

func _generate_map():
	pass
