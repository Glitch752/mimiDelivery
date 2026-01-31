@tool

extends TileMapLayer

@export_tool_button("tile roads")
var tile_roads = _tile_roads

@export var building_grid: TileMapLayer

func _tile_roads():
    clear()

    var building_rect = building_grid.get_used_rect()

    var bpos = building_rect.position
    var bsize = building_rect.size

    var _get_building_size = func(pos: Vector2i) -> Vector2i:
        var scene_pos =\
            building_grid.to_global(building_grid.map_to_local(pos + Vector2i.LEFT + Vector2i.UP))
        # godot is silly and doesn't let us access a scene tile map's scene directly
        # so we iterate over the tilemap's children and find the building there
        for child in building_grid.get_children():
            if (child as Node2D).global_position == scene_pos:
                return child.tile_size
        
        return Vector2i.ZERO
    
    # var used_cells = building_grid.get_used_cells()
    for x in range(bpos.x, bpos.x + bsize.x + 1):
        for y in range(bpos.y, bpos.y + bsize.y + 1):
            var cell = Vector2i(x, y)
            
            var this_size = _get_building_size.call(cell)
            var up_size = _get_building_size.call(cell + Vector2i.UP)
            var right_size = _get_building_size.call(cell + Vector2i.RIGHT)
            var left_size = _get_building_size.call(cell + Vector2i.LEFT)
            var down_size = _get_building_size.call(cell + Vector2i.DOWN)

            var road_up_blocked = this_size.x == 2 or (up_size.y == 2 and up_size.x == 2)
            var road_right_blocked = right_size.y == 2 or (this_size.y == 2 and this_size.x == 2)
            var road_left_blocked = this_size.y == 2 or (left_size.x == 2 and left_size.y == 2)
            var road_down_blocked = down_size.x == 2 or (this_size.x == 2 and this_size.y == 2)

            # var tile = 0 if road_up_blocked else 1
            var tile = 0
            var flip_h = false
            if road_up_blocked and road_right_blocked and road_left_blocked and road_down_blocked:
                tile = -1
            elif road_left_blocked and road_right_blocked:
                tile = 5
            elif road_up_blocked and road_down_blocked:
                tile = 4
            elif road_up_blocked:
                tile = 1
            elif road_down_blocked:
                tile = 2
            elif road_left_blocked:
                tile = 3
            elif road_right_blocked:
                tile = 3
                flip_h = true
            
            if tile == -1:
                continue
            
            # Set the tile
            set_cell(cell, 0, Vector2i(tile, 0), TileSetAtlasSource.TRANSFORM_FLIP_H if flip_h else 0)
    print("tiled roads")            
