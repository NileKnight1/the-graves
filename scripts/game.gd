extends Node2D

@onready var walking_sound = $sfx/walk_dirt

var shift = global.shift

var computer_area = 0
var computer_opened = 0
var radio_area = 0
var switch_area = 0

var radio_opened = 0

var opened_cam = 1
var player_name = global.player_name


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
var click_switch = preload("res://audio/click_switch.mp3")
var sudden = preload("res://audio/sudden.mp3")



func play_sound(sound):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

func translation():
	#TranslationServer.set_locale("ar") 
	$player.get_child(0).text = player_name
	
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
	$player/phone/accepted/lab2.text = tr("decline")
	$player/phone/caller.text = tr("manager")
	$player/phone/ringing/label.text = tr("calling")
	
	$CanvasLayer/press_e.text = tr("press_e")
	
	$"map behind/room/tasks/day1/task1/text".text = tr("day1task1") + " (" + str(discovered1+discovered2+discovered3+discovered4) + "/4)"
	$"map behind/room/tasks/day1/task2/text".text = tr("day1task2")
	$"map behind/room/tasks/day1/task3/text".text = tr("day1task3")
	
	
	
var pc = 1

func _ready() -> void:
	#await get_tree().create_timer(1.0).timeout
	#print(p1_anomalies.find($anomalies/anomaly))
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$CanvasLayer/mobile.visible = 1
		pc = 0
	translation()
	
	phone_up()
	
	developer()
	
	#phone_down()
	
	
	#apply_anomaly_event()
	#spawn()
	pass


func _on_cams_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and computer_area:
		open_cam()
		
func _on_radio_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and radio_area:
		open_radio()

func _on_switch_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and switch_area:
		play_sound(click_switch)
		if $lights/room.visible:
			$lights/room.visible = 0
		else:
			$lights/room.visible = 1


func _on_button_pressed() -> void:
	close_cam()



func open_cam():
	#print("hi")
	#$"map above/cams/cam1".visible = 1
	$player/Camera2D.enabled = 0
	$"map above/cams".visible = 1
	$"map above/cams".get_child(opened_cam-1).enabled = 1
	$CanvasLayer/close_cam.visible = 1
	computer_opened = 1
	$player/phone.visible = 0
	play_sound(cam_on)
	$sfx/camera.play()
	walking_sound.stop()
	$CanvasLayer/press_e.visible = 0
	
	if !day1task2 && day1call1_done:
		day1task2_apply()


	stop_move()


func close_cam():
	if !day1task2 && day1call1_done:
		return
	
	if day1task2 || !day1call1_done:
		$"map above/cams".get_child(opened_cam-1).visible = 0
		$"map above/cams".get_child(opened_cam-1).enabled = 0
		opened_cam = 1
		$"map above/cams".get_child(opened_cam-1).visible = 1
		$"map above/cams".get_child(opened_cam-1).enabled = 1
	
	$CanvasLayer/close_cam.visible = 0
	
	play_sound(cam_off)
	$sfx/camera.stop()
	$player/Camera2D.enabled = 1
	$"map above/cams".visible = 0
	$player/phone.visible = 1
	
	print("closed")
	#$"map above/cams/cam3".enabled = 0
	$"map above/cams".get_child(opened_cam-1).enabled = 0
	
	
	computer_opened = 0
	allow_move()
	await get_tree().create_timer(0.2).timeout
	allow_move()
	if day1call1_done:
		day1task2 = 1


func open_radio():
	$player/room/menu.visible = 1
	radio_opened = 1
	$sfx/radio.play()
	$CanvasLayer/press_e.visible = 0
	#if !day1task2:
		#
	

func close_radio():
	$sfx/radio.stop()
	$player/room/menu.visible = 0
	$player/room/environment.visible = 0
	$player/room/creatures.visible = 0
	radio_opened = 0

