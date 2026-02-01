extends ColorRect

func _init() -> void:
	Engine.time_scale = 1.0

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
