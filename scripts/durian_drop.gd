class_name DurianDrop
extends Control

signal finish

@export var panel: Panel
@export var bucket: Polygon2D
@export var bucket_area: Area2D
@export var floor: Area2D
@export var durian_scene: PackedScene
@export var progress_bar: ProgressBar
@export var timer: Timer
@export var durian_timer: Timer

var rng = RandomNumberGenerator.new()
var losses_left: int = 3

var active_durians: Array[RigidBody2D] = []
var durian_forces: Array[Vector2] = []


func _ready() -> void:
    bucket.position.x = 0
    bucket_area.body_entered.connect(_on_bucket_body_entered)
    floor.body_entered.connect(_on_floor_body_entered)
    timer.wait_time = 5
    timer.start()
    timer.timeout.connect(_on_timer_timeout)
    durian_timer.timeout.connect(create_durian)
    create_durian()


func _process(delta: float) -> void:
    progress_bar.value = timer.time_left
    
    if Input.is_action_pressed("left"):
        bucket.position.x -= 250 * delta
    if Input.is_action_pressed("right"):
        bucket.position.x += 250 * delta
    
    if bucket.position.x > panel.size.x / 2.0 - 15:
        bucket.position.x = panel.size.x / 2.0 - 15
    elif bucket.position.x < -panel.size.x / 2.0 + 15:
        bucket.position.x = -panel.size.x / 2.0 + 15
    
    for i in len(active_durians):
        var durian: RigidBody2D = active_durians[i]
        var force: Vector2 = durian_forces[i]
        
        durian.apply_force(force * delta)


func create_durian() -> void:
    var x: float = randf_range(-panel.size.x / 2.0 + 32, 
            panel.size.x / 2.0 - 32)
    var durian: RigidBody2D = durian_scene.instantiate()
    
    add_child(durian)
    durian.position = Vector2(x, -50)
    
    var angle: float = randf_range(4 * PI / 3, 5 * PI / 3)
    active_durians.append(durian)
    durian_forces.append(Vector2.from_angle(angle) * 9)
    
    durian_timer.wait_time *= 0.9
    durian_timer.start()


func _on_bucket_body_entered(body: Node2D) -> void:
    if body.is_in_group("durian"):
        var i: int = active_durians.find(body)
        active_durians.remove_at(i)
        durian_forces.remove_at(i)
        body.queue_free()


func _on_floor_body_entered(body: Node2D) -> void:
    if body.is_in_group("durian"):
        var i: int = active_durians.find(body)
        active_durians.remove_at(i)
        durian_forces.remove_at(i)
        body.queue_free()
        losses_left -= 1
        if losses_left <= 0:
            _lose()


func _lose() -> void:
    visible = false
    finish.emit()


func _on_timer_timeout() -> void:
    visible = false
    InventoryItems.gain_item(preload("res://items/durian.tres"), 1)
    finish.emit()
