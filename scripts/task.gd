class_name Task
extends Resource

@export var item_req: String
@export var quantity: int = 1
@export var destination: String
@export var time_to_complete: int = 60

var due_minute: int
var due_hour: int
var due_day: int
var due_week: int


func _init(p_item_req: String = "", p_quantity: int = 1,
		p_destination: String = "", p_time_to_complete: int = 60) -> void:
	item_req = p_item_req
	quantity = p_quantity
	destination = p_destination
	time_to_complete = p_time_to_complete


func calculate_due_time() -> void:
	due_minute = time_to_complete % 60
	var time_left: int = roundi((time_to_complete - due_minute) / 60.0)
	
	due_hour = time_left % 24
	time_left = roundi((time_left - due_hour) / 24.0)
	
	due_day = time_left % 7
	time_left = roundi((time_left - due_day) / 7.0)
	
	due_week = time_left
