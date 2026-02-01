@tool

extends TileMapLayer

@export_tool_button("Assign house addresses")
var assign_addresses = _assign_addresses

@export_tool_button("Pregenerate building map")
var pregenerate_building_map = _pregenerate_building_map

@export var house_addresses: Dictionary[Vector2i, int]
## Dictionary[MapData.BuildingPurpose, Array[Vector2i]]
@export var buildings: Dictionary[MapData.BuildingPurpose, Array]

func _ready():
    if not Engine.is_editor_hint():
        MapData.house_addresses = house_addresses
        MapData.buildings = buildings

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

func _pregenerate_building_map():
    buildings = {}
    for purpose in MapData.BuildingPurpose.values():
        buildings[purpose] = []

    for building in get_children():
        if building is Node2D:
            var bldg: Node2D = building
            if bldg.has_method("get_tile_position"):
                var pos: Vector2i = bldg.get_tile_position()
                var purpose: MapData.BuildingPurpose = bldg.purpose
                buildings[purpose].append(pos)
