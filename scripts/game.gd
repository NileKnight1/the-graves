extends Node2D



var computer_area = 0
var computer_opened = 0
var radio_area = 0
var radio_opened = 0

var opened_cam = 3

var shift = 1

func translation():
	TranslationServer.set_locale("ar") 
	$player/room/menu/title.text = tr("report_radio")
	$player/room/environment/title.text = tr("report_radio")
	$player/room/creatures/title.text = tr("report_radio")
	
	$player/room/menu/environmental.text = tr("environmental")
	$player/room/menu/creatures.text = tr("creatures")
	$player/room/menu/back.text = tr("back")
	$player/room/environment/back.text = tr("back")
	$player/room/creatures/back.text = tr("back")
	$player/room/environment/back.text = tr("back")
	$player/room/creatures/back.text = tr("back")
	
	$player/room/environment/p1.text = tr("part1")
	$player/room/environment/p2.text = tr("part2")
	$player/room/environment/p3.text = tr("part3")
	$player/room/environment/p4.text = tr("part4")
	
	$player/room/creatures/p1.text = tr("part1")
	$player/room/creatures/p2.text = tr("part2")
	$player/room/creatures/p3.text = tr("part3")
	$player/room/creatures/p4.text = tr("part4")
	
	$CanvasLayer/shift.text = tr("shift") + " " + str(shift)
	

func _ready() -> void:
	#await get_tree().create_timer(1.0).timeout
	#print(p1_anomalies.find($anomalies/anomaly))
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$CanvasLayer/mobile.visible = 1
		
	translation()
	
	#apply_anomaly_event()
	#spawn()
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
			
		if radio_area && !radio_opened:
			$player/room/menu.visible = 1
			radio_opened = 1
			#print("hi")
		elif radio_opened:
			$player/room/menu.visible = 0
			$player/room/environment.visible = 0
			$player/room/creatures.visible = 0
			radio_opened = 0
		
		
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


func _on_radio_body_entered(body: Node2D) -> void:
	if body == $player:
		radio_area = 1
		print("radio_area")
		print(radio_area)

func _on_radio_body_exited(body: Node2D) -> void:
	if body == $player:
		radio_area = 0
		if radio_opened:
			radio_opened = 0
			$player/room/menu.visible = 0
			$player/room/environment.visible = 0
			$player/room/creatures.visible = 0
		print("radio_area_leftd")
		



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
		

func _on_creature1_pressed() -> void:
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
		

func _on_creature2_pressed() -> void:
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
		

func _on_creature3_pressed() -> void:
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
		

func _on_creature4_pressed() -> void:
	#print(p4_anomalies)
	#print(p4_anomalies_count)
	if p4_anomalies_count:
		for i in p4_anomalies:
			i.queue_free()
			print(i)
			

func _on_spawn_timeout() -> void:
	#print("timeout")
	
	#spawn()
	apply_anomaly_event()
	
	
	pass

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

var anomaly_events_count = 0

func apply_anomaly_event():
	if anomaly_events_count > 2:
		return
		
	print("evented")
	var temp = randi_range(0, len(anomaly_events)-1)

	while (computer_opened && anomaly_events[temp]["area"] == opened_cam) || anomaly_events[temp]["exist"]:
		temp = randi_range(0, len(anomaly_events)-1)
		print(temp) 
	
	print (anomaly_events[temp])
	
	anomaly_events[temp]["exist"] = 1
	#print (anomaly_events[temp])
	
	#if anomaly_events[temp]["area"] == 1:
		#apply_anomaly_event()
		#return
	#print(anomaly_events[0]["show"])
	#get_node_or_null(anomaly_events[0]["show"]).visible = 1
	if anomaly_events[temp]["show"] != null:
		for i in anomaly_events[temp]["show"]:
			#print(i)
			get_node_or_null(i).visible = 1
	if anomaly_events[temp]["hide"] != null:
		for i in anomaly_events[temp]["hide"]:
			get_node_or_null(i).visible = 0
			#print(i)
			
	anomaly_events_count += 1


