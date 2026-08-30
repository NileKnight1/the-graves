extends Node2D

@onready var walking_sound = $sfx/walk_dirt

var player_name = global.player_name
var shift = global.shift

var computer_area = 0
var computer_opened = 0
var radio_area = 0
var switch_area = 0
var radio_opened = 0
var opened_cam = 1

var antenna_working = 1
var generator_working = 1

var min_spawn_time = 15
var max_spawn_time = 25
var max_anomaly_count = 3
var max_bad_time = 3000

var sabo_game = 0
var min_sabo_time = 60 
var max_sabo_time = 100
var max_sabo_game = 0

var shift_time = 0


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
var punch = preload("res://audio/punch.mp3")




func play_sound(sound):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

func translation():
	#TranslationServer.set_locale("ar") 
	$player.get_child(0).text = player_name
	
	$CanvasLayer/room/menu/title.text = tr("report_radio")
	$CanvasLayer/room/environment/title.text = tr("report_radio")
	$CanvasLayer/room/creatures/title.text = tr("report_radio")
	
	$CanvasLayer/room/menu/environmental.text = tr("environmental")
	$CanvasLayer/room/menu/creatures.text = tr("creatures")
	$CanvasLayer/room/menu/back.text = tr("back")
	$CanvasLayer/room/environment/back.text = tr("back")
	$CanvasLayer/room/creatures/back.text = tr("back")
	$CanvasLayer/room/environment/back.text = tr("back")
	$CanvasLayer/room/creatures/back.text = tr("back")
	
	$CanvasLayer/room/environment/p1.text = tr("part1")
	$CanvasLayer/room/environment/p2.text = tr("part2")
	$CanvasLayer/room/environment/p3.text = tr("part3")
	$CanvasLayer/room/environment/p4.text = tr("part4")
	
	$CanvasLayer/room/creatures/p1.text = tr("part1")
	$CanvasLayer/room/creatures/p2.text = tr("part2")
	$CanvasLayer/room/creatures/p3.text = tr("part3")
	$CanvasLayer/room/creatures/p4.text = tr("part4")
	
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
	tasks()
	#day1_end()
	#get_tree().paused = 1
	phone_up()
	#antenna_sabo()
	#generator_sabo()
	developer()
	#cam_sabo(2)
	#cam_sabo(1)
	#cam_sabo(4)
	day_starters()
	
	#print($player/Camera2D.position)
	#$player/cam_fix.position.x = $player/Camera2D.position.x - 350
	#$player/cam_fix.position.x = $player/Camera2D.position.x + 400
	#$player/cam_fix.position.y = $player/Camera2D.position.y + 140
	#$player/cam_fix.position.y = $player/Camera2D.position.y + 280
	
	
	
	#print($player/Camera2D.)
	
	#phone_down()
	
	
	#apply_anomaly_event()
	#spawn()
#var shift_values = 

func set_shift_values(
	minspawntime = min_spawn_time,
	 maxspawntime = min_spawn_time,
	 maxanomalycount = max_anomaly_count,
	 maxbadtime = max_bad_time,
	 minsabotime = min_sabo_time,
	 maxsabotime = max_sabo_time,
	 maxsabogame = max_sabo_game,
	
	):
	if minspawntime != -1: min_spawn_time = minspawntime
	if maxspawntime != -1: min_spawn_time = maxspawntime
	if maxanomalycount != -1: max_anomaly_count = maxanomalycount
	if maxbadtime != -1: max_bad_time = maxbadtime
	if minsabotime != -1: min_sabo_time = minsabotime
	if maxsabotime != -1: max_sabo_time = maxsabotime
	if maxsabogame != -1: max_sabo_game = maxsabogame

func shift_time_manager():
	match shift:
		1: day1_time()
		2: day2_time()
		3: day3_time()

func day_starters():
	match shift:
		2: day2_starters()
		#3: day3_starterts()

func _on_cams_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and computer_area && generator_working:
		open_cam()
		
func _on_radio_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and radio_area && antenna_working:
		open_radio()

func _on_switch_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and switch_area && generator_working:
		play_sound(click_switch)
		if $lights/room.visible:
			light_off()
		else:
			light_on()

func _on_generator_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and generator_area && !generator_fixing && !generator_working:
		generator_on()
func _on_antenna_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and antenna_area && !antenna_fixing && !antenna_working:
		antenna_on()

func _on_ladder_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if ladder_area_up:
			ladder_down()
		elif ladder_area_down:
			ladder_up()

func _on_cam_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	cam_mouse_click(event, 2)
	

func _on_button_pressed() -> void:
	close_cam()



func open_cam():
	#print("hi")
	$"map above/cams_".visible = 0
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
	$"map above/cams_".visible = 1
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
	$CanvasLayer/room/menu.visible = 1
	radio_opened = 1
	$sfx/radio.play()
	$CanvasLayer/press_e.visible = 0
	#if !day1task2:
		#
	

func close_radio():
	$sfx/radio.stop()
	$CanvasLayer/room/menu.visible = 0
	$CanvasLayer/room/environment.visible = 0
	$CanvasLayer/room/creatures.visible = 0
	radio_opened = 0

