extends Node

enum LineColor {
    RED,
    YELLOW,
    GREEN,
    BLUE,
    COUNT,
}

const HEX_COLORS: Array[Color] = [
    Color(1, 0, 0),
    Color(1, 0.8, 0),
    Color(0, 1, 0),
    Color(0, 0, 1),
]

const LINE_STOPS: Array[Array] = [
    RED_LINE,
    YELLOW_LINE,
    GREEN_LINE,
    [],
]

const RED_LINE: Array[Vector2i] = [
    Vector2i(-2, 0),
    Vector2i(-5, 3),
    Vector2i(-2, 4),
    Vector2i(1, 5),
    Vector2i(4, 3),
    Vector2i(1, 0),
]

const YELLOW_LINE: Array[Vector2i] = [
    Vector2i(1, 5),
    Vector2i(-2, 0),
    Vector2i(-4, -3),
    Vector2i(-2, -7),
]

const GREEN_LINE: Array[Vector2i] = [
    Vector2i(-4, -3),
    Vector2i(-1, -5),
    Vector2i(2, -7),
    Vector2i(4, -5),
    Vector2i(1, 0),
]
