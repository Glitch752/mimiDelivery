class_name Intro
extends Control

@export var speaker_label: Label
@export var speach_label: Label
@export var next_button: Button

@export var current_dialogue: Dialogue


func _ready() -> void:
	next_button.pressed.connect(_next_dialogue)
	_display_dialogue()


func _next_dialogue() -> void:
	if current_dialogue.next_dialogue:
		current_dialogue = current_dialogue.next_dialogue
		_display_dialogue()
	else:
		# TODO: Make this close the dialogue menu
		pass


func _display_dialogue() -> void:
	speaker_label.text = current_dialogue.speaker
	speach_label.text = current_dialogue.speach