func match_shift():
	match shift:
		1:
			match call_index:
				0: day_call(chat1_array, day1_start)
				1: day_call(day1_call2_chat, day_end)
		2:
			match call_index:
				0: day_call(day2_call1_chat, day2_start)
				1: day_call(day2_call2_chat, day_end)
		3:
			match call_index:
				0: day_call(day3_call1_chat, day3_start)
				1: day_chat(day3_creature1_chat, day3_creature1_talked)
				2: day_chat(day3_creature1_chat_stay, day3_creature1_stay)
				3: day_chat(day3_creature1_chat_leave, day3_creature1_leave)
				4: day_chat(day3_creature1_chat_end, day3_creature1_leave)
				5: day_chat(day3_call2_chat, day_end)
				

func _process(delta: float) -> void:
	#print(day1task2)
	if $player.walk && $player.move:
		if !walking_sound.playing:
			walking_sound.play()
			#print("um?a")
		if $player.sprint:
			walking_sound.pitch_scale = 2.0
		else:
			walking_sound.pitch_scale = 1
	else:
		walking_sound.stop()

	match shift:
		2:
			if ps1: $anomalies/anomaly.visible = 0

	if Input.is_action_just_pressed("interact"):
		if computer_area && !computer_opened && generator_working:
			open_cam()
		elif computer_opened:
			close_cam()
	
		if radio_area && !radio_opened && antenna_working:
			open_radio()
			#print("hi")
		elif radio_opened:
			close_radio()
		
		if switch_area && generator_working:
			play_sound(click_switch)
			if $lights/room.visible:
				light_off()
			else:
				light_on()
		
		if generator_fixing:
			$"map behind/generator/ProgressBar".value += 75
			if $"map behind/generator/ProgressBar".value >= 1000:
				generator_fixed()
		
		if generator_area && !generator_fixing && !generator_working:
			generator_on()
		
		if ladder_area_down:
			ladder_up()
		elif ladder_area_up:
			ladder_down()

		
		if antenna_area && !antenna_fixing && !antenna_working:
			antenna_on()
		
		for i in range(4):
			if cam_area[i] && !cam_working[i] && generator_working && !cam_fixing:
				camera_on(i+1)
	
	
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
			
		if opened_cam == 1 && day2creature1_appeared:
			day2creature1_appeared = 0
			play_sound(sudden)
		
		
		$"map above/cams".get_child(opened_cam-1).visible = 1
		$"map above/cams".get_child(opened_cam-1).enabled = 1
		#
	if calling && Input.is_action_just_pressed("skip"):
		chat_msg += 1
		$timers/skip_msg.start()
		match_shift()
		

func _on_switch_body_entered(body: Node2D) -> void:
	if body == $player:
		switch_area = 1
		if generator_working:
			if pc: $CanvasLayer/press_e.visible = 1
			$"map behind/room/switch/outline".visible = 1
func _on_switch_body_exited(body: Node2D) -> void:
	if body == $player:
		switch_area = 0
		$CanvasLayer/press_e.visible = 0
		$"map behind/room/switch/outline".visible = 0
		$"map behind/room/switch/hover".visible = 0
		


func radio_access_on():
	$CanvasLayer/room/menu/environmental.visible = 1
func radio_access_off():
	$CanvasLayer/room/menu/environmental.visible = 0

func stop_move():
	$player.move = 0
	$player/sprite.play("idle")
func allow_move():
	$player.move = 1

func light_off():
	$lights/room.visible = 0
	$"map behind/room/bg/lamp/off".visible = 1
	$"map behind/room/bg/lamp/on".visible = 0
	
func light_on():
	$lights/room.visible = 1
	$"map behind/room/bg/lamp/off".visible = 0
	$"map behind/room/bg/lamp/on".visible = 1

func ladder_up():
	$player.position = Vector2(-533, -580)
	await get_tree().create_timer(0.1).timeout
	$"map behind/out_left/p2/ladder/outline".visible = 1
func ladder_down():
	$player.position = Vector2(-764.0, -47)
	await get_tree().create_timer(0.1).timeout
	$"map behind/out_left/p2/ladder/outline".visible = 1

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
	
	match_shift()

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
				1: day_end()
		2:
			match call_index:
				0: day2_start()
				1: day_end()
		3:
			match call_index:
				0: day3_start()
	call_index +=1
	

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
	
	match_shift()


func shift_end():
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
		if pc  && generator_working:
			$CanvasLayer/press_e.visible = 1
		if generator_working:
			$"map behind/room/desk/outline".visible = 1
		
	if body is CharacterBody2D && body.anomaly:
		#body.queue_free()
		print("bruh")
func _on_cams_body_exited(body: Node2D) -> void:
	if body == $player:
		computer_area = 0
		$CanvasLayer/press_e.visible = 0
		$"map behind/room/desk/hover".visible = 0
		$"map behind/room/desk/outline".visible = 0
		
		

func _on_radio_body_entered(body: Node2D) -> void:
	if body == $player:
		radio_area = 1
		print("radio_area")
		print(radio_area)
		if antenna_working:
			if pc: $CanvasLayer/press_e.visible = 1
			$"map behind/room/radio/outline".visible = 1

