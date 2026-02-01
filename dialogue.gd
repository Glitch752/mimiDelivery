class_name Dialogue
extends Resource

@export var speaker: String
@export var speach: String
@export var next_dialogue: Dialogue


func _init(p_speaker: String = "", p_speach: String = "",
		p_next_dialogue: Dialogue = null) -> void:
	speaker = p_speaker
	speach = p_speach
	next_dialogue = p_next_dialogue
