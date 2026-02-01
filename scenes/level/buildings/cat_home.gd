@tool

extends "res://scenes/level/buildings/base_building.gd"

func _ready():
    if not Engine.is_editor_hint():
        update_label()

func update_label():
    var padded_address = str(MapData.house_addresses.get(get_tile_position())).pad_zeros(6)
    $%AddressLabel.text = "Singapurr Residence\n#%s" % padded_address
