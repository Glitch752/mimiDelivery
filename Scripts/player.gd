extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var directionX := Input.get_axis("left","right")
	var directionY := Input.get_axis("up","down")
	if directionX:
		velocity.x = directionX*SPEED
		if directionX > 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false;
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)
	if directionY:
		velocity.y = directionY*SPEED
	else:
		velocity.y = move_toward(velocity.x,0,SPEED)

	move_and_slide()