func _on_radio_body_exited(body: Node2D) -> void:
	if body == $player:
		radio_area = 0
		$"map behind/room/radio/outline".visible = 0
		$"map behind/room/radio/hover".visible = 0
		
		if radio_opened:
			radio_opened = 0
			$sfx/radio.stop()
			
			$CanvasLayer/room/menu.visible = 0
			$CanvasLayer/room/environment.visible = 0
			$CanvasLayer/room/creatures.visible = 0
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
	$timers/spawn.wait_time = randi_range(min_spawn_time, max_spawn_time)
	$timers/spawn.start()
	


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
	if anomaly_events_count > max_anomaly_count -1 :
		return
		
	print("evented")
	for i in anomaly_events:
		#print(computer_opened && i["area"] == opened_cam)
		
		if (computer_opened && i["area"] == opened_cam) || i["exist"]: continue
		
		match i["area"]:
			1: if ps1: continue
			2: if ps2: continue
			3: if ps3: continue
			4: if ps4: continue
			
		
		for j in range(i["prob"]):
			anomaly_events_prob.append(i)
	
	
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
	
	if cam_helper_creature_exist:
		cam_helper_creature(anomaly_events[temp2]["area"])
	
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
	{"area"=1, "show"=[^"map above/left/trees/tree6"], "hide"=[^"map above/left/trees/tree1"], "exist"= 0, "prob"= 3},
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
	$CanvasLayer/room/environment/p1.disabled = 1
	$CanvasLayer/room/environment/p2.disabled = 1
	$CanvasLayer/room/environment/p3.disabled = 1
	$CanvasLayer/room/environment/p4.disabled = 1
	
	await get_tree().create_timer(2.0).timeout
	$CanvasLayer/room/environment/p1.disabled = 0
	$CanvasLayer/room/environment/p2.disabled = 0
	$CanvasLayer/room/environment/p3.disabled = 0
	$CanvasLayer/room/environment/p4.disabled = 0
	
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
	$CanvasLayer/room/environment.visible = 1
	$CanvasLayer/room/menu.visible = 0
func _on_creatures_pressed() -> void:
	play_sound(click_radio)
	$CanvasLayer/room/creatures.visible = 1
	$CanvasLayer/room/menu.visible = 0
func _on_back_pressed() -> void:
	play_sound(click_radio)
	$CanvasLayer/room/environment.visible = 0
	$CanvasLayer/room/creatures.visible = 0
	$CanvasLayer/room/menu.visible = 1

var bad_time = 0

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
	
	shift_time_manager()
	if shift_time == 360:
		shift_end()

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

func tasks():
	match shift:
		1: 
			$"map behind/room/tasks/day1".visible = 1
			day1call1_done = 0
			discovered = 0
			day1task3 = 0
			
		#2:$"map behind/room/tasks/day2".visible = 1
	
	

func shift_start():
	play_sound(start_sound)
	radio_access_on()
	
	$CanvasLayer/danger.visible = 1
	$CanvasLayer/reports.visible = 1
	
	$CanvasLayer/shift.visible = 1
	$CanvasLayer/time.visible = 1
	
	$timers/bad_time.start()
	$timers/spawn.start()
	$timers/shift_time.start()

var generator_area = 0
var generator_fixing = 0
var generator_dec_apply = 0

func generator_sabo():
	generator_working = 0
	
	cam_sabo(1)
	cam_sabo(2)
	cam_sabo(3)
	cam_sabo(4)
	
	if computer_opened: close_cam()
	$"map behind/generator/on".visible = 0
	$"map behind/generator/off".visible = 1
	$"map behind/room/desk/VideoStreamPlayer".visible = 0
	light_off()
	
	subtitle("generatorsabo", 1.0)
	await get_tree().create_timer(3.0).timeout
	subtitle("", 0)

func generator_on():
	print("gen on")
	$"map behind/generator/ProgressBar".visible = 1
	$"map behind/generator/E".visible = 1
	generator_dec_apply = 1
	generator_dec()
	generator_fixing = 1
	#$"map behind/generator/ProgressBar".value -= 5


	
	#await get_tree().create_timer(5.0).timeout
func generator_fixed():
	cam_current = 1
	cam_fixed()
	cam_current = 2
	cam_fixed()
	cam_current = 3
	cam_fixed()
	cam_current = 4
	cam_fixed()
	
	generator_working = 1
	$"map behind/generator/on".visible = 1
	$"map behind/generator/off".visible = 0
	$"map behind/generator/ProgressBar".visible = 0
	$"map behind/generator/E".visible = 0
	$"map behind/room/desk/VideoStreamPlayer".visible = 1
	$"map behind/generator/ProgressBar".value = 250
	$"map behind/generator/outline".visible = 0
	$"map behind/generator/hover".visible = 0
	
	
	generator_dec_apply = 0
	generator_fixing = 0

func generator_failed():
	generator_dec_apply = 0
	generator_fixing = 0
	$"map behind/generator/ProgressBar".visible = 0
	$"map behind/generator/E".visible = 0
	$"map behind/generator/ProgressBar".value = 250

func generator_dec():
	while generator_dec_apply:
		await get_tree().create_timer(0.01).timeout
		$"map behind/generator/ProgressBar".value -= 2
		if $"map behind/generator/ProgressBar".value <= 0:
			generator_failed()

