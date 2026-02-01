class_name TasksPanel
extends PanelContainer
## A panel that displays the player's current tasks

@export var task_label_settings: LabelSettings
@export var tasks_list: GridContainer
@export var lose_screen: ColorRect

## The tasks
var tasks: Array[Task]
## The task rows
var task_rows: Array[TaskRow]


func _ready() -> void:
	lose_screen.hide()
	
	# Test tasks
	add_task(Task.new("Blahaj", 1, "Venue", 120))
	add_task(Task.new("Blahaj", 1, "Venue", 10))
	add_task(Task.new("Durian", 2700, "J8 Hotel", 60*19))
	
	remove_task(tasks[0])
	
	TimeManager.time_changed.connect(check_tasks_timed_out)


## Adds a task to tasks and displays it
func add_task(task: Task) -> void:
	# Duplicate the task because we're going to mess with due time
	task = task.duplicate()
	task.calculate_due_time()
	
	tasks.append(task)
	
	var task_row := TaskRow.new()
	task_rows.append(task_row)
	
	task_row.item_label = Label.new()
	task_row.item_label.label_settings = task_label_settings
	task_row.item_label.text = task.item_req
	tasks_list.add_child(task_row.item_label)
	
	task_row.quantity_label = Label.new()
	task_row.quantity_label.label_settings = task_label_settings
	task_row.quantity_label.text = str(task.quantity)
	tasks_list.add_child(task_row.quantity_label)
	
	task_row.destination_label = Label.new()
	task_row.destination_label.label_settings = task_label_settings
	task_row.destination_label.text = task.destination
	tasks_list.add_child(task_row.destination_label)
	
	task_row.time_label = Label.new()
	task_row.time_label.label_settings = task_label_settings
	task_row.time_label.text = "%s of week %d at %d:%02d" % [
			TimeManager.DAY_NAMES[task.due_day],
			task.due_week,
			task.due_hour,
			task.due_minute
	]
	tasks_list.add_child(task_row.time_label)


func remove_task(task: Task) -> void:
	var index: int = tasks.find(task)
	tasks.erase(task)
	
	var task_row: TaskRow = task_rows[index]
	task_rows.remove_at(index)
	
	task_row.destination_label.queue_free()
	task_row.item_label.queue_free()
	task_row.quantity_label.queue_free()
	task_row.time_label.queue_free()


func check_tasks_timed_out() -> void:
	for task in tasks:
		if task.due_week < TimeManager.week:
			lose()
			return
		if task.due_week > TimeManager.week:
			continue
		if task.due_day < TimeManager.day:
			lose()
			return
		if task.due_day > TimeManager.day:
			continue
		if task.due_hour < TimeManager.hour:
			lose()
			return
		if task.due_hour > TimeManager.hour:
			continue
		if task.due_minute < TimeManager.minute:
			lose()
			return


func lose() -> void:
	lose_screen.show()
	get_tree().paused = true
