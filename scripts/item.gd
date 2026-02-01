class_name Item
extends Resource

@export var item_name: StringName


func _init(p_item_name: StringName = "") -> void:
	item_name = p_item_name
