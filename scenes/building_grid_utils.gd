@tool

extends TileMapLayer

@export_tool_button("Assign house addresses")
var assign_addresses = _assign_addresses

@export var house_addresses: Dictionary[Vector2i, int]

func _ready():
    if not Engine.is_editor_hint():
        MapData.set_addresses(house_addresses)

func _assign_addresses():
    house_addresses = {}

    var used_addresses = []
    for building in get_children():
        if building.has_method("set_address"):
            var address = randi() % 999999 + 1
            while address in used_addresses:
                address = randi() % 999999 + 1
            used_addresses.append(address)

            house_addresses[building.get_tile_position()] = address
