extends Node



func _on_volume_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db($VBoxContainer/Volume.value))



func _on_option_button_item_selected(index: int) -> void:
    match index:
        0:
            DisplayServer.window_set_size(Vector2i(1920,1080))
        1:
            DisplayServer.window_set_size(Vector2i(1600,900))
        2:
            DisplayServer.window_set_size(Vector2i(1280,720))
        3:
            DisplayServer.window_set_size(Vector2i(640,480))

func _process(delta: float) -> void:
    var goBack = Input.is_action_just_pressed("back")
    if goBack:
        $VBoxContainer.visible = false
        $"../mainMenu/Label".visible = true
        $"../mainMenu/VBoxContainer".visible = true
