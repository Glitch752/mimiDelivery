extends SubViewport

@export var cameraNode : Node2D
@export var playerNode : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    world_2d = get_tree().root.world_2d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    cameraNode.position = playerNode.position