func _on_generator_body_entered(body: Node2D) -> void:
	if body == $player:
		if day2force: return
		if !day3_visitor_safe: day3_visitor_appear()
		if !day4_creature1_safe: day4_creature_appear()
		
		generator_area = 1
		if !generator_working:
			$"map behind/generator/outline".visible = 1
			
		print("here")
func _on_generator_body_exited(body: Node2D) -> void:
	if body == $player:
		generator_area = 0
		$"map behind/generator/outline".visible = 0
		$"map behind/generator/hover".visible = 0
		

var ladder_area_down = 0
var ladder_area_up = 0

func _on_ladder_body_entered(body: Node2D) -> void:
	if body == $player:
		ladder_area_down = 1
		$"map behind/out_left/p2/ladder/outline".visible = 1
		$CanvasLayer/press_e.visible = 1
func _on_ladder_body_exited(body: Node2D) -> void:
	if body == $player:
		ladder_area_down = 0
		$"map behind/out_left/p2/ladder/outline".visible = 0
		$"map behind/out_left/p2/ladder/hover".visible = 0
		
		$CanvasLayer/press_e.visible = 0
func _on_ladder_up_entered(body: Node2D) -> void:
	if body == $player:
		ladder_area_up = 1
		$"map behind/out_left/p2/ladder/outline".visible = 1
		$CanvasLayer/press_e.visible = 1
func _on_ladder_up_exited(body: Node2D) -> void:
	if body == $player:
		ladder_area_up = 0
		$"map behind/out_left/p2/ladder/outline".visible = 0
		$"map behind/out_left/p2/ladder/hover".visible = 0
		
		$CanvasLayer/press_e.visible = 0

var antenna_area = 0
var antenna_fixing = 0


func _on_antenna_body_entered(body: Node2D) -> void:
	if body == $player:
		antenna_area = 1
		if !antenna_working:
			$"map behind/room/antenna/outline".visible = 1
func _on_antenna_body_exited(body: Node2D) -> void:
	if body == $player:
		antenna_area = 0
		$"map behind/room/antenna/outline".visible = 0
		$"map behind/room/antenna/hover".visible = 0
		
		$"map behind/room/antenna/fix".visible = 0
		antenna_failed()

var antenna_nums = [1, 2, 3, 4, 5, 6, 7 ,8, 9, 10]
var antenna_nums_temp = []

func antenna_on():
	$"map behind/room/antenna/fix".visible = 1
	antenna_fixing = 1
	antenna_current_num = 1
	antenna_nums_temp = antenna_nums.duplicate()
	antenna_time()
	#print(antenna_nums)
	
	for i in $"map behind/room/antenna/fix/nums".get_children():
		var temp = randi_range(0, len(antenna_nums_temp)-1)
		i.text = str(antenna_nums_temp[temp])
		antenna_nums_temp.remove_at(temp)
		#print(antenna_nums)
		
		

var antenna_current_num = 1

func antenna_sabo():
	antenna_working = 0
	$"map behind/room/antenna/off".visible = 1
	$"map behind/room/antenna/on".visible = 0
	close_radio()
	
	subtitle("antennasabo", 1.0)
	await get_tree().create_timer(3.0).timeout
	subtitle("", 0)
	

func antenna_fixed():
	antenna_working = 1
	$"map behind/room/antenna/outline".visible = 0
	$"map behind/room/antenna/hover".visible = 0
	
	antenna_reset()
	$"map behind/room/antenna/off".visible = 0
	$"map behind/room/antenna/on".visible = 1
	

func antenna_failed():
	antenna_reset()
	for i in $"map behind/room/antenna/fix/nums".get_children():
		i.set_deferred("disabled", 0)


func antenna_reset():
	$"map behind/room/antenna/fix".visible = 0
	antenna_current_num = 1
	antenna_fixing = 0
	

func antenna_num_pressed(num):
	$"map behind/room/antenna/fix/nums".get_child(num-1).set_deferred("disabled", 1)
	if str(antenna_current_num) != $"map behind/room/antenna/fix/nums".get_child(num-1).text:
		antenna_failed()
	elif antenna_current_num == 10:
		antenna_fixed()
	
	antenna_current_num += 1

func antenna_time():
	var time = 5
	$"map behind/room/antenna/fix/time".text = "00:0" + str(time)
	
	for i in range(5):
		if !antenna_fixing: return
		time -= 1
		await get_tree().create_timer(1.0).timeout
		$"map behind/room/antenna/fix/time".text = "00:0" + str(time)
	
	antenna_failed()


func _on_antenna_fix_num1_pressed() -> void:
	antenna_num_pressed(1)
func _on_antenna_fix_num2_pressed() -> void:
	antenna_num_pressed(2)
func _on_antenna_fix_num3_pressed() -> void:
	antenna_num_pressed(3)
func _on_antenna_fix_num4_pressed() -> void:
	antenna_num_pressed(4)
func _on_antenna_fix_num5_pressed() -> void:
	antenna_num_pressed(5)
func _on_antenna_fix_num6_pressed() -> void:
	antenna_num_pressed(6)
func _on_antenna_fix_num7_pressed() -> void:
	antenna_num_pressed(7)
func _on_antenna_fix_num8_pressed() -> void:
	antenna_num_pressed(8)
func _on_antenna_fix_num9_pressed() -> void:
	antenna_num_pressed(9)
