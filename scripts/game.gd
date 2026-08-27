extends Node2D



var computer_area = 0
var computer_opened = 0
var radio_area = 0
var radio_opened = 0

var opened_cam = 3
var player_name = "عمار"

var shift = 1

#var collect = preload("res://audio/collect.mp3")
var click_phone = preload("res://audio/click_phone.mp3")
var hang_up = preload("res://audio/hangup.mp3")
var dialogue = preload("res://audio/dialogue.mp3")
var camera_switch = preload("res://audio/camera_switch.mp3")
var cam_on = preload("res://audio/cam_on.mp3")
var cam_off = preload("res://audio/cam_off.mp3")
var start_sound = preload("res://audio/start.mp3")
var click_radio = preload("res://audio/radio_click.mp3")
var radio_signal = preload("res://audio/radio_signal.mp3")
var wrong_signal = preload("res://audio/wrong_singal.mp3")
var correct = preload("res://audio/correct.mp3")








func play_sound(sound):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()
	


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
	$CanvasLayer/danger.text = tr("danger") + " " + str(bad_time) + "/" + str(max_bad_time)
	#
	#if (TranslationServer.get_locale() == 'ar'):
		#$CanvasLayer/danger.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	#
	$CanvasLayer/reports.text = tr("wrong_reports") + " " + str(wrong_reports_conut) + "/" + str(max_wrong_reports_count)
	
	
	
	
	$"map above/cams/cam1/cam".text = tr("cam1")
	$"map above/cams/cam2/cam".text = tr("cam2")
	$"map above/cams/cam3/cam".text = tr("cam3")
	$"map above/cams/cam4/cam".text = tr("cam4")
	
	#$CanvasLayer/subtitles.text = tr("test")
	
	$player/phone/ringing/lab1.text = tr("accept")
	$player/phone/ringing/lab2.text = tr("decline")
	$player/phone/caller.text = tr("manager")
	$player/phone/ringing/label.text = tr("calling")
	

func _ready() -> void:
	#await get_tree().create_timer(1.0).timeout
	#print(p1_anomalies.find($anomalies/anomaly))
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$CanvasLayer/mobile.visible = 1
	translation()
	
	phone_call()
	#phone_down()
	
	
	#apply_anomaly_event()
	#spawn()
	pass

func phone_up():
	$player/phone/ringing.visible = 1
	$player/phone/accepted.visible = 0
	var tween = create_tween()
	$sfx/ringtone.play()
	tween.tween_property($player/phone, "position:y", $player/phone.position.y - 320 , 0.8)
func phone_down():
	var tween = create_tween()
	tween.tween_property($player/phone, "position:y", $player/phone.position.y + 320 , 0.4)

var calling = 0

func phone_call():
	#await get_tree().create_timer(2).timeout
	phone_up()

func radio_access_on():
	$player/room/menu/environmental.visible = 1
func radio_access_off():
	$player/room/menu/environmental.visible = 0


var chat1_array = [
	"chat1msg1",  
	"chat1msg2", 
	"chat1msg3", 
	"chat1msg4", 
	"chat1msg5", 
	"chat1msg6", 
	"chat1msg7", 
	"chat1msg8", 
	"chat1msg9", 
]

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("umm")

var chat_msg = 0

func _on_skip_msg_timeout() -> void:
	chat_msg += 1
	#print("im still workingD")
	
	match call_index:
		0: tutorial()
		1: first_day_survived()

func tutorial():
	if chat_msg > 8:
		chat_msg = 0
		calling = 0
		$timers/skip_msg.stop()
		phone_down()
		start()
		return
	
	var temp = tr(chat1_array[chat_msg])
	if "%s" in temp:
		$CanvasLayer/subtitles.text = temp % player_name
		print(temp)
	else:
		$CanvasLayer/subtitles.text = temp
	#play_sound(dialogue)
	#dialogue.play()
	$sfx/dia.play()

func start():
	$sfx/dia.stop()
	$timers/call_time.stop()
	$timers/skip_msg.stop()
	call_index = 1
	
	await get_tree().create_timer(0.8).timeout
	play_sound(start_sound)
	radio_access_on()
	
	$CanvasLayer/danger.visible = 1
	$CanvasLayer/reports.visible = 1
	
	$CanvasLayer/shift.visible = 1
	$CanvasLayer/time.visible = 1
	$CanvasLayer/subtitles.text = ""
	
	$timers/spawn.start()
	$timers/shift_time.start()
	
	
@onready var walking_sound = $sfx/walk_dirt