func _process(delta: float) -> void:
	#print(day1task2)
	if $player.walk && $player.move:
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
			open_cam()
		elif computer_opened:
			close_cam()
			
		if radio_area && !radio_opened:
			open_radio()
			#print("hi")
		elif radio_opened:
			close_radio()
		
		if switch_area:
			play_sound(click_switch)
			if $lights/room.visible:
				$lights/room.visible = 0
			else:
				$lights/room.visible = 1
	
	#print(p1+p2+p3+p4)
	#print(computer_opened)
	if computer_opened:
		if !day1task2 && day1call1_done:
			$"map above/cams".get_child(opened_cam-1).visible = 1
			$"map above/cams".get_child(opened_cam-1).enabled = 1
			return
		
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
		match shift:
			1:
				match call_index:
					0: day_call(chat1_array, day1_start)
					1: day_call(day1_call2_chat, day1_end)
			#2:
				#match call_index:
					#0: day_call(day2_call1_chat, day2_start)
					#1: day_call(day2_call2_chat, day2_end)


func _on_switch_body_entered(body: Node2D) -> void:
	if body == $player:
		switch_area = 1
		if pc: $CanvasLayer/press_e.visible = 1
func _on_switch_body_exited(body: Node2D) -> void:
	if body == $player:
		switch_area = 0
		$CanvasLayer/press_e.visible = 0


func radio_access_on():
	$player/room/menu/environmental.visible = 1
func radio_access_off():
	$player/room/menu/environmental.visible = 0

func stop_move():
	$player.move = 0
func allow_move():
	$player.move = 1



func phone_up():
	$player/phone/ringing.visible = 1
	$player/phone/accepted.visible = 0
	var tween = create_tween()
	$sfx/ringtone.play()
	tween.tween_property($player/phone, "position:y", $player/phone.position.y + 320 , 0.8)
func phone_down():
	var tween = create_tween()
	tween.tween_property($player/phone, "position:y", $player/phone.position.y - 320 , 0.4)
	$sfx/dia.stop()
	$CanvasLayer/subtitles.text = ""

var calling = 0
var call_index = 0


func _on_accept_call_pressed() -> void:
	$sfx/ringtone.stop()
	call_time = 0
	play_sound(click_phone)
	calling = 1
	$player/phone/ringing.visible = 0
	$player/phone/accepted.visible = 1
	$timers/call_time.start()
	$timers/skip_msg.start()
	
	match shift:
		1:
			match call_index:
				0: day_call(chat1_array, day1_start)
				1: day_call(day1_call2_chat, day1_end)
		2:
			pass
			
func _on_decline_call_pressed() -> void:
	play_sound(hang_up)
	$sfx/ringtone.stop()
	$sfx/dia.stop()
	
	phone_down()
	
	calling = 0
	
	match shift:
		1:
			match call_index:
				0: day1_start()
				1: day1_end()
		2:
			pass

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

var chat_msg = 0

func _on_skip_msg_timeout() -> void:
	chat_msg += 1
	#print("im still workingD")
	
	match shift:
		1:
			match call_index:
				0: day_call(chat1_array, day1_start)
				1: day_call(day1_call2_chat, day1_end)
		2:
			pass

func end_shift():
	$timers/spawn.stop()
	$timers/bad_time.stop()
	$sfx/night.stop()
	$sfx/morning.play()
	$"map behind/out_left/bg/sky2".visible = 1
	$"map behind/out_right/bg/Panel3".visible = 1
	$lights/left.visible = 0
	$lights/right.visible = 0
	
	radio_access_off()
	phone_up()


func _on_cams_body_entered(body: Node2D) -> void:
	if body == $player:
		computer_area = 1
		if pc: $CanvasLayer/press_e.visible = 1
	if body is CharacterBody2D && body.anomaly:
		body.queue_free()
		print("bruh")
func _on_cams_body_exited(body: Node2D) -> void:
	if body == $player:
		computer_area = 0
		$CanvasLayer/press_e.visible = 0
		

func _on_radio_body_entered(body: Node2D) -> void:
	if body == $player:
		radio_area = 1
		print("radio_area")
		print(radio_area)
		if pc: $CanvasLayer/press_e.visible = 1

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
		$CanvasLayer/press_e.visible = 0


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

func developer():
	discovered1 = 1
	discovered2 = 1
	discovered3 = 1
	discovered4 = 1
	#$"map behind/room/tasks/day1/task1/text".text = tr("day1task1") + " (" + str(discovered1+discovered2+discovered3+discovered4) + "/4)"
	discovering()
	#day1task2 = 1
	

var discovered1 = 0
var discovered2 = 0
var discovered3 = 0
var discovered4 = 0