func _on_antenna_fix_num10_pressed() -> void:
	antenna_num_pressed(10)


func _on_cams_mouse_entered() -> void:
	if computer_area && generator_working:
		$"map behind/room/desk/hover".visible = 1
		$"map behind/room/desk/outline". visible = 0
func _on_cams_mouse_exited() -> void:
	if computer_area && generator_working:
		$"map behind/room/desk/hover".visible = 0
		$"map behind/room/desk/outline". visible = 1
func _on_radio_mouse_entered() -> void:
	if radio_area && antenna_working:
		$"map behind/room/radio/outline".visible = 0
		$"map behind/room/radio/hover".visible = 1
func _on_radio_mouse_exited() -> void:
	if radio_area && antenna_working:
		$"map behind/room/radio/outline".visible = 1
		$"map behind/room/radio/hover".visible = 0
func _on_switch_mouse_entered() -> void:
	if switch_area && generator_working:
		$"map behind/room/switch/outline".visible = 0
		$"map behind/room/switch/hover".visible = 1
func _on_switch_mouse_exited() -> void:
	if switch_area && generator_working:
		$"map behind/room/switch/outline".visible = 1
		$"map behind/room/switch/hover".visible = 0
func _on_generator_mouse_exited() -> void:
	if generator_area && !generator_working && !generator_fixing:
		$"map behind/generator/outline".visible = 1
		$"map behind/generator/hover".visible = 0
func _on_generator_mouse_entered() -> void:
	if generator_area && !generator_working && !generator_fixing:
		$"map behind/generator/outline".visible = 0
		$"map behind/generator/hover".visible = 1
func _on_ladder__mouse_exited() -> void:
	if ladder_area_down || ladder_area_up:
		$"map behind/out_left/p2/ladder/outline".visible = 1
		$"map behind/out_left/p2/ladder/hover".visible = 0
func _on_ladder__mouse_entered() -> void:
	if ladder_area_down || ladder_area_up:
		$"map behind/out_left/p2/ladder/outline".visible = 0
		$"map behind/out_left/p2/ladder/hover".visible = 1
func _on_antenna_mouse_exited() -> void:
	if antenna_area && !antenna_working && !antenna_fixing:
		$"map behind/room/antenna/outline".visible = 1
		$"map behind/room/antenna/hover".visible = 0
func _on_antenna_mouse_entered() -> void:
	if antenna_area && !antenna_working && !antenna_fixing:
		$"map behind/room/antenna/outline".visible = 0
		$"map behind/room/antenna/hover".visible = 1


func _on_cam_2_body_entered(body: Node2D) -> void:
	cam_entered(2)
func _on_cam_2_body_exited(body: Node2D) -> void:
	cam_exited(2)
func _on_cam_2_mouse_entered() -> void:
	cam_mouse_enter(2)
func _on_cam_2_mouse_exited() -> void:
	cam_mouse_exit(2)

#func _on_cam_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#cam_mouse_click(2)

var cam_working = [1, 1, 1, 1]
var cam_area = [0, 0, 0, 0]
var cam_fixing = 0
var cam_fix_pressed = 0
var cam_fix_current = 1
var cam_current = 1


func cam_entered(num):
	if !cam_working[num-1] && generator_working:
		$"map above/cams_".get_child(num-1).get_child(0).visible = 1
		cam_area[num-1] = 1
		if pc:$CanvasLayer/press_e.visible = 1

func cam_exited(num):
	$"map above/cams_".get_child(num-1).get_child(0).visible = 0
	$"map above/cams_".get_child(num-1).get_child(1).visible = 0
	cam_area[num-1] = 0
	$CanvasLayer/press_e.visible = 0

func cam_mouse_enter(num):
	if cam_area[num-1] && !cam_working[num-1] && generator_working:
		$"map above/cams_".get_child(num-1).get_child(0).visible = 0
		$"map above/cams_".get_child(num-1).get_child(1).visible = 1

func cam_mouse_exit(num):
	if cam_area[num-1] && !cam_working[num-1] && generator_working:
		$"map above/cams_".get_child(num-1).get_child(0).visible = 1
		$"map above/cams_".get_child(num-1).get_child(1).visible = 0

func camera_on(num):
	#$player/cam_fix.position.x = $player/Camera2D.position.x - 440
	#$player/cam_fix.position.x = $player/Camera2D.position.x + 340
	#$player/cam_fix.position.y = $player/Camera2D.position.y
	#$player/cam_fix.position.y = $player/Camera2D.position.y - 180
	cam_fixing = 1
	cam_current = num
	cam_fix_pressed = 0
	cam_fix_current = 1

	
	cam_fix_rand(cam_fix_current)

var cam_prog_time = 0

func cam_fix_rand(x):
	if cam_fix_pressed == 3:
		cam_fixed()
	cam_prog_time = 0
	$player/cam_fix/bar.value = 0
	await get_tree().create_timer(0.02).timeout

	#$player/cam_fix.position.x = $player/Camera2D.position.x - 350
	#$player/cam_fix.position.x = $player/Camera2D.position.x + 400
	#$player/cam_fix.position.y = $player/Camera2D.position.y + 140
	#$player/cam_fix.position.y = $player/Camera2D.position.y + 280
	if cam_fixing:
		$player/cam_fix.visible = 1
		cam_prog_time = 1
		cam_prog()
	var tempx = randi_range($player/Camera2D.position.x - 350, $player/Camera2D.position.x + 400)
	var tempy = randi_range($player/Camera2D.position.y + 140, $player/Camera2D.position.y + 280)
	$player/cam_fix.position = Vector2(tempx, tempy)
	print("cam_fix_pressed: "+str(cam_fix_pressed))
	print("x: "+str(x))
	

	await get_tree().create_timer(3).timeout
	if cam_fix_pressed < x:
		cam_prog_time = 0
		cam_failed()

