class_name Player
extends CharacterBody2D

const SPEED = 50.0
const ACCEL = 1800.0

@export var particles: GPUParticles2D
@export var tasks_panel: TasksPanel
@export var metro_map: MetroMap

var disabled: bool = true


func _physics_process(delta: float) -> void:
    if disabled:
        return
    
    var directionX := Input.get_axis("left","right")
    var directionY := Input.get_axis("up","down")
    if directionX:
        velocity.x = move_toward(velocity.x, directionX * SPEED, ACCEL * delta)
        if directionX > 0:
            $Sprite2D.flip_h = true
        else:
            $Sprite2D.flip_h = false
    else:
        velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
    if directionY:
        velocity.y = move_toward(velocity.y, directionY * SPEED, ACCEL * delta)
    else:
        velocity.y = move_toward(velocity.y, 0, ACCEL * delta)
    
    if directionY or directionX:
        print("play")
        if not $Footstep.playing:
            $Footstep.play()
    else:
        $Footstep.stop()
        print("stop")
    
    var time = Time.get_ticks_msec() / 1000.0
    $Sprite2D.rotation = sin(time * 20.0) * (velocity.length() / SPEED) * deg_to_rad(5)

    if velocity.length() > SPEED * 0.1:
        # Set animtion to the nearest direction
        var direction_animations = {
            Vector2.UP: "up",
            Vector2.DOWN: "down",
            Vector2.LEFT: "side",
            Vector2.RIGHT: "side"
        }

        var nearest_dir = Vector2.UP
        var nearest_dot = -1.0
        for dir in direction_animations.keys():
            var dot = dir.dot(velocity.normalized())
            if dot > nearest_dot:
                nearest_dot = dot
                nearest_dir = dir
        
        $Sprite2D.animation = direction_animations[nearest_dir]
    
    if velocity != Vector2(0, 0):
        particles.emitting = true
        var particle_material: ParticleProcessMaterial = particles.process_material
        particle_material.gravity = -Vector3(velocity.x, velocity.y, 0) * 0.8
        particle_material.gravity += Vector3(0, 12, 0)
    else:
        particles.emitting = false
    
    move_and_slide()

var minigame_open = false

func open_minigame(minigame: PackedScene):
    if $%MinigameContainer.get_child_count() > 0:
        return
    
    disabled = true
    var scene = minigame.instantiate()
    await get_tree().create_timer(0.01).timeout
    $%MinigameContainer.add_child(scene)
    await scene.finish
    disabled = false
    scene.queue_free()
