@tool
class_name MRT
extends BaseBuilding

func _ready():
    super._ready()
    
    interaction_area.body_entered.connect(_on_body_entered_interact)

func _on_body_entered_interact(body: Node) -> void:
    if body.is_in_group("player"):
        var metro_map: MetroMap = body.metro_map
        metro_map.show_map()
        metro_map.travel_mode = true
        metro_map.travel_source = get_tile_position()
