extends Node
## A node that keeps track of the current ingame time

## Emitted every time the time changes
signal time_changed()

## How many seconds of real time is a minute of game time?
const MINUTE_LENGTH: float = 1.0
## The day names
const DAY_NAMES: Array[String] = [
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday",
]

## The current week number
## [br]Starts at week 1
var week: int
## The current day of the week (Monday = 0)
## [br]Starts on Monday
var day: int
## The current hour
## [br]Starts as 8:00
var hour: int
## The current minute
## [br]Starts at -1 so it becomes 0 when the time starts
var minute: int


## Start the game time
func start_time() -> void:
	# Normal start time (could be changed)
	week = 1
	day = 0
	hour = 8
	minute = -1
	
	# Dawn (Uncomment to enable)
	#week = 1
	#day = 0
	#hour = 6
	#minute = 59
	
	# Dusk (Uncomment to enable)
	#week = 1
	#day = 0
	#hour = 17
	#minute = 59
	
	next_minute()


## Increments minute and create a timer to automatically do it again
## [br]Increments other time units as necessary
func next_minute() -> void:
	minute += 1
	
	if minute == 60:
		minute = 0
		_next_hour()
	
	var timer: SceneTreeTimer = get_tree().create_timer(MINUTE_LENGTH)
	timer.timeout.connect(next_minute)
	
	time_changed.emit()

## Determines if it is day time
## [br]Hours based on 2025 fall equinox sunrise/sunset times
## ([url=https://www.timeanddate.com/sun/singapore/singapore?month=9&year=2025]
##September 23rd[/url])
func is_day() -> bool:
	return hour >= 7 and hour < 19


# Increments the hour number
# Increments other time units as necessary
func _next_hour() -> void:
	hour += 1
	
	if hour == 24:
		hour = 0
		_next_day()


# Increments the day number
# Increments other time units as necessary
func _next_day() -> void:
	day += 1
	
	if day == 7:
		day = 0
		_next_week()


# Increments the week number
# Is the biggest time unit (No wrapping)
func _next_week() -> void:
	week += 1
