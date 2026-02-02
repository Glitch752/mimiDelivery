@tool
class_name MetroMap
extends Control

@export var building_grid: TileMapLayer
@export var player: Player

@export var map_size := Vector2i(30, 30)

var travel_mode: bool = false
var travel_source: Vector2i

var reachable_points: Array[Vector2i]


func _ready() -> void:
    hide()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color(1,1,1,0.3))
    
    for i in MetroLines.LineColor.COUNT:
        var line: MetroLines.LineColor = i as MetroLines.LineColor
        var line_color: Color = MetroLines.HEX_COLORS[line]
        var width_bonus: int = 0
        if travel_mode and travel_source in MetroLines.LINE_STOPS[line]:
            width_bonus = 6
        
        var previous_stop: Vector2i
        var current_dir: Vector2i
        
        for stop: Vector2i in MetroLines.LINE_STOPS[line]:
            if previous_stop:
                draw_polyline(create_path(previous_stop, stop, current_dir),
                        line_color, 8 + width_bonus)
            
            previous_stop = stop
    
    reachable_points = []
    
    for i in MetroLines.LineColor.COUNT:
        var line: MetroLines.LineColor = i as MetroLines.LineColor
        var line_color: Color = MetroLines.HEX_COLORS[line]
        var width_bonus: int = 0
        if travel_mode and travel_source in MetroLines.LINE_STOPS[line]:
            width_bonus = 2
        
        for stop: Vector2i in MetroLines.LINE_STOPS[line]:
            var previous_stops: int = 0
            for j in line:
                if stop in MetroLines.LINE_STOPS[j]:
                    previous_stops += 1
            
            if width_bonus > 0 and stop != travel_source:
                reachable_points.append(stop)
            else:
                draw_circle(get_physical_pos(stop), 10, Color.WHITE)
            
            var radius: int = 15 + 10 * previous_stops
            draw_circle(get_physical_pos(stop), radius, line_color, false,
                    10 + width_bonus)
    
    for stop in reachable_points:
        draw_circle(get_physical_pos(stop), 10, Color(0.7, 0.7, 0.7))
    
    var hovered_point: Vector2i = reachable_point_hovered()
    if hovered_point > Vector2i(-1000, -1000):
        draw_circle(get_physical_pos(hovered_point), 10, Color(0.4, 0.4, 0.4))


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("show_metro_map") and not visible:
        show_map()
    elif event.is_action_pressed("hide_metro_map") and visible:
        hide_map()
    elif event is InputEventMouseMotion and visible:
        queue_redraw()
    elif event is InputEventMouseButton and visible:
        if event.button_mask == MOUSE_BUTTON_MASK_LEFT and event.pressed:
            var hovered_point: Vector2i = reachable_point_hovered()
            if hovered_point > Vector2i(-1000, -1000):
                var global_pos: Vector2 = building_grid.to_global(
                        building_grid.map_to_local(hovered_point))
                player.global_position = global_pos
                hide_map()


func show_map() -> void:
    show()
    get_tree().paused = true


func hide_map() -> void:
    hide()
    get_tree().paused = false
    travel_mode = false


func get_physical_pos(map_pos: Vector2i) -> Vector2:
    return size * (Vector2(map_pos) / Vector2(map_size) + Vector2(0.5, 0.5))


func create_path(start: Vector2i, end: Vector2i, source_dir: Vector2i
        ) -> PackedVector2Array:
    var points := PackedVector2Array([start])
    
    var new_point: Vector2i = start + source_dir
    var current_dir: Vector2i = source_dir
    
    if current_dir == Vector2i(0, 0):
        current_dir = (end - start).sign()
    
    while new_point != end:
        var next_pos: Vector2i = new_point + current_dir
        
        if new_point.x == end.x:
            if current_dir.x != 0:
                points.append(new_point)
                
                current_dir.x = 0
                continue
        elif new_point.y == end.y:
            if current_dir.y != 0:
                points.append(new_point)
                
                current_dir.y = 0
                continue
        elif current_dir.x == 0:
            points.append(new_point)
            
            current_dir.x = sign(end.x - new_point.x)
            continue
        elif current_dir.y == 0:
            points.append(new_point)
            
            current_dir.y = sign(end.y - new_point.y)
            continue
        elif sign(current_dir.x) != sign((end - new_point).x):
            points.append(new_point)
            
            current_dir.x = 0
            continue
        elif sign(current_dir.y) != sign((end - new_point).y):
            points.append(new_point)
            
            current_dir.y = 0
            continue
        
        new_point = next_pos
    
    points.append(end)
    
    for i in len(points):
        points[i] = get_physical_pos(points[i])
    
    return points


func reachable_point_hovered() -> Vector2i:
    for point in reachable_points:
        if Geometry2D.is_point_in_circle(get_local_mouse_position(),
                get_physical_pos(point), 20):
            return point
    
    return Vector2i(-1000, -1000)
