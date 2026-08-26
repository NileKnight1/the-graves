extends CharacterBody2D

var anomaly = 1
var destination = Vector2(0, 0)
var speed = 100
var move = 0

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if !move: return
	
	if global_position.distance_to(destination) < 5.0:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var direction: Vector2 = global_position.direction_to(destination)
	#print(direction)
	
	
	velocity = direction * speed
	
	move_and_slide()
