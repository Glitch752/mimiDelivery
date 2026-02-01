class_name Intro
extends Control

@export var player: Player
@export var tasks_arrow: Line2D
@export var time_arrow: Line2D

@export var speaker_label: Label
@export var speach_label: Label
@export var next_button: Button

@export var current_dialogue: Dialogue


func _ready() -> void:
	next_button.pressed.connect(_next_dialogue)
	_display_dialogue()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("next"):
		_next_dialogue()


func _next_dialogue() -> void:
	if current_dialogue.next_dialogue:
		current_dialogue = current_dialogue.next_dialogue
		_display_dialogue()
	else:
		hide()
		player.in_intro = false
		TimeManager.start_time()


func _display_dialogue() -> void:
	speaker_label.text = current_dialogue.speaker
	speach_label.text = current_dialogue.speach
	
	tasks_arrow.hide()
	time_arrow.hide()
	
	if current_dialogue.highlight_tasks:
		tasks_arrow.show()
	if current_dialogue.highlight_time:
		time_arrow.show()
