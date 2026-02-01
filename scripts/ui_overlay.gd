class_name UIOverlay
extends Control

@export var camera: Camera2D


func _ready() -> void:
    size = get_viewport_rect().size
    scale = Vector2(1.0 / camera.zoom.x, 1.0 / camera.zoom.y)
    position = -(size / 2.0) / camera.zoom
