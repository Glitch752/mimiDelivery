class_name Dialogue
extends Resource

@export var speaker: String
@export var speach: String
@export var next_dialogue: Dialogue
@export var highlight_tasks: bool
@export var highlight_time: bool


func _init(p_speaker: String = "", p_speach: String = "",
        p_next_dialogue: Dialogue = null, p_highlight_tasks: bool = false,
        p_highlight_time: bool = false) -> void:
    speaker = p_speaker
    speach = p_speach
    next_dialogue = p_next_dialogue
    highlight_tasks = p_highlight_tasks
    highlight_time = p_highlight_time
