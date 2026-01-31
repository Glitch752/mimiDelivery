extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_pressed() -> void:
	print("settings pressed")
	$mainMenu/Label.visible = false
	$mainMenu/VBoxContainer.visible = false
	$settings/VBoxContainer.visible = true


func _on_start_pressed() -> void:
	print("start pressed")
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	print("exit pressed")
	get_tree().quit()
	pass # Replace with function body.