func _process(delta: float) -> void:
	if $player.walk:
		if !walking_sound.playing:
			walking_sound.play()
			print("um?a")
		if $player.sprint:
			walking_sound.pitch_scale = 2.0
		else:
			walking_sound.pitch_scale = 1
	else:
		walking_sound.stop()
		
	
	if Input.is_action_just_pressed("interact"):
		if computer_area && !computer_opened:
			#print("hi")
			#$"map above/cams/cam1".visible = 1
			$player/Camera2D.enabled = 0
			$"map above/cams".visible = 1
			$"map above/cams".get_child(opened_cam-1).enabled = 1
			
			computer_opened = 1
			play_sound(cam_on)
			$sfx/camera.play()
			walking_sound.stop()
			
			stop_move()
		elif computer_opened:
			play_sound(cam_off)
			$sfx/camera.stop()
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
			$sfx/radio.play()
			
			#print("hi")
		elif radio_opened:
			$sfx/radio.stop()
			$player/room/menu.visible = 0
			$player/room/environment.visible = 0
			$player/room/creatures.visible = 0
			radio_opened = 0
		
	#print(p1+p2+p3+p4)
	#print(computer_opened)
	if computer_opened:
		$"map above/cams".get_child(opened_cam-1).visible = 0
		$"map above/cams".get_child(opened_cam-1).enabled = 0
		#print(opened_cam)
		if Input.is_action_just_pressed("left"):
			#print("hi")
			opened_cam -= 1
			if opened_cam == 0:
				opened_cam = 4
			play_sound(camera_switch)
		if Input.is_action_just_pressed("right"):
			#print("ih")
			opened_cam += 1
			if opened_cam == 5:
				opened_cam = 1
			play_sound(camera_switch)
			
				
		$"map above/cams".get_child(opened_cam-1).visible = 1
		$"map above/cams".get_child(opened_cam-1).enabled = 1
		#
	if calling && Input.is_action_just_pressed("skip"):
		chat_msg += 1
		$timers/skip_msg.start()
		match call_index:
			0: tutorial()
			1: first_day_survived()
		

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
			$sfx/radio.stop()
			
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

var p1 = 0
var p2 = 0
var p3 = 0
var p4 = 0

func _on_p_1_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p1_anomalies_count += 1
		p1_anomalies.append(body)
	if body == $player:
		p1 = 1
func _on_p_1_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p1_anomalies_count -= 1
		p1_anomalies.remove_at(p1_anomalies.find(body))
	if body == $player:
		p1 = 0
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
	if body == $player:
		p2 = 1
func _on_p_2_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p2_anomalies_count -= 1
		p2_anomalies.remove_at(p2_anomalies.find(body))
	if body == $player:
		p2 = 0

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
	if body == $player:
		p3 = 1
func _on_p_3_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p3_anomalies_count -= 1
		p3_anomalies.remove_at(p3_anomalies.find(body))
	if body == $player:
		p3 = 0

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
	if body == $player:
		p4 = 1
func _on_p_4_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p4_anomalies_count -= 1
		p4_anomalies.remove_at(p4_anomalies.find(body))
	if body == $player:
		p4 = 0

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

	for i in anomaly_events:
		print(computer_opened && i["area"] == opened_cam)
		
		if (computer_opened && i["area"] == opened_cam) || i["exist"]: continue
		
		match i["area"]:
			1: if ps1: continue
			2: if ps2: continue
			3: if ps3: continue
			4: if ps4: continue
			
		
		for j in range(i["prob"]):
			anomaly_events_prob.append(i)
			
	print (anomaly_events_prob)
	print(opened_cam)
	
	var temp = randi_range(0, len(anomaly_events_prob)-1)
	var temp2
	var index = 0
	
	for i in anomaly_events:
		if i == anomaly_events_prob[temp]:
			temp2 = index
			break
		index += 1
		
	print (anomaly_events_prob[temp])
	print (anomaly_events[temp2])
	anomaly_events_prob.clear()
	
	anomaly_events[temp2]["exist"] = 1
	
	if anomaly_events[temp2]["prob"] > 1:
		anomaly_events[temp2]["prob"] -= 1
	#print (anomaly_events[temp])
	
	#if anomaly_events[temp]["area"] == 1:
		#apply_anomaly_event()
		#return
	#print(anomaly_events[0]["show"])
	#get_node_or_null(anomaly_events[0]["show"]).visible = 1
	if anomaly_events[temp2]["show"] != null:
		for i in anomaly_events[temp2]["show"]:
			#print(i)
			get_node_or_null(i).visible = 1
	if anomaly_events[temp2]["hide"] != null:
		for i in anomaly_events[temp2]["hide"]:
			get_node_or_null(i).visible = 0
			#print(i)
			
	anomaly_events_count += 1


