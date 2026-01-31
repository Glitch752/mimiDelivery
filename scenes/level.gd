@tool

extends Node2D

@export_tool_button("Generate map from polygon")
var generate_map_from_polygon = _generate_map_from_polygon

@export var map_scale_factor: float = 1.0

func _generate_map_from_polygon():
    var points: PackedVector2Array = []
    
    var file = FileAccess.open("res://misc/geojson_parsing/sg_poly.txt", FileAccess.READ)
    if file:
        while not file.eof_reached():
            var line = file.get_line()
            var coords = line.split(" ")
            if coords.size() == 2:
                var x = float(coords[0])
                var y = float(coords[1])
                # Flip y
                points.append(Vector2(x * map_scale_factor, -y * map_scale_factor))
        file.close()
    
    # Don't duplicate the first and last point
    if points.size() > 1 and points[0] == points[points.size() - 1]:
        points.resize(points.size() - 1)
    
    print("Loaded %d points from polygon file" % points.size())


    # The hard part: prevent overlapping line segments by simplifying the polygon in those situations
    points = _remove_overlapping_segments(points)

    $%Landmass.polygon = points
    # Copy to the collision
    $%LandmassCollision.polygon = points

    # Set UVs to a scaled version of the position
    var uvs: PackedVector2Array = []
    for point in points:
        uvs.append(point * 0.01 / map_scale_factor)
    $%Landmass.uv = uvs

func _remove_overlapping_segments(points: PackedVector2Array) -> PackedVector2Array:
    if points.size() < 3:
        return points.duplicate()

    var segments_intersect = func(a1, a2, b1, b2):
        # Returns true if segment a1-a2 intersects b1-b2
        var d = (a2.x - a1.x) * (b2.y - b1.y) - (a2.y - a1.y) * (b2.x - b1.x)
        if d == 0:
            return false # Parallel
        var u = ((b1.x - a1.x) * (b2.y - b1.y) - (b1.y - a1.y) * (b2.x - b1.x)) / d
        var v = ((b1.x - a1.x) * (a2.y - a1.y) - (b1.y - a1.y) * (a2.x - a1.x)) / d
        return (u > 0 and u < 1 and v > 0 and v < 1)

    var cleaned = points.duplicate()
    var changed = true
    while changed:
        changed = false
        var n = cleaned.size()
        for i in range(n):
            var a1 = cleaned[i]
            var a2 = cleaned[(i + 1) % n]
            for j in range(i + 2, i + n - 1):
                var idx1 = j % n
                var idx2 = (j + 1) % n
                var b1 = cleaned[idx1]
                var b2 = cleaned[idx2]
                if segments_intersect.call(a1, a2, b1, b2):
                    # Remove the start point of the second segment (b1)
                    cleaned.remove_at(idx1)
                    changed = true
                    break
            if changed:
                break
    return cleaned
