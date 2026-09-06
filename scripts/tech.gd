extends CharacterBody2D

var anomaly = 0
var destination = Vector2(0, 0)
var speed = 100
var move = 0
var good = 1

func _process(delta: float) -> void:
	if !move:
		if good:
			$good.visible = 1
			$bad.visible = 0
			$good.play("idle")
		else:
			$good.visible = 0
			$bad.visible = 1
			$bad.play("idle")
		return
	
	if global_position.distance_to(destination) < 5.0:
		velocity = Vector2.ZERO
		move_and_slide()
		if good:
			$good.visible = 1
			$bad.visible = 0
			$good.play("idle")
		else:
			$good.visible = 0
			$bad.visible = 1
			$bad.play("idle")
		return
	
	var direction: Vector2 = global_position.direction_to(destination)
	
	if direction.x != 0:
		$good.flip_h = direction.x < 0
		$bad.flip_h = direction.x < 0
		
	if good:
		$good.visible = 1
		$bad.visible = 0
		$good.play("walk")
	else:
		$good.visible = 0
		$bad.visible = 1
		$bad.play("walk")
	
	velocity = direction * speed
	
	move_and_slide()