func _on_p_1_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D && body.anomaly :
		#print("anomaly")
		p1_anomalies_count += 1
		p1_anomalies.append(body)
	if body == $player:
		p1 = 1
		discovered1 = 1
		discovering()
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
		discovered2 = 1
		discovering()
		
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
		discovered3 = 1
		discovering()
		
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
		discovered4 = 1
		discovering()
		
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
			
	#print (anomaly_events_prob)
	#print(opened_cam)
	
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
	subtitle("report_sent", 0.8)
	$player/room/environment/p1.disabled = 1
	$player/room/environment/p2.disabled = 1
	$player/room/environment/p3.disabled = 1
	$player/room/environment/p4.disabled = 1
	
	await get_tree().create_timer(2.0).timeout
	$player/room/environment/p1.disabled = 0
	$player/room/environment/p2.disabled = 0
	$player/room/environment/p3.disabled = 0
	$player/room/environment/p4.disabled = 0
	
	if !day1task3:
		day1task3_apply(area)
	
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
			#if right_reports_conut == 600:
				#win()
	if wrong_report:
		wrong_report_penalty()
		subtitle("wrong_report", 0.6)
	else:
		play_sound(correct)
		subtitle("right_report", 0.6)
	wrong_report = 1
	
	await get_tree().create_timer(1.0).timeout
	subtitle("", 0)
	


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
var max_bad_time = 300
#var danger = 0

func _on_bad_time_timeout() -> void:
	bad_time += anomaly_events_count
	$CanvasLayer/danger.text = tr("danger") + " " + str(bad_time) + "/" + str(max_bad_time)

	if bad_time > max_bad_time:
		lose()

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

var shift_time = 0

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
		end_shift()

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

func subtitle(sub, time):
	$CanvasLayer/subtitles.visible_ratio = 0
	$CanvasLayer/subtitles.text = tr(sub)
	var tween = create_tween()
	$sfx/sub.play()
	tween.tween_property($CanvasLayer/subtitles, "visible_ratio", 1.0, time)
	await get_tree().create_timer(time).timeout
	$sfx/sub.stop()

var day1call1_done = 0
var discovered = 0
var day1task2 = 1
var day1task3 = 0
var day1task4 = 0

func discovering():
	$"map behind/room/tasks/day1/task1/text".text = tr("day1task1") + " (" + str(discovered1+discovered2+discovered3+discovered4) + "/4)"
	
	if discovered:
		return
	
	if discovered1 && discovered2 && discovered3 && discovered4:
		discovered = 1
		$"map behind/room/tasks/day1/task1/done".visible = 1
		if day1call1_done:
			$"map behind/room/tasks/day1/task2".visible = 1
		
		day1task2 = 0
		opened_cam = 1
	

func day1task2_apply():
	if day1task2:
		return
	
	
	await get_tree().create_timer(0.5).timeout
	subtitle("day1sub1", 0.5)
	
	await get_tree().create_timer(2.0).timeout
	play_sound(sudden)
	var temp2 = 2
	anomaly_events[temp2]["exist"] = 1
	if anomaly_events[temp2]["prob"] > 1:
		anomaly_events[temp2]["prob"] -= 1
	if anomaly_events[temp2]["show"] != null:
		for i in anomaly_events[temp2]["show"]:
			get_node_or_null(i).visible = 1
	if anomaly_events[temp2]["hide"] != null:
		for i in anomaly_events[temp2]["hide"]:
			get_node_or_null(i).visible = 0
			
	anomaly_events_count += 1
	subtitle("day1sub2", 0.5)
	
	await get_tree().create_timer(3.0).timeout
	day1task2 = 1
	
	
	
	close_cam()
	
	$"map behind/room/tasks/day1/task2/done".visible = 1
	$"map behind/room/tasks/day1/task3".visible = 1
	radio_access_on()
	
	allow_move()

func day1task3_apply(area):
	if area == 1:
		day1task3 = 1
		$"map behind/room/tasks/day1/task3/done".visible = 1
		#$"map behind/room/tasks/day1/task4".visible = 1
		await get_tree().create_timer(2.0).timeout
		
		subtitle("day1sub3", 1.0)
		await get_tree().create_timer(2.0).timeout
		play_sound(start_sound)
		radio_access_on()
		
		$CanvasLayer/danger.visible = 1
		$CanvasLayer/reports.visible = 1
		
		$CanvasLayer/shift.visible = 1
		$CanvasLayer/time.visible = 1
		
		$timers/spawn.start()
		$timers/shift_time.start()
		
		await get_tree().create_timer(5.0).timeout
		subtitle("day1sub4", 2.0)
		await get_tree().create_timer(5.0).timeout
		subtitle("", 0.0)

	else:
		wrong_reports_conut -= 1

