extends Node

enum BuildingPurpose {
    SHOP,
    DESTINATION,
    DECORATION,
    MRT,
}

var house_addresses: Dictionary[Vector2i, int]

## Dictionary[BuildingPurpose, Array[Vector2i]]
var buildings: Dictionary[BuildingPurpose, Array]
