extends Node2D

enum Purpose {
	SHOP,
	DESTINATION,
	DECORATION,
	MRT,
}

# hide when the player goes behind it
@onready var hide_area: Area2D = $HideArea

@export var tile_size: Vector2i = Vector2i.ONE

## The purpose of this building
@export var purpose: Purpose
## The items this shop can give if it is a shop
@export var items: Array[Item]

func _ready() -> void:
	hide_area.body_entered.connect(_on_body_entered)
	hide_area.body_exited.connect(_on_body_exited)

	set_meta("building", true)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate:a", 0.3, 0.3)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "modulate:a", 1.0, 0.3)
