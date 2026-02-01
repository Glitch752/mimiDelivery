extends Node

enum BuildingPurpose {
    SHOP,
    DESTINATION,
    DECORATION,
    MRT,
}

var building_data: Dictionary[Vector2i, BuildingData]

## Dictionary[BuildingPurpose, Array[Vector2i]]
var buildings: Dictionary[BuildingPurpose, Array]
