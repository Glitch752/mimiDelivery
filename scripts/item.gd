class_name Item
extends Resource

@export var item_name: StringName
@export var texture: Texture2D


func _init(p_item_name: StringName = "", p_texture: Texture2D = null) -> void:
    item_name = p_item_name
    texture = p_texture
