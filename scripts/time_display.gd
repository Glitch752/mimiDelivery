class_name TimeDisplay
extends Control
## A panel that displays the current time

@export var time_label: Label
@export var day_night_label: Label
@export var day_label: Label
@export var week_label: Label


func _ready() -> void:
	TimeManager.time_changed.connect(display_time)
	TimeManager.start_time()


## Update time display
func display_time() -> void:
	time_label.text = "%d:%02d" % [TimeManager.hour, TimeManager.minute]
	day_night_label.text = "(Day)" if TimeManager.is_day() else "(Night)"
	day_label.text = TimeManager.DAY_NAMES[TimeManager.day]
	week_label.text = "Week %d" % TimeManager.week