var anomaly_events = [
	{"area"=1, "show"=[^"map above/left/trees/tree4"], "hide"=null, "exist"= 0},
	{"area"=1, "show"=[^"map above/left/trees/tree5"], "hide"=null, "exist"= 0},
	{"area"=1, "show"= null, "hide"=[^"map above/left/trees/tree1"], "exist"= 0},
	{"area"=1, "show"= null, "hide"=[^"map above/left/trees/tree2"], "exist"= 0},
	{"area"=1, "show"= null, "hide"=[^"map above/left/trees/tree3"], "exist"= 0},
	{"area"=1, "show"= null, "hide"=[^"map behind/out_left/trees/tree1"], "exist"= 0},
	{"area"=1, "show"= null, "hide"=[^"map behind/out_left/trees/tree2"], "exist"= 0},
	{"area"=1, "show"= null, "hide"=[^"map behind/out_left/trees/tree3"], "exist"= 0},
	{"area"=1, "show"=[^"map behind/out_left/trees/tree4"], "hide"=[^"map behind/out_left/trees/tree1"], "exist"= 0},
	{"area"=1, "show"=[^"map above/left/trees/tree1"], "hide"=[^"map above/left/trees/tree6"], "exist"= 0},
	{"area"=2, "show"= [^"map behind/out_left/p2/cabin/door_hand2"], "hide"= [^"map behind/out_left/p2/cabin/door_hand"], "exist"= 0},
	{"area"=2, "hide"= [^"map behind/out_left/p2/tree2", ^"map behind/out_left/p2/bush3"], "show"= [^"map behind/out_left/p2/bush4", ^"map behind/out_left/p2/tree3"], "exist"= 0},
	{"area"=3, "show"= [^"map behind/out_right/p3/grave2"], "hide"=null, "exist"= 0},
	{"area"=3, "show"= [^"map above/right/bench3/hide1"], "hide"=null, "exist"= 0},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave"], "exist"= 0},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave3"], "exist"= 0},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave4"], "exist"= 0},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave5"], "exist"= 0},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave6"], "exist"= 0},
	{"area"=3, "show"= [^"map behind/out_right/p3/tree3"], "hide"=[^"map behind/out_right/p3/tree2"], "exist"= 0},
	{"area"=4, "show"=[^"map above/right/bench3/hide2"], "hide"= null, "exist"= 0},
	{"area"=4, "show"=[^"map behind/out_right/p4/bush3"], "hide"= null, "exist"= 0},
	{"area"=4, "show"=[^"map behind/out_right/p4/bush4"], "hide"= [^"map behind/out_right/p4/bush2"], "exist"= 0},
	

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
#show ^"map behind/out_left/p2/cabin/door_hand",
#hide ^"map behind/out_left/p2/cabin/door_hand2"

#show ^"map behind/out_left/p2/tree2"
#show ^"map behind/out_left/p2/bush3"
#
#hide ^"map behind/out_left/p2/tree3"
#hide ^"map behind/out_left/p2/bush4"


### p3

#show
#		^"map behind/out_right/p3/grave2"
#		^"map above/right/bench3/hide1"

#hide
#		^"map behind/out_right/p3/grave"
#		^"map behind/out_right/p3/grave3"
#		^"map behind/out_right/p3/grave4"
#		^"map behind/out_right/p3/grave5"
#		^"map behind/out_right/p3/grave6"

# show/hide
#hide 		^"map behind/out_right/p3/tree2"
#show 		^"map behind/out_right/p3/tree3"

]

### p4

#show
#   	^"map above/right/bench3/hide2"
#   	^"map behind/out_right/p4/bush3"

# show/hide
#hide    	^"map behind/out_right/p4/bush2"
#show    	^"map behind/out_right/p4/bush4"

func clear_anomaly_event(area):
	for i in anomaly_events:
		if i["area"] == area && i["exist"] == 1:
			i["exist"] = 0
			wrong_report = 0
			if i["show"] != null:
				for j in i["show"]:
					#print(i)
					get_node_or_null(j).visible = 0
			if i["hide"] != null:
				for j in i["hide"]:
					get_node_or_null(j).visible = 1
					#print(i)
			#print("gotchu")
			#print(i)
			print("gotchu")
			anomaly_events_count -= 1
	if wrong_report:
		wrong_report_penalty()
	wrong_report = 1

var wrong_report = 1
var wrong_reports_conut = 0


func wrong_report_penalty():
	print("bad boy")
	wrong_reports_conut += 1
	
	if wrong_reports_conut == 3:
		print("You Lose")
		lose()

func lose():
	$CanvasLayer/black.visible = 1
	$CanvasLayer/label.text = tr("lose")
func win():
	$CanvasLayer/black.visible = 1
	$CanvasLayer/label.text = tr("win")

func _on_en1_pressed() -> void:
	#print(self)
	clear_anomaly_event(1)
func _on_en2_pressed() -> void:
	clear_anomaly_event(2)
func _on_en3_pressed() -> void:
	clear_anomaly_event(3)
func _on_en4_pressed() -> void:
	clear_anomaly_event(4)

func _on_environmental_pressed() -> void:
	$player/room/environment.visible = 1
	$player/room/menu.visible = 0
func _on_creatures_pressed() -> void:
	$player/room/creatures.visible = 1
	$player/room/menu.visible = 0
func _on_back_pressed() -> void:
	$player/room/environment.visible = 0
	$player/room/creatures.visible = 0
	$player/room/menu.visible = 1
