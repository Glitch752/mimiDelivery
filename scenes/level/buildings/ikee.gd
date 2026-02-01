@tool

extends "res://scenes/level/buildings/base_building.gd"

func _ready():
    super._ready()
    
    interaction_area.body_entered.connect(_on_body_entered_interact)

func _on_body_entered_interact(body: Node) -> void:
    if body.is_in_group("player"):
         body.open_minigame(preload("res://scenes/catchBlahaj.tscn"))
