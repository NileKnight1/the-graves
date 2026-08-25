extends Node2D



func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if computer_area:
			#$"map above/cams/cam1".visible = 1
			$player/Camera2D.enabled = 0
			$"map above/cams".visible = 1
			
			
			computer_opened = 1
		
	#print(computer_opened)
	if computer_opened:
		$"map above/cams".get_child(opened_cam-1).visible = 0
		$"map above/cams".get_child(opened_cam-1).enabled = 0
		
		if Input.is_action_just_pressed("left"):
			print("hi")
			opened_cam -= 1
			if opened_cam == 0:
				opened_cam = 4
				
		if Input.is_action_just_pressed("right"):
			print("ih")
			opened_cam += 1
			if opened_cam == 5:
				opened_cam = 1
				
		$"map above/cams".get_child(opened_cam-1).visible = 1
		$"map above/cams".get_child(opened_cam-1).enabled = 1
		
			
	

var computer_area = 0
var computer_opened = 0
var opened_cam = 3


func _on_cams_body_entered(body: Node2D) -> void:
	if body == $player:
		computer_area = 1
func _on_cams_body_exited(body: Node2D) -> void:
	if body == $player:
		computer_area = 0