var anomaly_events = [
	{"area"=1, "show"=[^"map above/left/trees/tree4"], "hide"=null, "exist"= 0, "prob"= 3},
	{"area"=1, "show"=[^"map above/left/trees/tree5"], "hide"=null, "exist"= 0, "prob"= 3},
	{"area"=1, "show"= null, "hide"=[^"map above/left/trees/tree1"], "exist"= 0, "prob"= 3},
	#{"area"=1, "show"= null, "hide"=[^"map above/left/trees/tree2"], "exist"= 0, "prob"= 3},
	#{"area"=1, "show"= null, "hide"=[^"map above/left/trees/tree3"], "exist"= 0, "prob"= 3},
	#{"area"=1, "show"= null, "hide"=[^"map behind/out_left/trees/tree1"], "exist"= 0, "prob"= 3},
	#{"area"=1, "show"= null, "hide"=[^"map behind/out_left/trees/tree2"], "exist"= 0, "prob"= 3},
	{"area"=1, "show"= null, "hide"=[^"map behind/out_left/trees/tree3"], "exist"= 0, "prob"= 3},
	{"area"=1, "show"=[^"map behind/out_left/trees/tree4"], "hide"=[^"map behind/out_left/trees/tree1"], "exist"= 0, "prob"= 3},
	{"area"=1, "show"=[^"map above/left/trees/tree1"], "hide"=[^"map above/left/trees/tree6"], "exist"= 0, "prob"= 3},
	{"area"=2, "show"= [^"map behind/out_left/p2/cabin/door_hand2"], "hide"= [^"map behind/out_left/p2/cabin/door_hand"], "exist"= 0, "prob"= 3},
	{"area"=2, "hide"= [^"map behind/out_left/p2/tree2", ^"map behind/out_left/p2/bush3"], "show"= [^"map behind/out_left/p2/bush4", ^"map behind/out_left/p2/tree3"], "exist"= 0, "prob"= 3},
	{"area"=3, "show"= [^"map behind/out_right/p3/grave2"], "hide"=null, "exist"= 0, "prob"= 3},
	{"area"=3, "show"= [^"map above/right/bench3/hide1"], "hide"=null, "exist"= 0, "prob"= 3},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave"], "exist"= 0, "prob"= 3},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave3"], "exist"= 0, "prob"= 3},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave4"], "exist"= 0, "prob"= 3},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave5"], "exist"= 0, "prob"= 3},
	{"area"=3, "show"=null, "hide"= [^"map behind/out_right/p3/grave6"], "exist"= 0, "prob"= 3},
	{"area"=3, "show"= [^"map behind/out_right/p3/tree3"], "hide"=[^"map behind/out_right/p3/tree2"], "exist"= 0, "prob"= 3},
	{"area"=4, "show"=[^"map above/right/bench3/hide2"], "hide"= null, "exist"= 0, "prob"= 3},
	{"area"=4, "show"=[^"map behind/out_right/p4/bush3"], "hide"= null, "exist"= 0, "prob"= 3},
	{"area"=4, "show"=[^"map behind/out_right/p4/bush4"], "hide"= [^"map behind/out_right/p4/bush2"], "exist"= 0, "prob"= 3},
]

var anomaly_events_prob = []


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

### p4

#show
#   	^"map above/right/bench3/hide2"
#   	^"map behind/out_right/p4/bush3"

# show/hide
#hide    	^"map behind/out_right/p4/bush2"
#show    	^"map behind/out_right/p4/bush4"

func clear_anomaly_event(area):
	play_sound(radio_signal)
	await get_tree().create_timer(2.0).timeout
	
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
			right_reports_conut += 1
			if right_reports_conut == 600:
				win()
	if wrong_report:
		wrong_report_penalty()
	else:
		play_sound(correct)
	wrong_report = 1

var wrong_report = 1
var wrong_reports_conut = 0
var max_wrong_reports_count = 3
var right_reports_conut = 0




func wrong_report_penalty():
	play_sound(wrong_signal)
	print("bad boy")
	wrong_reports_conut += 1
	$CanvasLayer/reports.text = tr("wrong_reports") + " " + str(wrong_reports_conut) + "/" + str(max_wrong_reports_count)
	
	
	if wrong_reports_conut == max_wrong_reports_count:
		print("You Lose")
		lose()

func lose():
	$timers/spawn.stop()
	$timers/bad_time.stop()
	$CanvasLayer/black.visible = 1
	$CanvasLayer/label.text = tr("lose")

func win():
	$timers/spawn.stop()
	$timers/bad_time.stop()
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
	play_sound(click_radio)
	$player/room/environment.visible = 1
	$player/room/menu.visible = 0
