class_name TimeDisplay
extends Control
## A panel that displays the current time

## The node that gets the day/night filter applied to it
@export var day_night_filter_parent: CanvasItem

## Label that displays current time
@export var time_label: Label
## Label that displays if it is day or night
@export var day_night_label: Label
## Label that displays current day
@export var day_label: Label
## Label that displays current week number
@export var week_label: Label

## The color of the night filter
@export var day_filter := Color(1, 1, 1)
## The color of the day filter
@export var night_filter := Color(0.5, 0.7, 1.0)


func _ready() -> void:
    TimeManager.time_changed.connect(display_time)


## Update time display
func display_time() -> void:
    time_label.text = "%d:%02d" % [TimeManager.hour, TimeManager.minute]
    day_night_label.text = "(Day)" if TimeManager.is_day() else "(Night)"
    day_label.text = TimeManager.DAY_NAMES[TimeManager.day]
    week_label.text = "Week %d" % TimeManager.week
    
    day_night_filter_parent.modulate = get_filter_color()


func get_filter_color() -> Color:
    if not TimeManager.is_day():
        return Color(0.5, 0.7, 1.0)
    elif TimeManager.hour == 7:
        return night_filter.lerp(day_filter, TimeManager.minute / 60.0)
    elif TimeManager.hour == 18:
        return day_filter.lerp(night_filter, TimeManager.minute / 60.0)
    return Color(1, 1, 1)