func day1_start():
	$sfx/dia.stop()
	$timers/call_time.stop()
	$timers/skip_msg.stop()
	call_index = 1
	
	day1call1_done = 1
	
	if discovered:
		$"map behind/room/tasks/day1/task2".visible = 1
		if computer_opened:
			$"map above/cams".get_child(opened_cam-1).visible = 0
			$"map above/cams".get_child(opened_cam-1).enabled = 0
			opened_cam = 1
			$"map above/cams".get_child(opened_cam-1).visible = 1
			$"map above/cams".get_child(opened_cam-1).enabled = 1
			await get_tree().create_timer(1.0).timeout
			day1task2_apply()

var chat1_array = [
	["chat1msg1", 2],  
	["chat1msg2", 3.5], 
	["chat1msg3", 3.5], 
	["chat1msg4", 3.5], 
	["chat1msg5", 4.5], 
	["chat1msg6", 3.5], 
	["chat1msg7", 1.5], 
	["chat1msg8", 1.5], 
	["chat1msg9", 0.5], 
]

var day1_call2_chat = [
	["chat2msg1", 1],
	["chat2msg2", 1],
	["chat2msg3", 1],
]

func day_call(chat, target):
	if chat_msg == len(chat):
		chat_msg = 0
		calling = 0
		$timers/skip_msg.stop()
		phone_down()
		target.call()
		return
	var temp = tr(chat[chat_msg][0])
	
	$CanvasLayer/subtitles.visible_ratio = 0
	var temp_sec = randi_range(0, 17)
	$sfx/dia.play(temp_sec)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/subtitles, "visible_ratio", 1.0, chat[chat_msg][1])
	
	#if Input.is_action_just_pressed("skip"):
		#tween.kill()
		#$CanvasLayer/subtitles.visible_ratio = 0
		#print('kileed')
		

	if "%s" in temp:
		$CanvasLayer/subtitles.text = temp % player_name
	else:
		$CanvasLayer/subtitles.text = temp
	



	await get_tree().create_timer(chat[chat_msg][1]).timeout
	$sfx/dia.stop()
	
	
#
#func day1_call1():
	#if chat_msg > 8:
		#chat_msg = 0
		#calling = 0
		#$timers/skip_msg.stop()
		#phone_down()
		#day1_start()
		#return
	#
	#var temp = tr(chat1_array[chat_msg])
	#if "%s" in temp:
		#$CanvasLayer/subtitles.text = temp % player_name
	#else:
		#$CanvasLayer/subtitles.text = temp
	#$sfx/dia.play()

#
#func day1_call2():
	#if chat_msg > 2:
		#chat_msg = 0
		#calling = 0
		#$timers/skip_msg.stop()
		#phone_down()
		#await get_tree().create_timer(1.0).timeout
		#day1_end()
		#return
	#
	#var temp = tr(day1_call2_chat[chat_msg])
	#if "%s" in temp:
		#$CanvasLayer/subtitles.text = temp % player_name
	#else:
		#$CanvasLayer/subtitles.text = temp
	#$sfx/dia.play()


func day1_end():
	$sfx/morning.stop()
	stop_move()
	
	$CanvasLayer/shift2.text = tr("shift") + " " + str(shift)
	$CanvasLayer/t1.text = tr("anomalies_reported")
	$CanvasLayer/t2.text = tr("anomalies_left")
	$CanvasLayer/t3.text = tr("max_danger")
	
	$CanvasLayer/v1.text = str(right_reports_conut)
	$CanvasLayer/v2.text = str(anomaly_events_count)
	$CanvasLayer/v3.text = str(bad_time)
	
	$CanvasLayer/black.visible = 1
	#var tween = create_tween()
	#tween.tween_property($CanvasLayer/black, "modulate:a", 1.0 , 1.4)

var day2_call1_chat = [
	[]
]