func _on_creatures_pressed() -> void:
	play_sound(click_radio)
	$player/room/creatures.visible = 1
	$player/room/menu.visible = 0
func _on_back_pressed() -> void:
	play_sound(click_radio)
	$player/room/environment.visible = 0
	$player/room/creatures.visible = 0
	$player/room/menu.visible = 1

var bad_time = 0
var max_bad_time = 1000
#var danger = 0

func _on_bad_time_timeout() -> void:
	bad_time += anomaly_events_count
	$CanvasLayer/danger.text = tr("danger") + " " + str(bad_time) + "/" + str(max_bad_time)
	
	
	if bad_time > max_bad_time:
		lose()

var call_index = 0
	

func _on_accept_tutorial_pressed() -> void:
	$sfx/ringtone.stop()
	call_time = 0
	play_sound(click_phone)
	calling = 1
	$player/phone/ringing.visible = 0
	$player/phone/accepted.visible = 1
	$timers/call_time.start()
	$timers/skip_msg.start()
	
	match call_index:
		0: tutorial()
		1: first_day_survived()

func _on_decline_tutorial_pressed() -> void:
	play_sound(hang_up)
	$sfx/ringtone.stop()
	phone_down()
	calling = 0
	
	match call_index:
		0: start()
		1: first_day_survived()
		
	

var call_time = 0
func _on_call_time_timeout() -> void:
	call_time += 1
	var minutes = call_time/60
	var seconds = call_time - (minutes*60) 
	$player/phone/accepted/time.text = "0"
	$player/phone/accepted/time.text += str(minutes)
	$player/phone/accepted/time.text += ":"
	if seconds < 10:
		$player/phone/accepted/time.text += "0"
	$player/phone/accepted/time.text += str(seconds)

var ps1 = 0
var ps2 = 0
var ps3 = 0
var ps4 = 0

func _on_ps_1_body_entered(body: Node2D) -> void:
	if body == $player:
		ps1 = 1
		print("p1")
func _on_ps_1_body_exited(body: Node2D) -> void:
	if body == $player:
		ps1 = 0
func _on_ps_2_body_entered(body: Node2D) -> void:
	if body == $player:
		ps2 = 1
func _on_ps_2_body_exited(body: Node2D) -> void:
	if body == $player:
		ps2 = 0
func _on_ps_3_body_entered(body: Node2D) -> void:
	if body == $player:
		ps3 = 1
func _on_ps_3_body_exited(body: Node2D) -> void:
	if body == $player:
		ps3 = 0
func _on_ps_4_body_entered(body: Node2D) -> void:
	if body == $player:
		ps4 = 1
func _on_ps_4_body_exited(body: Node2D) -> void:
	if body == $player:
		ps4 = 0

var shift_time = 358
func _on_shift_time_timeout() -> void:
	shift_time += 1
	var mins = shift_time/60
	var secs = shift_time - mins*60
	$CanvasLayer/time.text = ""
	if mins < 10:
		$CanvasLayer/time.text += "0"
	$CanvasLayer/time.text += str(mins) + ":"
	if secs < 10:
		$CanvasLayer/time.text += "0"
	$CanvasLayer/time.text += str(secs)
	
	if shift_time == 360:
		sunrise()


func _on_room_body_entered(body: Node2D) -> void:
	if body == $player:
		$sfx/night.volume_db -= 5
		walking_sound = $sfx/walk_wood
		$sfx/walk_dirt.stop()
		$sfx/walk_wood.play()
		#print("lowerd")
func _on_room_body_exited(body: Node2D) -> void:
	if body == $player:
		$sfx/night.volume_db += 5
		walking_sound = $sfx/walk_dirt
		$sfx/walk_dirt.play()
		$sfx/walk_wood.stop()

func sunrise():
	$timers/spawn.stop()
	$timers/bad_time.stop()
	$sfx/night.stop()
	$sfx/morning.play()
	$"map behind/out_left/bg/sky2".visible = 1
	$"map behind/out_right/bg/Panel3".visible = 1
	radio_access_off()
	phone_up()

var first_day_survived_chat = [
	"chat2msg1",
	"chat2msg2",
	"chat2msg3",
	
]

func first_day_survived():
	if chat_msg > 2:
		chat_msg = 0
		calling = 0
		$timers/skip_msg.stop()
		phone_down()
		return
	
	var temp = tr(first_day_survived_chat[chat_msg])
	if "%s" in temp:
		$CanvasLayer/subtitles.text = temp % player_name
		print(temp)
	else:
		$CanvasLayer/subtitles.text = temp
	$sfx/dia.play()
