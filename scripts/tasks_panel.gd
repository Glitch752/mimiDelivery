class_name TasksPanel
extends PanelContainer
## A panel that displays the player's current tasks

@export var task_label_settings: LabelSettings
@export var tasks_list: GridContainer

## The tasks
var tasks: Array[Task]


func _ready() -> void:
	# Test tasks
	add_task(Task.new("Blahaj", 1, "Venue", 120))
	add_task(Task.new("Durian", 2700, "J8 Hotel", 60*19))


## Adds a task to tasks and displays it
func add_task(task: Task) -> void:
	# Duplicate the task because we're going to mess with due time
	task = task.duplicate()
	task.calculate_due_time()
	
	tasks.append(task)
	
	var item_label := Label.new()
	item_label.label_settings = task_label_settings
	item_label.text = task.item_req
	tasks_list.add_child(item_label)
	
	var quantity_label := Label.new()
	quantity_label.label_settings = task_label_settings
	quantity_label.text = str(task.quantity)
	tasks_list.add_child(quantity_label)
	
	var destination_label := Label.new()
	destination_label.label_settings = task_label_settings
	destination_label.text = task.destination
	tasks_list.add_child(destination_label)
	
	var time_label := Label.new()
	time_label.label_settings = task_label_settings
	time_label.text = "%s of week %d at %d:%02d" % [
			TimeManager.DAY_NAMES[task.due_day],
			task.due_week,
			task.due_hour,
			task.due_minute
	]
	tasks_list.add_child(time_label)