func cam_prog():
	while cam_prog_time:
		await get_tree().create_timer(0.01).timeout
		$player/cam_fix/bar.value += 1


func cam_sabo(num):
	subtitle("camsabo", 1.0)
	cam_working[num-1] = 0
	$"map above/cams_".get_child(num-1).get_child(8).visible = 1
	$"map above/cams_".get_child(num-1).get_child(7).visible = 0
	$"map above/cams".get_child(num-1).get_child(0).visible = 1
	
	await get_tree().create_timer(3.0).timeout
	subtitle("", 0)

func cam_fixed():
	cam_prog_time = 0
	cam_working[cam_current-1] = 1
	$CanvasLayer/press_e.visible = 0
	cam_fixing = 0
	$player/cam_fix.visible = 0
	print("cam fixed")
	#print($"map above/cams_".get_child(cam_current-1).get_children())
	#print(cam_current)
	#print($"map above/cams_".get_child(cam_current-1).get_child(8))
	$"map above/cams".get_child(cam_current-1).get_child(0).visible = 0
	$"map above/cams_".get_child(cam_current-1).get_child(8).visible = 0
	$"map above/cams_".get_child(cam_current-1).get_child(7).visible = 1
	$"map above/cams_".get_child(cam_current-1).get_child(0).visible = 0
	$"map above/cams_".get_child(cam_current-1).get_child(1).visible = 0
	

func cam_mouse_click(event, num):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if cam_area[num-1] && !cam_working[num-1] && generator_working && !cam_fixing:
			camera_on(num)

func cam_failed():
	$player/cam_fix.visible = 0
	cam_fixing = 0
	cam_prog_time = 0
	print("loser")

func _on_cam_fix_pressed() -> void:
	cam_fix_pressed += 1
	cam_fix_current += 1
	cam_fix_rand(cam_fix_current)


func _on_cam_1_body_entered(body: Node2D) -> void:
	cam_entered(1)
func _on_cam_1_body_exited(body: Node2D) -> void:
	cam_exited(1)
func _on_cam_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	cam_mouse_click(event, 1)
func _on_cam_1_mouse_entered() -> void:
	cam_mouse_enter(1)
func _on_cam_1_mouse_exited() -> void:
	cam_mouse_exit(1)
func _on_cam_3_body_entered(body: Node2D) -> void:
	cam_entered(3)
func _on_cam_3_body_exited(body: Node2D) -> void:
	cam_exited(3)
func _on_cam_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	cam_mouse_click(event, 3)
func _on_cam_3_mouse_entered() -> void:
	cam_mouse_enter(3)
func _on_cam_3_mouse_exited() -> void:
	cam_mouse_exit(3)
func _on_cam_4_body_entered(body: Node2D) -> void:
	cam_entered(4)
func _on_cam_4_body_exited(body: Node2D) -> void:
	cam_exited(4)
func _on_cam_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	cam_mouse_click(event, 4) 
func _on_cam_4_mouse_entered() -> void:
	cam_mouse_enter(4)
func _on_cam_4_mouse_exited() -> void:
	cam_mouse_exit(4)

func sabo_time():
	var temp = randi_range(min_sabo_time, max_sabo_time)
	print(min_sabo_time)
	print(max_sabo_time)
	
	$timers/sabo_timer.wait_time = temp
	$timers/sabo_timer.start()
	print("sabo time started")

func _on_sabo_timer_timeout() -> void:
	sabo_time()
	if sabo_game == max_sabo_game: return
	sabo_game += 1
	print("sabotaging")
	var temp = randi_range(1, 8)
	var temp_to = 0
	var temp_cam = []

	for i in range(4):
		if cam_working[i]:
			temp_cam.append(i)
	#if temp_to == 0:
		#temp_cam = [-1]
	#elif temp_to == 1:
		#for i in range(4):
			#if i: temp_cam = [i]

	if temp < 6 && generator_working:
		cam_sabo(temp_cam.pick_random()-1)
	elif temp < 8 && generator_working:
		generator_sabo()
	elif antenna_working:
		antenna_sabo()

func _on_option_1_pressed() -> void:
	decision_option(0)
func _on_option_2_pressed() -> void:
	decision_option(1)

func show_decision_option(title, o1, o2):
	close_radio()
	$CanvasLayer/decision/title.text = title
	$CanvasLayer/decision/o1.text = o1
	$CanvasLayer/decision/o2.text = o2
	$CanvasLayer/decision.visible = 1

func decision_option(option):
	print(call_index)
	match shift:
		3:
			match call_index:
				2:
					match option:
						0: day3_creature1_yes()
						1: day3_creature1_no()
	$CanvasLayer/decision.visible = 0

