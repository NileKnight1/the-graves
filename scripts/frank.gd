extends CharacterBody2D

var anomaly = 0
var destination = Vector2(0, 0)
var speed = 100
var move = 0

func _process(delta: float) -> void:
	if !move:
		$sprite.play("idle")
		return
	
	if global_position.distance_to(destination) < 5.0:
		velocity = Vector2.ZERO
		$sprite.play("idle")
		move_and_slide()
		return
	
	var direction: Vector2 = global_position.direction_to(destination)
	
	if direction.x != 0:
		$sprite.flip_v = direction.x < 0
	
	$sprite.play("walk")
	
	velocity = direction * speed
	
	move_and_slide()
