extends CharacterBody2D

var anomaly = 0
var SPEED = 300.0
var JUMP_VELOCITY = -250.0
var sprint = 0
var move = 1
var walk = 0 


func _physics_process(delta: float) -> void:
	if !move:
		#print("hi")
		#print(velocity)
		#velocity = Vector2(0,0)
		return
	#print("hellll")
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	#print(velocity)
	if velocity.y != 0 || velocity.x == 0:
		walk = 0
	else:
		walk = 1
	
	if sprint:
		$AnimatedSprite2D.play("sprint")
	elif walk:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
	
	
	if Input.is_action_pressed("sprint"):
		SPEED = 600
		JUMP_VELOCITY = -350.0
		sprint = 1
		
		#print("Sprinting")
	else:
		sprint = 0
		SPEED = 300
		JUMP_VELOCITY = -250.0
		
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$AnimatedSprite2D.flip_h = 1
		else:
			$AnimatedSprite2D.flip_h = 0
			
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#$AnimatedSprite2D.flip_h = 1

	move_and_slide()