func day_call(chat, target):
	if chat_msg == len(chat):
		chat_msg = 0
		call_index += 1
		calling = 0
		$timers/skip_msg.stop()
		phone_down()
		target.call()
		return
	
	match shift:
		3:
			match call_index:
				0: if !global.day2creature_found && chat_msg == 1: chat_msg+= 1
	
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

func day_chat(chat, target):
	if chat_msg == len(chat):
		#print("chat done")
		chat_msg = 0
		call_index += 1
		calling = 0
		$timers/skip_msg.stop()
		target.call()
		return
	
	var temp = tr(chat[chat_msg][0])
	$CanvasLayer/subtitles.visible_ratio = 0
	var temp_sec = randi_range(0, 17)
	$sfx/dia.play(temp_sec)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/subtitles, "visible_ratio", 1.0, chat[chat_msg][1])

	if "%s" in temp:
		$CanvasLayer/subtitles.text = temp % player_name
	else:
		$CanvasLayer/subtitles.text = temp

	await get_tree().create_timer(chat[chat_msg][1]).timeout
	$sfx/dia.stop()

func day_end():
	$sfx/morning.stop()
	stop_move()
	$CanvasLayer/black.visible = 1
	
	await get_tree().create_timer(1.0).timeout
	play_sound(start_sound)
	$CanvasLayer/shift2.text = tr("shift") + " " + str(shift)
	
	await get_tree().create_timer(1.5).timeout
	$CanvasLayer/t1.text = tr("anomalies_reported")
	$CanvasLayer/v1.text = str(right_reports_conut)
	play_sound(punch)
	
	
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/t2.text = tr("anomalies_left")
	$CanvasLayer/v2.text = str(anomaly_events_count)
	play_sound(punch)
	
	await get_tree().create_timer(0.4).timeout
	$CanvasLayer/t3.text = tr("max_danger")
	$CanvasLayer/v3.text = str(bad_time)
	play_sound(punch)
	
	
	#var tween = create_tween()
	#tween.tween_property($CanvasLayer/black, "modulate:a", 1.0 , 1.4)
	await get_tree().create_timer(5.0).timeout
	global.shift += 1
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	#day2_start()


var day1call1_done = 1
var discovered = 1
var day1task2 = 1
var day1task3 = 1

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
		
		shift_start()
		
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
	#call_index = 1
	
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

### Planning
# shift1: environmental - 3 max - 15:25 secs (2:00) 15:20 (4:00) 14:18 (6:00) - 300 danger
# shift2: environmental - 4 max - 20:25 (01:00) 15:20 (02:30) 12:16 (4:00) 8:14 secs - 300 danger generator_sabotaged
# shift3: environmental - 4 max - 12:18 secs - 300 danger generator/cams/antenna



func day1_time():
	if shift_time == 120:
		set_shift_values(15, 20)
	elif shift_time == 240:
		set_shift_values(14, 18)
		

func start_chat():
	call_time = 0
	calling = 1
	$timers/skip_msg.start()
	
	match_shift()

var day2_call1_chat = [
	["day2call1sen1", 1.0],
	["day2call1sen2", 2.0],
	["day2call1sen3", 2.5],
	["day2call1sen4", 2.0],
	["day2call1sen5", 0.5],
	
]
#
#func day2_call1():
	#phone_up()

var day2_call2_chat = [
	["day2call2sen1", 1.5],
	["day2call2sen2", 1.0],
	
	
]

var day2force = 0

func day2_starters():
	#generator_sabo()
	set_shift_values(15, 20, 4, 300, 40, 60, 7)
	day2force = 1

func day2_time():
	if shift_time == 1:
		print("im here")
	elif shift_time == 60:
		set_shift_values(15, 20)
	elif shift_time == 150:
		set_shift_values(12, 16)
	elif shift_time == 240:
		set_shift_values(8, 14)
	elif shift_time == 300:
		day2_creature1()
	#elif

func day2_start():
	print("day2")
	day2force = 0
	subtitle("day2sub1", 1.0)
	#call_index += 1
	shift_start()
	#await get_tree().create_timer(1.0).timeout
	
	sabo_time()
	await get_tree().create_timer(3.0).timeout
	subtitle("", 0)

var day2creature1_appeared = 0

func day2_creature1():
	if ps1 || (computer_opened && opened_cam == 1): 
		await get_tree().create_timer(1.0).timeout
		day2_creature1()
		return
	$anomalies/anomaly.visible = 1
	day2creature1_appeared = 1
	global.day2creature_found = 1
	
	print("anomaly is here")



func day3_time():
	if shift_time == 1:
		print("im here")
	elif shift_time == 60:
		set_shift_values(15, 20)
	elif shift_time == 150:
		set_shift_values(12, 16)
	elif shift_time == 240:
		set_shift_values(8, 14)

var day3_call1_chat = [
	["day3call1sen1", 1.0],
	["day3call1sen2", 1.0],
	["day3call1sen3", 1.0],
	["day3call1sen4", 1.0],
]

func day3_start():
	print("day3")
	
	#call_index += 1
	shift_start()
	day3_visitor()
	#sabo_time()

var day3_visitor_safe = 1

func day3_visitor():
	#cam_sabo(3)
	
	await get_tree().create_timer(60).timeout
	if generator_area:
		day3_visitor_appear()
	day3_visitor_safe = 0 
	generator_sabo()

