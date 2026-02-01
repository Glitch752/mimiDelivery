@tool

extends "res://scenes/level/buildings/base_building.gd"

func _ready():
    if not Engine.is_editor_hint():
        update_label()

func update_label():
    print(MapData.building_data)
    var data = MapData.building_data.get(get_tile_position())
    if data == null:
        push_error("Building data not found for building at position %s" % get_tile_position())
        return
    
    var padded_address = str(data.address).pad_zeros(6)
    $%AddressLabel.text = "Singapurr Residence\n#%s" % padded_address

func get_building_data(id: int) -> BuildingData:
    var data: BuildingData_Destination = building_data.duplicate()
    data.address = id
    return data
