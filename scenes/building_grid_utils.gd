@tool

extends TileMapLayer

@export_tool_button("Generate building data")
var assign_addresses = _assign_addresses

@export_tool_button("Pregenerate building map")
var pregenerate_building_map = _pregenerate_building_map

@export var building_data: Dictionary[Vector2i, BuildingData]
## Dictionary[MapData.BuildingPurpose, Array[Vector2i]]
@export var buildings: Dictionary[MapData.BuildingPurpose, Array]

func _ready():
    if not Engine.is_editor_hint():
        MapData.building_data = building_data
        MapData.buildings = buildings

func _assign_addresses():
    building_data = {}

    var used_ids = []
    for building in get_children():
        var id = randi() % 999999 + 1
        while id in used_ids:
            id = randi() % 999999 + 1
        used_ids.append(id)

        building_data[building.get_tile_position()] = building.get_building_data(id)


func _pregenerate_building_map():
    buildings = {}
    for purpose in MapData.BuildingPurpose.values():
        buildings[purpose] = []

    for building in get_children():
        if building is Node2D:
            var bldg: Node2D = building
            if bldg.has_method("get_tile_position"):
                var pos: Vector2i = bldg.get_tile_position()
                var purpose: MapData.BuildingPurpose = bldg.building_data.purpose
                buildings[purpose].append(pos)
