extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -250.0
var sprint = 0
var move = 1

func _physics_process(delta: float) -> void:
	if !move:
		#print("hi")
		return
	#print("hellll")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint"):
		SPEED = 450
		JUMP_VELOCITY = -350.0
		
		#print("Sprinting")
	else:
		SPEED = 300
		JUMP_VELOCITY = -250.0
		
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