func day3_visitor_appear():
	$anomalies/anomaly2.visible = 1
	print ("it appear yabaa")


### Planninga
# shift1: environmental - 3 max - 15:25 secs (2:00) 15:20 (4:00) 14:18 (6:00) - 300 danger
# shift2: environmental - 4 max - 15:25 (01:00) 15:20 (02:30) 12:16 (4:00) 8:14 secs - 300 danger generator_sabotaged
# shift3: environmental - 4 max - 12:18 secs - 300 danger generator/cams/antenna

func flicker_effect():
	$CanvasLayer/VideoStreamPlayer.visible = 1
	await get_tree().create_timer(0.2).timeout
	$CanvasLayer/VideoStreamPlayer.visible = 0


var day3_creature1_area = 0

func _on_day_3_visitorfound_body_entered(body: Node2D) -> void:
	if body == $player:
		day3_creature1_area = 1
		
		if $anomalies/anomaly2.visible && day3_creature1_shift:
			stop_move()
			start_chat()
			
		elif $anomalies/anomaly2.visible && !cam_helper_creature_exist:
			stop_move()
			print($anomalies/anomaly2.position)
			#$anomalies/anomaly2.position = Vector2(-706.0, -26)
			$timers/bad_time.paused = 1
			#$timers
			print(call_index)
			print("speak")
			#$player/sprite.play("idle")
			play_sound(sudden)
			$player/Camera2D.enabled = 0
			$player/Camera2D2.enabled = 1
			flicker_effect()
			await get_tree().create_timer(1.0).timeout
			$player.position.x = 300
			$player/Camera2D.enabled = 1
			$player/Camera2D2.enabled = 0
			start_chat()
func _on_day_3_visitorfound_body_exited(body: Node2D) -> void:
	if body == $player:
		day3_creature1_area = 0


var day3_creature1_chat = [
	["d3c1s1", 0.5],
	["d3c1s2", 1.0],
	["d3c1s3", 1.5],
]

func day3_creature1_talked():
	#allow_move()
	#call_index += 1
	print("call index" + str(call_index))
	#await get_tree().create_timer(1.0).timeout
	show_decision_option("Answer", "youcanstay", "nosorry.")
	#subtitle("", 0)

# Creature 1 -> Day2 -> appear once and disappear
# Creature 1 -> Day3 -> appear in security room -> asks for stay
## yes -> it stays -> it watches cameras
## no -> it goes -> he simply goes

var day3_creature1_chat_stay = [
	["d3c1s5", 1.0],
	["d3c1s6", 1.0],
]

var day3_creature1_chat_leave = [
	["d3c1s4", 0.5],
]

func day3_creature1_yes():
	start_chat()
func day3_creature1_no():
	call_index += 1
	start_chat()

var cam_helper_creature_exist = 0

func day3_creature1_stay():
	global.day3creature_stayed = 1
	allow_move()
	call_index += 1
	$timers/bad_time.paused = 0
	cam_helper_creature_exist = 1
	#$areas/day3visitorfound/CollisionShape2D.set_deferred("disabled", 1)
	day3_creature1_end_()
	await get_tree().create_timer(4.0).timeout
	sabo_time()
	subtitle("", 0)

var day3_creature1_chat_end = [
	["d3c1s7", 1],
	["d3c1s8", 1],
]

var day3_creature1_shift = 0

func day3_creature1_end_():
	print("leave soon")
	await get_tree().create_timer(90).timeout
	#call_index += 1
	sabo_time()
	cam_helper_creature_exist = 0
	day3_creature1_shift = 1
	subtitle("leaving", 1)
	if day3_creature1_area:
		day3_creature1_area = 0
		stop_move()
		start_chat()

func day3_creature1_leave():
	print("no sorry")
	
	$anomalies/anomaly2.speed = 200
	$anomalies/anomaly2.destination = Vector2(-706.0, $anomalies/anomaly2.global_position.y)
	
	$anomalies/anomaly2.move = 1
	
	await get_tree().create_timer(4.0).timeout
	$anomalies/anomaly2.visible = 0
	allow_move()
	$timers/bad_time.paused = 0
	subtitle("", 0)

func cam_helper_creature(area):
	await get_tree().create_timer(5).timeout
	subtitle("area", 1.0)
	await get_tree().create_timer(1).timeout
	$CanvasLayer/subtitles.text += str(area)
	await get_tree().create_timer(2.9).timeout
	subtitle("", 0)

var day3_call2_chat = [
	["day3call2sen1", 1],
]

func day4_time():
	if shift_time == 1:
		print("im here")
	elif shift_time == 60:
		set_shift_values(15, 20)
	elif shift_time == 150:
		set_shift_values(12, 16)
	elif shift_time == 240:
		set_shift_values(8, 14)
	elif shift_time == 300:
		day2_creature1()

func day4_start():
	print("dayd")
	shift_start()
	day4_visitor()
	#sabo_time()

var day4_creature1_safe = 1

func day4_visitor():
	await get_tree().create_timer(10).timeout
	generator_sabo()
	if generator_area:
		day4_creature_appear()

func day4_creature_appear():
	$anomalies/anomaly2.visible = 1
	
