@tool
class_name MetroMap
extends Control

@export var map_size := Vector2i(30, 30)


func _ready() -> void:
    hide()


func _draw() -> void:
    draw_rect(Rect2(Vector2.ZERO, size), Color.WHITE)
    
    for i in MetroLines.LineColor.COUNT:
        var line: MetroLines.LineColor = i as MetroLines.LineColor
        var line_color: Color = MetroLines.HEX_COLORS[line]
        
        var previous_stop: Vector2i
        var current_dir: Vector2i
        
        for stop: Vector2i in MetroLines.LINE_STOPS[line]:
            if previous_stop:
                draw_polyline(create_path(previous_stop, stop, current_dir),
                        line_color, 5)
            
            previous_stop = stop
    
    for i in MetroLines.LineColor.COUNT:
        var line: MetroLines.LineColor = i as MetroLines.LineColor
        var line_color: Color = MetroLines.HEX_COLORS[line]
        
        for stop: Vector2i in MetroLines.LINE_STOPS[line]:
            var previous_stops: int = 0
            for j in line:
                if stop in MetroLines.LINE_STOPS[j]:
                    previous_stops += 1
            
            draw_circle(get_physical_pos(stop), 10, Color.WHITE)
            
            var radius: int = 15 + 10 * previous_stops
            draw_circle(get_physical_pos(stop), radius, line_color, false, 10)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("show_metro_map") and not visible:
        show()
        get_tree().paused = true
    elif event.is_action_pressed("hide_metro_map") and visible:
        hide()
        get_tree().paused = false


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
