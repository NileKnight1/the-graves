extends Node2D



var computer_area = 0
var computer_opened = 0
var opened_cam = 3



func _ready() -> void:
	#await get_tree().create_timer(1.0).timeout
	#print(p1_anomalies.find($anomalies/anomaly))
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$CanvasLayer/mobile.visible = 1
	
	spawn()
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if computer_area && !computer_opened:
			print("hi")
			#$"map above/cams/cam1".visible = 1
			$player/Camera2D.enabled = 0
			$"map above/cams".visible = 1
			$"map above/cams".get_child(opened_cam-1).enabled = 1
			
			computer_opened = 1
			stop_move()
		elif computer_opened:
			$player/Camera2D.enabled = 1
			$"map above/cams".visible = 0
			print("closed")
			#$"map above/cams/cam3".enabled = 0
			$"map above/cams".get_child(opened_cam-1).enabled = 0
			
			
			computer_opened = 0
			allow_move()
			
		
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
		
func stop_move():
	$player.move = 0
func allow_move():
	$player.move = 1


func _on_cams_body_entered(body: Node2D) -> void:
	if body == $player:
		computer_area = 1
	if body is CharacterBody2D && body.anomaly:
		body.queue_free()
		print("bruh")
func _on_cams_body_exited(body: Node2D) -> void:
	if body == $player:
		computer_area = 0

var p1_anomalies_count = 0
var p2_anomalies_count = 0
var p3_anomalies_count = 0
var p4_anomalies_count = 0

var p1_anomalies = []
var p2_anomalies = []
var p3_anomalies = []
var p4_anomalies = []



func _on_p_1_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p1_anomalies_count += 1
		p1_anomalies.append(body)
func _on_p_1_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p1_anomalies_count -= 1
		p1_anomalies.remove_at(p1_anomalies.find(body))
		

func _on_button1_pressed() -> void:
	#print(p1_anomalies)
	#print(p1_anomalies_count)
	if p1_anomalies_count:
		for i in p1_anomalies:
			i.queue_free()
			print(i)
			
		#p1_anomalies.clear()
		
		#print(p1_anomalies_count)

func _on_p_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p2_anomalies_count += 1
		p2_anomalies.append(body)
func _on_p_2_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p2_anomalies_count -= 1
		p2_anomalies.remove_at(p2_anomalies.find(body))
		

func _on_button_2_pressed() -> void:
	#print(p2_anomalies)
	#print(p2_anomalies_count)
	if p2_anomalies_count:
		for i in p2_anomalies:
			i.queue_free()
			print(i)
			
		#p2_anomalies.clear()
		
		#print(p2_anomalies_count)


func _on_p_3_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p3_anomalies_count += 1
		p3_anomalies.append(body)
func _on_p_3_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p3_anomalies_count -= 1
		p3_anomalies.remove_at(p3_anomalies.find(body))
		

func _on_button_3_pressed() -> void:
	#print(p3_anomalies)
	#print(p3_anomalies_count)
	if p3_anomalies_count:
		for i in p3_anomalies:
			i.queue_free()
			print(i)


func _on_p_4_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p4_anomalies_count += 1
		p4_anomalies.append(body)
func _on_p_4_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p4_anomalies_count -= 1
		p4_anomalies.remove_at(p4_anomalies.find(body))
		

func _on_button_4_pressed() -> void:
	#print(p4_anomalies)
	#print(p4_anomalies_count)
	if p4_anomalies_count:
		for i in p4_anomalies:
			i.queue_free()
			print(i)
			

func _on_spawn_timeout() -> void:
	spawn()

func spawn():
	#print("spawn")
	var temp = randi_range(0,1)
	var tempx
	var tempy
	var anomaly_scene = preload("res://scenes/anomaly.tscn").instantiate()
	
	if temp:
		tempx = randi_range(-2986.0, -1693.0)
	else:
		tempx = randi_range(2666.0, 1630)
	
	
	tempy = randi_range(-70.0, 31)
	
	anomaly_scene.destination = Vector2(-200.0, tempy)
	anomaly_scene.position = Vector2(tempx, tempy)
	$anomalies.add_child(anomaly_scene)
	anomaly_scene.move = 1

### p1
# show
#$"map above/left/trees/tree4"
#$"map above/left/trees/tree5"

# hide
#$"map above/left/trees/tree1", $"map above/left/trees/tree2", $"map above/left/trees/tree3"
#$"map behind/out_left/trees/tree1", $"map behind/out_left/trees/tree2", $"map behind/out_left/trees/tree3"

#show/hide
# show $"map behind/out_left/trees/tree4"
# hide $"map behind/out_left/trees/tree1"

#show $"map above/left/trees/tree1"
#hide $"map above/left/trees/tree6"

### p2

#show/hide
#show $"map behind/out_left/p2/cabin/door_hand",
#hide $"map behind/out_left/p2/cabin/door_hand2"

#show $"map behind/out_left/p2/tree2"
#show $"map behind/out_left/p2/bush3"
#
#hide $"map behind/out_left/p2/tree3"
#hide $"map behind/out_left/p2/bush4"
