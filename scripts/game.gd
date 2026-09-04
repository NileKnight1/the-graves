extends Node2D

@onready var walking_sound = $sfx/walk_dirt

var player_name = global.player_name
var shift = global.shift

var computer_area = 0
var computer_opened = 0
var radio_area = 0
var switch_area = 0
var news_area = 0
var radio_opened = 0
var opened_cam = 1

var antenna_working = 1
var generator_working = 1
var generator_stolen = 0

var min_spawn_time = 15
var max_spawn_time = 25
var max_anomaly_count = 3
var max_bad_time = 3000

var sabo_game = 0
var min_sabo_time = 60 
var max_sabo_time = 100
var max_sabo_game = 0

var shift_time = 0

var force_radio_close = 0
var force_cam_close = 0
var force_generator_nofix = 0
var force_generator_nosabo = 0

var vamp1 = preload("res://assets/vamp1.png")
var vamp2 = preload("res://assets/vamp2.png")
var vamp3 = preload("res://assets/vamp3.png")
var frank1 = preload("res://assets/frank1.png")
var frank2 = preload("res://assets/frank2.png")
var frank3 = preload("res://assets/frank3.png")

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
var scary = preload("res://audio/dragon-studio-scary-transition-401717.mp3")
var high_pitch = preload("res://audio/highpitch.mp3")
var beep = preload("res://audio/dragon-studio-censor-beep-1-372459.mp3")
var vamp_laugh = preload("res://audio/vamp_laught.mp3")
var bats = preload("res://audio/bats.mp3")
var hiss = preload("res://audio/hiss.mp3")
var bite = preload("res://audio/bite.mp3")
var frank_scream = preload("res://audio/frank.mp3")
var electricity = preload("res://audio/electricity.mp3")
var psst = preload("res://audio/psst.mp3")
var door = preload("res://audio/door.mp3")
var fnaf = preload("res://audio/freesound_community-cryo_outage-94622.mp3")
var paper_turn = preload("res://audio/paper_turn.mp3")





func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

var flicker = preload("res://assets/flicker.ogv")
#var crawl = preload("res://assets/chroma-keyed-video2.ogv")
var crawl = preload("res://assets/chroma-keyed-video (1).ogv")


func flicker_effect():
	$CanvasLayer/VideoStreamPlayer.visible = 1
	$CanvasLayer/VideoStreamPlayer.stream = flicker
	$CanvasLayer/VideoStreamPlayer.play()
	await get_tree().create_timer(0.2, false, false, false).timeout
	$CanvasLayer/VideoStreamPlayer.stream = null
	$CanvasLayer/VideoStreamPlayer.visible = 0
	$CanvasLayer/VideoStreamPlayer.stop()

var force_camera = 0

func crawl_effect():
	global.day4crawl = 1
	force_camera = 1
	await get_tree().create_timer(2, false, false, false).timeout
	print('effect')
	var hand1 = $CanvasLayer/textures/hand1
	var hand2 = $CanvasLayer/textures/hand2
	var time = $CanvasLayer/gui/time
	var danger = $CanvasLayer/gui/danger
	
	$sfx/heartbeats.play()
	
	hand1.visible = 1
	var tween = create_tween()
	tween.tween_property(hand1 ,"position:y", hand1.position.y + 90 , 1)
	await get_tree().create_timer(1.5, false, false, false).timeout
	$sfx/heartbeats.volume_db += 2
	var tween2 = create_tween()
	var tween3 = create_tween()
	tween2.tween_property(hand1 ,"position:y", hand1.position.y - 90 , 0.5)
	tween3.tween_property(time ,"position:y", time.position.y - 90 , 0.5)
	await get_tree().create_timer(5, false, false, false).timeout
	$sfx/heartbeats.volume_db += 2
	$sfx/night.volume_db = -80
	$sfx/camera.volume_db = -80
	var tween4 = create_tween()
	tween4.tween_property(hand2 ,"position:x", hand2.position.x - 90 , 1)

	await get_tree().create_timer(1.5, false, false, false).timeout
	$sfx/heartbeats.volume_db += 2
	var tween5 = create_tween()
	var tween6 = create_tween()
	tween5.tween_property(hand2 ,"position:x", hand2.position.x + 90 , 0.2)
	tween6.tween_property(danger ,"position:x", danger.position.x + 350 , 0.2)
	
	#return
	await get_tree().create_timer(1.2, false, false, false).timeout
	$CanvasLayer/overscreen/black.visible = 1
	
	play_sound(beep, 5.0)
	await get_tree().create_timer(1.2, false, false, false).timeout
	play_sound(beep, 5.0)
	await get_tree().create_timer(1.2, false, false, false).timeout
	play_sound(beep, 5.0)
	$sfx/heartbeats.stop()
	await get_tree().create_timer(1.2, false, false, false).timeout
	screen_shake(30, 4)


	#await get_tree().create_timer(2, false, false, false).timeout
	$CanvasLayer/overscreen/black.visible = 0
	screen_shake(60, 3)
	$sfx/heartbeats.volume_db += 2
	await get_tree().create_timer(2, false, false, false).timeout
	$sfx/heartbeats.stop()
	#$sfx/night.volume_db = 0
	#$sfx/camera.volume_db = 0
	await get_tree().create_timer(2.8, false, false, false).timeout
	screen_shake(150, 1)
	await get_tree().create_timer(0.2, false, false, false).timeout
	$CanvasLayer/videostream2.visible = 1
	$CanvasLayer/videostream2.stream = crawl
	$CanvasLayer/videostream2.play()
	$CanvasLayer/videostream2.stream_position = 7
	play_sound(scary, 10.0)
	
	await get_tree().create_timer(0.6, false, false, false).timeout
	#close_cam()
	$CanvasLayer/videostream2.stream = null
	$CanvasLayer/videostream2.visible = 0
	$CanvasLayer/videostream2.stop()
	play_sound(high_pitch, 5.0)
	force_camera = 0
	await get_tree().create_timer(0.2, false, false, false).timeout
	flicker_effect()
	await get_tree().create_timer(0.2, false, false, false).timeout
	flicker_effect()
	$CanvasLayer/overscreen/black.visible = 1
	generator_sabo()
	var tween7 = create_tween()
	tween7.tween_property($CanvasLayer/overscreen/black, "modulate:a", 0, 5.0)
	flicker_effect()
	await get_tree().create_timer(0.2, false, false, false).timeout
	flicker_effect()
	await get_tree().create_timer(0.7, false, false, false).timeout
	time.position.y += 90
	danger.position.x -= 350
	$sfx/night.volume_db = 0
	$sfx/camera.volume_db = 0
	sabo_time()
	


var shake_intensity = 0.0
var active_shake_time = 0.0
var shake_decay = 5.0
var shake_time = 0.0
var shake_time_speed = 20.0
var noise = FastNoiseLite.new()

#func shake_cam():


func screen_shake(intensity, time):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0


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
	
	$CanvasLayer/gui/shift.text = tr("shift") + " " + str(shift)
	$CanvasLayer/gui/danger.text = tr("danger") + " " + str(bad_time) + "/" + str(max_bad_time)
	#
	#if (TranslationServer.get_locale() == 'ar'):
		#$CanvasLayer/gui/danger.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	#
	$CanvasLayer/gui/reports.text = tr("wrong_reports") + " " + str(wrong_reports_conut) + "/" + str(max_wrong_reports_count)
	
	
	
	
	$"map above/cams/cam1/cam".text = tr("cam1")
	$"map above/cams/cam2/cam".text = tr("cam2")
	$"map above/cams/cam3/cam".text = tr("cam3")
	$"map above/cams/cam4/cam".text = tr("cam4")
	
	#$CanvasLayer/gui/subtitles.text = tr("test")
	
	$CanvasLayer/phone/ringing/lab1.text = tr("accept")
	$CanvasLayer/phone/ringing/lab2.text = tr("decline")
	$CanvasLayer/phone/accepted/lab2.text = tr("decline")
	$CanvasLayer/phone/caller.text = tr("manager")
	$CanvasLayer/phone/ringing/label.text = tr("calling")
	
	$CanvasLayer/gui/press_e.text = tr("press_e")
	
	$"map behind/room/tasks/day1/task1/text".text = tr("day1task1") + " (" + str(discovered1+discovered2+discovered3+discovered4) + "/4)"
	$"map behind/room/tasks/day1/task2/text".text = tr("day1task2")
	$"map behind/room/tasks/day1/task3/text".text = tr("day1task3")
	
	
	
var pc = 1
var sabotages_fixed = 1

func _ready() -> void:
	#await get_tree().create_timer(1.0, false, false, false).timeout
	#print(p1_anomalies.find($anomalies/anomaly))
	
	
	
	var tween = create_tween()
	tween.tween_property($CanvasLayer/end_screen/black, "modulate:a", 0.0, 1)
	await get_tree().create_timer(1).timeout
	
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		$CanvasLayer/mobile.visible = 1
		pc = 0
	
	$player/Camera2D.position_smoothing_enabled = 1
	$player/Camera2D.rotation_smoothing_enabled = 1
	
	translation()
	tasks()
	newspaper_translation()
	phone_up()
	developer()
	day_starters()
	
	#subtitle(10, 1.0)
	#newspaper_pages_refresh()
	#day6_tech_steal()
	#day1_end()
	#get_tree().paused = 1
	#day6_battery_inspect()
	#await get_tree().create_timer(3, false, false, false).timeout
	#day6_battery_inspect()
	#vamp_kill()
	#crawl_effect()
	#await get_tree().create_timer(100, false, false, false).timeout
	#antenna_sabo()
	#generator_sabo()
	#cam_sabo(2)
	#cam_sabo(1)
	#cam_sabo(4)
	
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
	
	if shift_time == 142:
		if randi_range(0,100) == 50:
			timeshifter_spawn()
	if shift_time == 180:
		vamp_spawn()
	match shift:
		1: day1_time()
		2: day2_time()
		3: day3_time()
		4: day4_time()
		5: day5_time()
		6: day6_time()
		7: day7_time()
		


func day_starters():
	match shift:
		2: day2_starters()
		6: day6_starters()

func _on_cams_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and computer_area && generator_working:
		open_cam()
		
func _on_radio_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and radio_area && antenna_working:
		open_radio()

func _on_news_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and news_area:
		open_news()

func _on_switch_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and switch_area && generator_working:
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
	if force_cam_close: return
	if day4_crawl:
		day4_crawl = 0
		crawl_effect()
	
	hide_decisions()
	
	#print("hi")
	$"map above/cams_".visible = 0
	#$"map above/cams/cam1".visible = 1
	$player/Camera2D.enabled = 0
	$"map above/cams".visible = 1
	$"map above/cams".get_child(opened_cam-1).enabled = 1
	$CanvasLayer/camera.visible = 1
	computer_opened = 1
	$CanvasLayer/phone.visible = 0
	play_sound(cam_on)
	$sfx/camera.play()
	walking_sound.stop()
	$CanvasLayer/gui/press_e.visible = 0
	
	if !day1task2 && day1call1_done:
		day1task2_apply()


	stop_move()


func close_cam():
	if !day1task2 && day1call1_done:
		return
	if force_camera:
		$CanvasLayer/camera.visible = 0
		return
	
	if day1task2 || !day1call1_done:
		$"map above/cams".get_child(opened_cam-1).visible = 0
		$"map above/cams".get_child(opened_cam-1).enabled = 0
		opened_cam = 1
		$"map above/cams".get_child(opened_cam-1).visible = 1
		$"map above/cams".get_child(opened_cam-1).enabled = 1
	
	$CanvasLayer/camera.visible = 0
	$"map above/cams_".visible = 1
	play_sound(cam_off)
	$sfx/camera.stop()
	$player/Camera2D.enabled = 1
	$"map above/cams".visible = 0
	$CanvasLayer/phone.visible = 1
	
	print("closed")
	#$"map above/cams/cam3".enabled = 0
	$"map above/cams".get_child(opened_cam-1).enabled = 0
	
	
	computer_opened = 0
	allow_move()
	await get_tree().create_timer(0.2, false, false, false).timeout
	allow_move()
	if day1call1_done:
		day1task2 = 1


func open_radio():
	if force_radio_close: return
	
	$CanvasLayer/room/menu.visible = 1
	radio_opened = 1
	$sfx/radio.play()
	$CanvasLayer/gui/press_e.visible = 0
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
			print(calling)
			print("hereXXX")
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
		4:
			match call_index:
				0: day_call(day4_call1_chat, day4_start)
				1: day_chat(day4_creature1_chat, day4_creature1_talked)
				2: day_chat(day4_creature1_chat_stay, day4_creature1_stay)
				3: day_chat(day4_creature1_chat_leave, day4_creature1_leave)
				4: day_chat(day4_creature1_chat_end, day4_creature1_leave)
				5: day_chat(day4_end_chat, day_end)
		5:
			match call_index:
				0: day_call(day5_call1_chat, day5_start)
				1: day_chat(day5_end_chat, day_end)
		6:
			match call_index:
				0: day_call(day6_call1_chat, day6_start)
				1: day_chat(day6_tech_chat_first, day6_tech_options1)
				2: day_chat(day6_tech_chat_second, day6_tech_options1)
				3: day_chat(day6_tech_chat_second_stolen, day6_tech_first_disallow)
				4: day_chat(day6_end_chat, day_end)
		7:
			match call_index:
				0: day_call(day7_call1_chat, day7_start)
				1: day_chat(day7_end_chat, day_end)

func _process(delta: float) -> void:
	#print(day1task2)
	#print($anomalies/tech.position)

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
	
	
	var shaked = $"."
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		shaked.position = Vector2(
			noise.get_noise_2d(shake_time, 0.0) * shake_intensity,
			noise.get_noise_2d(0.0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		shaked.position = shaked.position.lerp(Vector2.ZERO, 10.5 * delta)
	shaked = $CanvasLayer
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		shaked.offset = Vector2(
			noise.get_noise_2d(shake_time, 0.0) * shake_intensity,
			noise.get_noise_2d(0.0, shake_time) * shake_intensity
		)
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		shaked.offset = shaked.offset.lerp(Vector2.ZERO, 10.5 * delta)
	
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
				
		if news_area && !news_open:
			open_news()
		elif news_area:
			close_news()
	
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
	#print(body)
	if body == $player:
		switch_area = 1
		if generator_working:
			if pc: $CanvasLayer/gui/press_e.visible = 1
			$"map behind/room/switch/outline".visible = 1

func _on_switch_body_exited(body: Node2D) -> void:
	if body == $player:
		switch_area = 0
		$CanvasLayer/gui/press_e.visible = 0
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

func light_off(silent = 0):
	if !light: return
	light = 0
	$lights/room.visible = 0
	$"map behind/room/bg/lamp/off".visible = 1
	$"map behind/room/bg/lamp/on".visible = 0
	if !silent:
		play_sound(click_switch)

var light = 0

func light_on():
	light = 1
	$lights/room.visible = 1
	$"map behind/room/bg/lamp/off".visible = 0
	$"map behind/room/bg/lamp/on".visible = 1
	play_sound(click_switch)
	
	if vamp_in_room:
		vamp_dead()

func ladder_up():
	$player.position = Vector2(-533, -580)
	await get_tree().create_timer(0.1, false, false, false).timeout
	$"map behind/out_left/p2/ladder/outline".visible = 1
func ladder_down():
	$player.position = Vector2(-764.0, -47)
	await get_tree().create_timer(0.1, false, false, false).timeout
	$"map behind/out_left/p2/ladder/outline".visible = 1

func phone_up():
	$CanvasLayer/phone/ringing/accept.disabled = 0
	$CanvasLayer/phone/ringing/decline.disabled = 0
	$CanvasLayer/phone/accepted/decline.disabled = 0
	
	$CanvasLayer/phone/ringing.visible = 1
	$CanvasLayer/phone/accepted.visible = 0
	var tween = create_tween()
	$sfx/ringtone.play()
	tween.tween_property($CanvasLayer/phone, "position:y", $CanvasLayer/phone.position.y + 320 , 0.8)
func phone_down():
	$CanvasLayer/phone/ringing/accept.disabled = 1
	$CanvasLayer/phone/ringing/decline.disabled = 1
	$CanvasLayer/phone/accepted/decline.disabled = 1
	var tween = create_tween()
	tween.tween_property($CanvasLayer/phone, "position:y", $CanvasLayer/phone.position.y - 320 , 0.4)
	$sfx/dia.stop()
	$CanvasLayer/gui/subtitles.text = ""

var calling = 0
var call_index = 0


func _on_accept_call_pressed() -> void:
	$sfx/ringtone.stop()
	call_time = 0
	play_sound(click_phone)
	calling = 1
	$CanvasLayer/phone/ringing.visible = 0
	$CanvasLayer/phone/accepted.visible = 1
	$timers/call_time.start()
	$timers/skip_msg.start()
	print("call_accepted")
	match_shift()

func _on_decline_call_pressed() -> void:
	$timers/skip_msg.stop()
	play_sound(hang_up)
	#print("hanged")
	$sfx/ringtone.stop()
	$sfx/dia.stop()
	phone_down()
	
	calling = 0
	print("shift",shift)
	print("call_index",call_index)
	
	match shift:
		1:
			match call_index:
				0: day1_start()
				1: day_end()
		2:
			match call_index:
				0: day2_start()
				1: 
					print("hereX")
					day_end()
		3:
			match call_index:
				0: day3_start()
				5: day_end()
		4:
			match call_index:
				0: day4_start()
				5: day_end()
		5:
			match call_index:
				0: day5_start()
				1: day_end()
		6:
			match call_index:
				0: day6_start()
				4: day_end()
		7:
			match call_index:
				0: day7_start()
				1: day_end()
		
		
	call_index += 1

var call_time = 0

func _on_call_time_timeout() -> void:
	call_time += 1
	var minutes = call_time/60
	var seconds = call_time - (minutes*60) 
	$CanvasLayer/phone/accepted/time.text = "0"
	$CanvasLayer/phone/accepted/time.text += str(minutes)
	$CanvasLayer/phone/accepted/time.text += ":"
	if seconds < 10:
		$CanvasLayer/phone/accepted/time.text += "0"
	$CanvasLayer/phone/accepted/time.text += str(seconds)

var chat_msg = 0

func _on_skip_msg_timeout() -> void:
	chat_msg += 1
	#print("im still workingD")
	print("timer_skip")
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
			$CanvasLayer/gui/press_e.visible = 1
		if generator_working:
			$"map behind/room/desk/outline".visible = 1
			
		if $anomalies/anomaly2.visible && cam_sabo_creature_exist:
			show_decision_option("choose", "kick", "cancel")
		
		if vamp_in_room && !light:
			vamp_kill()

	if body is CharacterBody2D && body.anomaly:
		#body.queue_free()
		print("bruh")
func _on_cams_body_exited(body: Node2D) -> void:
	if body == $player:
		if $anomalies/anomaly2.visible && cam_sabo_creature_exist:
			hide_decisions()
		
		computer_area = 0
		$CanvasLayer/gui/press_e.visible = 0
		$"map behind/room/desk/hover".visible = 0
		$"map behind/room/desk/outline".visible = 0
		
		

func _on_radio_body_entered(body: Node2D) -> void:
	if body == $player:
		radio_area = 1
		#print("radio_area")
		print(radio_area)
		if antenna_working:
			if pc: $CanvasLayer/gui/press_e.visible = 1
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
		#print("radio_area_leftd")
		$CanvasLayer/gui/press_e.visible = 0


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
		
	#print("evented")
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
	#print (anomaly_events[temp2])
	anomaly_events_prob.clear()
	
	anomaly_events[temp2]["exist"] = 1
	
	if cam_helper_creature_exist:
		cam_helper_creature(anomaly_events[temp2]["area"])
	if cam_sabo_creature_exist:
		cam_sabo_creature(anomaly_events[temp2]["area"])
	
	
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
	
	await get_tree().create_timer(2.0, false, false, false).timeout
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
	
	await get_tree().create_timer(1.0, false, false, false).timeout
	subtitle("", 0)
	


var wrong_report = 1
var wrong_reports_conut = 0
var max_wrong_reports_count = 3
var right_reports_conut = 0

func wrong_report_penalty():
	play_sound(wrong_signal)
	print("bad boy")
	wrong_reports_conut += 1
	$CanvasLayer/gui/reports.text = tr("wrong_reports") + " " + str(wrong_reports_conut) + "/" + str(max_wrong_reports_count)
	
	
	if wrong_reports_conut == max_wrong_reports_count:
		print("You Lose")
		lose()

func lose():
	$timers/spawn.stop()
	$timers/bad_time.stop()
	$CanvasLayer/overscreen/black.visible = 1
	$CanvasLayer/end_stats/label.visible = 1
	$CanvasLayer/end_stats/label.text = tr("lose")
	await get_tree().create_timer(3.0, false, false, false).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func win():
	$timers/spawn.stop()
	$timers/bad_time.stop()
	$CanvasLayer/overscreen/black.visible = 1
	$CanvasLayer/end_stats/label.text = tr("win")

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
	$CanvasLayer/gui/danger.text = tr("danger") + " " + str(bad_time) + "/" + str(max_bad_time)

	if bad_time > max_bad_time:
		lose()

var ps1 = 0
var ps2 = 0
var ps3 = 0
var ps4 = 0

func _on_ps_1_body_entered(body: Node2D) -> void:
	if body == $player:
		ps1 = 1
		
		if vamp_move:
			light_off(1)
			vamp_move_to_room()
			
			
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
		if $anomalies/vamp.visible:
			print("vamp area")
			if shift == 5 || shift == 7: vamp_kill()
			else: vamp_despawn()
			
func _on_ps_4_body_exited(body: Node2D) -> void:
	if body == $player:
		ps4 = 0


func _on_shift_time_timeout() -> void:
	shift_time += 1
	var mins = shift_time/60
	var secs = shift_time - mins*60
	$CanvasLayer/gui/time.text = ""
	if mins < 10:
		$CanvasLayer/gui/time.text += "0"
	$CanvasLayer/gui/time.text += str(mins) + ":"
	if secs < 10:
		$CanvasLayer/gui/time.text += "0"
	$CanvasLayer/gui/time.text += str(secs)
	
	shift_time_manager()
	if shift_time == 360:
		shift_end()

var player_in_room = 0
func _on_room_body_entered(body: Node2D) -> void:
	if body == $player:
		player_in_room = 1
		$sfx/night.volume_db -= 5
		walking_sound = $sfx/walk_wood
		$sfx/walk_dirt.stop()
		$sfx/walk_wood.play()
		#print("lowerd")
func _on_room_body_exited(body: Node2D) -> void:
	if body == $player:
		player_in_room = 0
		
		$sfx/night.volume_db += 5
		walking_sound = $sfx/walk_dirt
		$sfx/walk_dirt.play()
		$sfx/walk_wood.stop()
		if vamp_move == 1 || vamp_move == 2:
			light_off()
			vamp_move += 1

func subtitle(sub, time, sayer = "System"):
	$CanvasLayer/gui/subtitles.visible_ratio = 0
	$CanvasLayer/gui/subtitles.text = tr(sub)
	var tween = create_tween()
	$sfx/sub.play()
	tween.tween_property($CanvasLayer/gui/subtitles, "visible_ratio", 1.0, time)
	await get_tree().create_timer(time, false, false, false).timeout
	if sub != "":
		brief.insert(0, [tr(sayer), tr(sub)])
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
	
	$CanvasLayer/gui/danger.visible = 1
	$CanvasLayer/gui/reports.visible = 1
	
	$CanvasLayer/gui/shift.visible = 1
	$CanvasLayer/gui/time.visible = 1
	
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
	await get_tree().create_timer(3.0, false, false, false).timeout
	subtitle("", 0)

func generator_steal_apply():
	generator_working = 0
	generator_stolen = 1
	$anomalies/robber.visible = 0
	$anomalies/tech.visible = 0
	cam_sabo(1)
	cam_sabo(2)
	cam_sabo(3)
	cam_sabo(4)
	if computer_opened: close_cam()
	$"map behind/room/desk/VideoStreamPlayer".visible = 0
	$areas/generator/CollisionShape2D.set_deferred("disabled", 1)
	await get_tree().create_timer(0.2, false, false, false).timeout
	$"map behind/generator".queue_free()
	light_off()
	subtitle("generatostolen", 1.0)
	await get_tree().create_timer(3.0, false, false, false).timeout
	subtitle("", 0)
	await get_tree().create_timer(60, false, false, false).timeout
	frank_spawn()


func generator_on():
	if force_generator_nofix:
		subtitle("requiretech", 1.0)
		return
	print("gen on")
	$"map behind/generator/ProgressBar".visible = 1
	$"map behind/generator/E".visible = 1
	generator_dec_apply = 1
	generator_dec()
	generator_fixing = 1
	#$"map behind/generator/ProgressBar".value -= 5


	
	#await get_tree().create_timer(5.0, false, false, false).timeout
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
		await get_tree().create_timer(0.01, false, false, false).timeout
		$"map behind/generator/ProgressBar".value -= 2
		if $"map behind/generator/ProgressBar".value <= 0:
			generator_failed()

func _on_generator_body_entered(body: Node2D) -> void:
	if body == $player:
		if day2force: return
		if !day3_visitor_safe: 
			day3_visitor_appear()
			print('day3_visitor_appear')
		if !day4_creature1_safe: 
			day4_creature_appear()
			print('day4_visitor_appear')
			
		
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
		$CanvasLayer/gui/press_e.visible = 1
func _on_ladder_body_exited(body: Node2D) -> void:
	if body == $player:
		ladder_area_down = 0
		$"map behind/out_left/p2/ladder/outline".visible = 0
		$"map behind/out_left/p2/ladder/hover".visible = 0
		
		$CanvasLayer/gui/press_e.visible = 0
func _on_ladder_up_entered(body: Node2D) -> void:
	if body == $player:
		ladder_area_up = 1
		$"map behind/out_left/p2/ladder/outline".visible = 1
		$CanvasLayer/gui/press_e.visible = 1
func _on_ladder_up_exited(body: Node2D) -> void:
	if body == $player:
		ladder_area_up = 0
		$"map behind/out_left/p2/ladder/outline".visible = 0
		$"map behind/out_left/p2/ladder/hover".visible = 0
		
		$CanvasLayer/gui/press_e.visible = 0

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
	await get_tree().create_timer(3.0, false, false, false).timeout
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
		await get_tree().create_timer(1.0, false, false, false).timeout
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
		if pc:$CanvasLayer/gui/press_e.visible = 1

func cam_exited(num):
	$"map above/cams_".get_child(num-1).get_child(0).visible = 0
	$"map above/cams_".get_child(num-1).get_child(1).visible = 0
	cam_area[num-1] = 0
	$CanvasLayer/gui/press_e.visible = 0

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
	await get_tree().create_timer(0.02, false, false, false).timeout

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
	

	await get_tree().create_timer(3, false, false, false).timeout
	if cam_fix_pressed < x:
		cam_prog_time = 0
		cam_failed()

func cam_prog():
	while cam_prog_time:
		await get_tree().create_timer(0.01, false, false, false).timeout
		$player/cam_fix/bar.value += 1


func cam_sabo(num):
	subtitle("camsabo", 1.0)
	cam_working[num-1] = 0
	$"map above/cams_".get_child(num-1).get_child(8).visible = 1
	$"map above/cams_".get_child(num-1).get_child(7).visible = 0
	$"map above/cams".get_child(num-1).get_child(0).visible = 1
	
	await get_tree().create_timer(3.0, false, false, false).timeout
	subtitle("", 0)

func cam_fixed():
	cam_prog_time = 0
	cam_working[cam_current-1] = 1
	$CanvasLayer/gui/press_e.visible = 0
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
	#print("loser")

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
	elif temp < 8 && generator_working && !force_generator_nosabo:
		generator_sabo()
	elif antenna_working:
		antenna_sabo()

func _on_option_1_pressed() -> void:
	decision_option(0)
func _on_option_2_pressed() -> void:
	decision_option(1)
func _on_option_3_pressed() -> void:
	decision_option(2)
func _on_option_4_pressed() -> void:
	decision_option(3)
func _on_option_5_pressed() -> void:
	decision_option(4)
func _on_option_6_pressed() -> void:
	decision_option(5)



func show_decision_option(title, o1, o2, o3 = null, o4 = null, o5 = null, o6 = null):
	if radio_opened: close_radio()
	if computer_opened: close_cam()
	force_radio_close = 1
	$CanvasLayer/decision/title.text = title
	$CanvasLayer/decision/o1.text = o1
	$CanvasLayer/decision/o2.text = o2
	$CanvasLayer/decision.visible = 1
	if o3 != null:
		$CanvasLayer/decision/o3.text = o3
		$CanvasLayer/decision/o3.visible = 1
	if o4 != null:
		$CanvasLayer/decision/o4.text = o4
		$CanvasLayer/decision/o4.visible = 1
	if o5 != null:
		$CanvasLayer/decision/o5.text = o5
		$CanvasLayer/decision/o5.visible = 1
	if o6 != null:
		$CanvasLayer/decision/o6.text = o6
		$CanvasLayer/decision/o6.visible = 1
		


func decision_option(option):
	#print(call_index)
	print("call_index", call_index)
	print("shift", shift)
	#print("shift", shift)
	if timeshifter_options:
		timeshifter_apply(option)
		return
	force_radio_close = 0
	match shift:
		3:
			match call_index:
				2:
					match option:
						0: day3_creature1_yes()
						1: day3_creature1_no()
		4:
			match call_index:
				2:
					match option:
						0: day3_creature1_yes()
						1: day3_creature1_no()
				4:
					match option:
						0: day4_creature_kick()
		6:
			match call_index:
				2:
					match option:
						0: day6_tech_first_allow()
						1: day6_tech_first_disallow()
				3:
					match option:
						0: day6_tech_first_allow()
						1: day6_tech_first_disallow()
				4:
					match option:
						0: day6_battery_inspect()
						1: day6_battery_leave()

	hide_decisions()

func hide_decisions():
	$CanvasLayer/decision.visible = 0
	force_radio_close = 0
	force_cam_close = 0

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
	brief.insert(0, [tr(chat[chat_msg][2]), tr(chat[chat_msg][0])])
	#print(tr(chat[chat_msg][2]))
	#print(tr(chat[chat_msg][0]))
	#
	$CanvasLayer/gui/subtitles.visible_ratio = 0
	var temp_sec = randi_range(0, 17)
	$sfx/dia.play(temp_sec)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/gui/subtitles, "visible_ratio", 1.0, chat[chat_msg][1])
	
	#if Input.is_action_just_pressed("skip"):
		#tween.kill()
		#$CanvasLayer/gui/subtitles.visible_ratio = 0
		#print('kileed')
		

	if "%s" in temp:
		$CanvasLayer/gui/subtitles.text = temp % player_name
	else:
		$CanvasLayer/gui/subtitles.text = temp

	await get_tree().create_timer(chat[chat_msg][1], false, false, false).timeout
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
	brief.insert(0, [tr(chat[chat_msg][2]), tr(chat[chat_msg][0])])
	$CanvasLayer/gui/subtitles.visible_ratio = 0
	var temp_sec = randi_range(0, 17)
	$sfx/dia.play(temp_sec)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/gui/subtitles, "visible_ratio", 1.0, chat[chat_msg][1])

	if "%s" in temp:
		$CanvasLayer/gui/subtitles.text = temp % player_name
	else:
		$CanvasLayer/gui/subtitles.text = temp

	await get_tree().create_timer(chat[chat_msg][1], false, false, false).timeout
	$sfx/dia.stop()

func day_end():
	phone_down()
	stop_move()
	print(call_index)
	if computer_opened: close_cam()
	if radio_opened: close_radio()
	
	$sfx/morning.stop()
	stop_move()
	$CanvasLayer/overscreen/black.visible = 1
	
	await get_tree().create_timer(1.0, false, false, false).timeout
	play_sound(start_sound)
	$CanvasLayer/end_stats/shift2.text = tr("shift") + " " + str(shift)
	
	await get_tree().create_timer(1.5, false, false, false).timeout
	$CanvasLayer/end_stats/t1.text = tr("anomalies_reported")
	$CanvasLayer/end_stats/v1.text = str(right_reports_conut)
	play_sound(punch)
	
	
	await get_tree().create_timer(0.4, false, false, false).timeout
	$CanvasLayer/end_stats/t2.text = tr("anomalies_left")
	$CanvasLayer/end_stats/v2.text = str(anomaly_events_count)
	play_sound(punch)
	
	await get_tree().create_timer(0.4, false, false, false).timeout
	$CanvasLayer/end_stats/t3.text = tr("max_danger")
	$CanvasLayer/end_stats/v3.text = str(bad_time)
	play_sound(punch)
	
	
	#var tween = create_tween()
	#tween.tween_property($CanvasLayer/overscreen/black, "modulate:a", 1.0 , 1.4)
	await get_tree().create_timer(5.0, false, false, false).timeout
	
	
	await supabase.submit_shift_score(
		shift,
		$CanvasLayer/player.text,
		bad_time,
		right_reports_conut,
		sabotages_fixed,
		wrong_reports_conut,
		anomaly_events_count
	)
	
	if shift == 7:
		end_game()
		await supabase.save_progress(player_name, 0)
	else:
		global.shift += 1
		await supabase.save_progress(player_name, shift)
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
	
	
	await get_tree().create_timer(0.5, false, false, false).timeout
	subtitle("day1sub1", 0.5)
	
	await get_tree().create_timer(2.0, false, false, false).timeout
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
	
	await get_tree().create_timer(3.0, false, false, false).timeout
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
		await get_tree().create_timer(2.0, false, false, false).timeout
		
		subtitle("day1sub3", 1.0)
		await get_tree().create_timer(2.0, false, false, false).timeout
		
		shift_start()
		
		await get_tree().create_timer(5.0, false, false, false).timeout
		subtitle("day1sub4", 2.0)
		await get_tree().create_timer(5.0, false, false, false).timeout
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
			await get_tree().create_timer(1.0, false, false, false).timeout
			day1task2_apply()

var chat1_array = [
	["chat1msg1", 2, "manager"],  
	["chat1msg2", 3.5, "manager"], 
	["chat1msg3", 3.5, "manager"], 
	["chat1msg4", 3.5, "manager"], 
	["chat1msg5", 4.5, "manager"], 
	["chat1msg6", 3.5, "manager"], 
	["chat1msg7", 1.5, "manager"], 
	["chat1msg8", 1.5, "manager"], 
	["chat1msg9", 0.5, "manager"], 
]

var day1_call2_chat = [
	["chat2msg2", 1, "manager"],
	["chat2msg3", 1, "manager"],
	["chat2msg1", 1, "manager"],
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
	force_radio_close = 0
	call_time = 0
	calling = 1
	$timers/skip_msg.start()
	print("new chat started")
	match_shift()

var day2_call1_chat = [
	["day2call1sen1", 1.0, "manager"],
	["day2call1sen2", 2.0, "manager"],
	["day2call1sen3", 2.5, "manager"],
	["day2call1sen4", 2.0, "manager"],
	["day2call1sen5", 0.5, "manager"],
	
]
#
#func day2_call1():
	#phone_up()

var day2_call2_chat = [
	["day2call2sen1", 1.5, "manager"],
	["day2call2sen2", 1.0, "manager"],
	
	
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
	#await get_tree().create_timer(1.0, false, false, false).timeout
	
	sabo_time()
	await get_tree().create_timer(3.0, false, false, false).timeout
	subtitle("", 0)

var day2creature1_appeared = 0

func day2_creature1():
	if ps1 || (computer_opened && opened_cam == 1): 
		await get_tree().create_timer(1.0, false, false, false).timeout
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
	["day3call1sen1", 1.0, "manager"],
	["day3call1sen2", 1.0, "manager"],
	["day3call1sen3", 1.0, "manager"],
	["day3call1sen4", 1.0, "manager"],
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
	
	await get_tree().create_timer(60, false, false, false).timeout
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




var day_creature_area = 0

func _on_day_3_visitorfound_body_entered(body: Node2D) -> void:
	if body == $player:
		day_creature_area = 1
		match shift:
			3:
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
					await get_tree().create_timer(1.0, false, false, false).timeout
					$player.position.x = 300
					$player/Camera2D.enabled = 1
					$player/Camera2D2.enabled = 0
					start_chat()
			4:
				if $anomalies/anomaly2.visible && !cam_sabo_creature_exist:
					stop_move()
					$timers/bad_time.paused = 1
					await get_tree().create_timer(1.0, false, false, false).timeout
					$player.position.x = 300
					start_chat()
					



func _on_day_3_visitorfound_body_exited(body: Node2D) -> void:
	if body == $player:
		day_creature_area = 0


var day3_creature1_chat = [
	["d3c1s1", 0.5, "stranger"],
	["d3c1s2", 1.0, "stranger"],
	["d3c1s3", 1.5, "stranger"],
]

func day3_creature1_talked():
	#allow_move()
	#call_index += 1
	print("call index" + str(call_index))
	#await get_tree().create_timer(1.0, false, false, false).timeout
	show_decision_option("Answer", "youcanstay", "nosorry.")
	#subtitle("", 0)

# Creature 1 -> Day2 -> appear once and disappear
# Creature 1 -> Day3 -> appear in security room -> asks for stay
## yes -> it stays -> it watches cameras
## no -> it goes -> he simply goes

var day3_creature1_chat_stay = [
	["d3c1s5", 1.0, "stranger"],
	["d3c1s6", 1.0, "stranger"],
]

var day3_creature1_chat_leave = [
	["d3c1s4", 0.5, "stranger"],
]

func day3_creature1_yes():
	
	print("call", call_index)
	start_chat()
func day3_creature1_no():
	call_index += 1
	start_chat()

var cam_helper_creature_exist = 0

func day3_creature1_stay():
	print("day3_creature1_stay")
	
	global.day3creature_stayed = 1
	allow_move()
	call_index += 1
	$timers/bad_time.paused = 0
	cam_helper_creature_exist = 1
	
	#$areas/day3visitorfound/CollisionShape2D.set_deferred("disabled", 1)
	day3_creature1_end_()
	await get_tree().create_timer(4.0, false, false, false).timeout
	sabo_time()
	subtitle("", 0)

var day3_creature1_chat_end = [
	["d3c1s7", 1, "stranger"],
	["d3c1s8", 1, "stranger"],
]

var day3_creature1_shift = 0

func day3_creature1_end_():
	print("leave soonss")
	await get_tree().create_timer(90, false, false, false).timeout
	#call_index += 1
	sabo_time()
	cam_helper_creature_exist = 0
	day3_creature1_shift = 1
	subtitle("leaving", 1)
	if day_creature_area:
		day_creature_area = 0
		stop_move()
		start_chat()

func day3_creature1_leave():
	print("no sorry")
	
	$anomalies/anomaly2.speed = 200
	$anomalies/anomaly2.destination = Vector2(-706.0, $anomalies/anomaly2.global_position.y)
	
	$anomalies/anomaly2.move = 1
	
	await get_tree().create_timer(4.0, false, false, false).timeout
	$anomalies/anomaly2.visible = 0
	allow_move()
	$timers/bad_time.paused = 0
	subtitle("", 0)

func cam_helper_creature(area):
	await get_tree().create_timer(5, false, false, false).timeout
	subtitle("area", 1.0)
	await get_tree().create_timer(1, false, false, false).timeout
	$CanvasLayer/gui/subtitles.text += str(area)
	brief[0][1] += str(area)
	await get_tree().create_timer(2.9, false, false, false).timeout
	subtitle("", 0)

var day3_call2_chat = [
	["day3call2sen1", 1, "stranger"],
]

var day4_call1_chat = [
	["", 1, "manager"],
	["", 1, "manager"],
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

func day4_start():
	print("day 4")
	shift_start()
	day4_visitor()
	#sabo_time()

var day4_creature1_safe = 1
var cam_sabo_creature_exist = 0

func day4_visitor():
	await get_tree().create_timer(3, false, false, false).timeout
	generator_sabo()
	if generator_area:
		day4_creature_appear()

func day4_creature_appear():
	$anomalies/anomaly2.visible = 1

var day4_creature1_chat = [
	["hello", 0.5, "stranger"],
	["needhelp", 1.0, "stranger"],
]

func day4_creature1_talked():
	show_decision_option("Answer", "yesplease", "no")

var day4_creature1_chat_stay = [
	["stay", 1.0, "stranger"],
]

var day4_creature1_chat_leave = [
	["np", 0.5, "stranger"],
]

func day4_creature1_yes():
	print("day4_creature1_yes")
	start_chat()
func day4_creature1_no():
	print("day4_creature1_no")
	call_index += 1
	start_chat()

func day4_creature1_stay():
	global.day4creature_stayed = 1
	force_radio_close = 0
	print("day4_creature1_stay")
	allow_move()
	call_index += 1
	$timers/bad_time.paused = 0
	cam_sabo_creature_exist = 1
	day4_creature1_end_()
	await get_tree().create_timer(4.0, false, false, false).timeout
	sabo_time()
	subtitle("", 0)

var day4_creature1_chat_end = [
	["im leave", 0, "stranger"],
]

var day4_creature1_shift = 0

func day4_creature1_end_():
	print("leave soon")
	await get_tree().create_timer(90, false, false, false).timeout
	sabo_time()
	cam_helper_creature_exist = 0
	day3_creature1_shift = 1
	subtitle("leaving", 1)
	if day_creature_area:
		day_creature_area = 0
		stop_move()
		start_chat()

func day4_creature1_leave():
	print("no sorry")
	force_radio_close = 0
	$anomalies/anomaly2.speed = 200
	$anomalies/anomaly2.destination = Vector2(-706.0, $anomalies/anomaly2.global_position.y)
	$anomalies/anomaly2.move = 1
	await get_tree().create_timer(4.0, false, false, false).timeout
	$anomalies/anomaly2.visible = 0
	allow_move()
	$timers/bad_time.paused = 0
	subtitle("", 0)

func cam_sabo_creature(area):
	await get_tree().create_timer(10, false, false, false).timeout
	if generator_working:
		subtitle("sector", 1.0)
		await get_tree().create_timer(1, false, false, false).timeout
		area += 1
		if area == 5: area = 1
		$CanvasLayer/gui/subtitles.text += str(area)
		brief[0][1] += str(area)
		await get_tree().create_timer(2.9, false, false, false).timeout
		subtitle("", 0)

var day4_call2_chat = [
	["day4call2sen1", 1, "manager"],
	["day4call2sen2", 1, "manager"],
]

var day4_crawl = 0

func day4_creature_kick():
		$CanvasLayer/decision.visible = 0
		cam_sabo_creature_exist = 0
		stop_move()
		start_chat()
		force_cam_close = 1
		day4_crawl = 1
		await get_tree().create_timer(4.1, false, false, false).timeout
		force_cam_close = 0 

var day4_end_chat = [
	["day4c1", 1.0, "manager"],
	["day4c2", 1.0], "manager",
]


#### ANOTHER GAME
### Shift 5
### Visitors Day
# Creature 1 -> asks to visit someone who doesn't exist
# Creature 2 -> asks to visit someone who exists -> write player's name instead of it -> chases player
# Normal creatures -> visit and leave
# Creature 3 -> visitor turns off light and goes on, player turn light again, visitor can't pass back, so it just stand
# Creature 4 -> visitor goes in and disappears
# Creature 5 -> goes for wrong grave
# Creature 6 ->  

### Another events
# someone asks for help ->
## 1: helped -> help you later
## 2: not helped -> nothing
# gang sabotaging cameras -> hide ->
## 1: they steal screen
## 2: someone you helped before helps you


func day5_time():
	if shift_time == 1:
		print("im here")
	elif shift_time == 60:
		set_shift_values(15, 20)
	elif shift_time == 150:
		set_shift_values(12, 16)
	elif shift_time == 240:
		set_shift_values(8, 14)
	

func day5_start():
	shift_start()
	sabo_time()

var day5_call1_chat = [
	["a", 1.0, "manager"],
]

var day5_end_chat = [
	["a", 1.0, "manager"]
]

var vamp_move = 0

func vamp_spawn():
	if (computer_opened && opened_cam == 4) || ps4:
		print("vamp spawne failed")
		await get_tree().create_timer(3, false, false, false).timeout
		vamp_spawn()
	else:
		print("vamp spawned")
		play_sound(vamp_laugh)
		$anomalies/vamp.visible = 1
		if shift == 5 || shift == 7:
			await get_tree().create_timer(1.2, false, false, false).timeout
			if ps1:
				light_off(1)
				vamp_move_to_room()
			else:
				cam_sabo(1)
				vamp_move = 1

func vamp_kill():
	print("killed")
	vamp_move = 0
	vamp_in_room = 0
	play_sound(bats)
	
	$sfx/night.stop()
	#$sfx/.stop()
	
	$CanvasLayer/image.visible = 1
	$CanvasLayer/image.texture = vamp1
	play_sound(hiss)
	await get_tree().create_timer(0.3, false, false, false).timeout
	$CanvasLayer/image.texture = null
	await get_tree().create_timer(0.1, false, false, false).timeout
	$CanvasLayer/image.texture = vamp2
	play_sound(hiss)
	await get_tree().create_timer(0.3, false, false, false).timeout
	$CanvasLayer/image.texture = null
	await get_tree().create_timer(0.1, false, false, false).timeout
	$CanvasLayer/image.texture = vamp3
	play_sound(hiss)
	await get_tree().create_timer(0.3, false, false, false).timeout
	$CanvasLayer/overscreen/black.visible = 1
	$CanvasLayer/image.texture = null
	play_sound(bite)
	
	lose()
	
	
	#lose()

func vamp_dead():
	print("vamp dead")
	vamp_move = 0
	vamp_in_room = 0

func vamp_despawn():
	$anomalies/vamp.visible = 0

var vamp_in_room = 0

func vamp_move_to_room():
	print("vamp in room")
	$anomalies/vamp.visible = 0
	vamp_in_room = 1


func day6_start():
	shift_start()
	#sabo_time()

func day6_time():
	if shift_time == 1:
		print("im here")
	elif shift_time == 30: #edit
		var temp = randi_range(0,1)
		if temp: day6_tech = "bad"
		else: day6_tech = "good"
		print(day6_tech)
		day6_tech_appear()
	elif shift_time == 60:
		set_shift_values(15, 20)
	elif shift_time == 150:
		set_shift_values(12, 16)
	elif shift_time == 240:
		set_shift_values(8, 14)

var day6_call1_chat = [
	["day6start", 1.0, "manager"],
]

### Day6
## -> generator tech, 
# if yes -> it steals generator -> spawn franky
# if no -> sabotage all cameras

func day6_tech_appear():
	$anomalies/tech.position = Vector2(-3692.0, -26)
	$anomalies/tech.visible = 1
	$anomalies/tech.speed = 200
	$anomalies/tech.destination = Vector2(-502.0, -26)
	$anomalies/tech.move = 1
	day6_tech_meet()

func day6_tech_meet():
	if $anomalies/tech.position.x > -510 && $anomalies/tech.position.x < -495:
		print("canmet")
		$areas/tech/CollisionShape2D.set_deferred("disabled", 0)
	else:
		await get_tree().create_timer(1.0, false, false, false).timeout
		day6_tech_meet()

var day6_tech = "bad"
var attempt = 1

func _on_tech_body_entered(body: Node2D) -> void:
	if body == $player:
		$areas/tech/CollisionShape2D.set_deferred("disabled", 1)
		stop_move()
		if attempt == 2 && generator_stolen:
			print("stolen")
			call_index += 1
		await get_tree().create_timer(1.0, false, false, false).timeout
		start_chat()

var day6_tech_chat_first = [
	["tech1", 1.0, "tech"],
]

func day6_starters():
	generator_sabo()
	force_generator_nofix = 1
	$"map behind/generator/off".visible = 0
	$"map behind/generator/shut".visible = 1
	
	subtitle("generatorshut", 1.0)
	

func day6_tech_options1():
	show_decision_option("Choose", "goon", "no")

func day6_tech_first_allow():
	#$anomalies/tech.visible = 1
	allow_move()
	$anomalies/tech.speed = 300
	$anomalies/tech.destination = Vector2(2743.0, -26)
	$anomalies/tech.move = 1
	await get_tree().create_timer(15, false, false, false).timeout #edit
	day6_check_space()

func day6_check_space():
	if ps4:
		await get_tree().create_timer(10, false, false, false).timeout
		day6_check_space()
	else:
		if day6_tech == "bad" :
			generator_steal_apply()
		else:
			generator_tech_fix()


func generator_tech_fix():
	generator_fixed()
	force_generator_nofix = 0
	force_generator_nosabo = 1
	sabo_time()
	$anomalies/tech.visible = 1
	$anomalies/tech.speed = 300
	$anomalies/tech.destination = Vector2(-3692.0, -26)
	$anomalies/tech.move = 1
	day6_next_tech()

func day6_next_tech():
	if attempt == 2: return
	if day6_tech == "good": day6_tech = "bad"
	else: day6_tech = "good"
	
	attempt += 1
	await get_tree().create_timer(20, false, false, false).timeout #edit
	day6_tech_appear()

func day6_tech_first_disallow():
	allow_move()
	if attempt == 1:
		day6_next_tech()
	$anomalies/tech.visible = 1
	$anomalies/tech.speed = 300
	$anomalies/tech.destination = Vector2(-3692.0, -26)
	$anomalies/tech.move = 1

var day6_tech_chat_second = [
	["im the good one", 1.0, "tech"],
]
var day6_tech_chat_second_stolen = [
	["he stole it", 1.0, "tech"],
]

### scenarios
# good come -> allowed -> bad come -> allowed/disallowed
# good come -> disallowed -> bad come -> allowed/disallowed
# bad come -> allowed -> good come -> chat
# bad come -> disallowed -> good come -> allowed/disallowed

func frank_spawn():
	if ps4 || (computer_opened && opened_cam == 4):
		await get_tree().create_timer(3.0, false, false, false).timeout
		frank_spawn()
	else:
		#generator_sabo()
		antenna_sabo()
		subtitle("RUN", 0.2)
		$CanvasLayer/overscreen/red.visible = 1
		#await get_tree().create_timer(5, false, false, false).timeout
		$anomalies/frank.visible = 1
		frank_sounds_on = 1
		frank_sounds()
		$anomalies/frank.player = $player
		$anomalies/frank.speed = 150
		$anomalies/frank.move = 1
		
		await get_tree().create_timer(30, false, false, false).timeout
		subtitle("Stay away.", 0.5)
		
		frank_sounds_on = 0
		$CanvasLayer/overscreen/red.visible = 0
		$anomalies/frank.speed = 700
		$anomalies/frank.target_player = 0
		$anomalies/frank.destination = Vector2(-3676.0, -26)
		$areas/frank_battery/CollisionShape2D.set_deferred("disabled", 0)
		$"map behind/out_left/p2/frank".visible = 1
		
		await get_tree().create_timer(2, false, false, false).timeout 
		subtitle("", 0)
		if shift == 6:
			day6_next_tech()
		play_sound(frank_scream)

var frank_sounds_on = 0

func frank_sounds():
	while frank_sounds_on:
		play_sound(frank_scream)
		screen_shake(30, 3)
		await get_tree().create_timer(1, false, false, false).timeout
		screen_shake(30, 3)
		play_sound(electricity)
		await get_tree().create_timer(1, false, false, false).timeout
		screen_shake(30, 9)
		play_sound(electricity)
		await get_tree().create_timer(3, false, false, false).timeout

var temp_call_index = 1

func _on_frank_battery_body_entered(body: Node2D) -> void:
	if body == $player:
		temp_call_index = call_index
		call_index = 4
		show_decision_option("CHOOSE", "Inspect", "Leave")
		
		$"map behind/out_left/p2/frank/outline".visible = 1

func _on_frank_battery_body_exited(body: Node2D) -> void:
	if body == $player:
		call_index = temp_call_index
		hide_decisions()
		$"map behind/out_left/p2/frank/outline".visible = 0

func day6_battery_inspect():
	print("battery yes")
	stop_move()
	hide_decisions()
	play_sound(psst)
	await get_tree().create_timer(1.0, false, false, false).timeout
	play_sound(door)
	$"map behind/out_left/p2/cabin/open".visible = 1
	$"map behind/out_left/p2/cabin/eye3".visible = 1
	$"map behind/out_left/p2/cabin/eye4".visible = 1
	$sfx/night.stop()
	
	await get_tree().create_timer(1.0, false, false, false).timeout
	var tween = create_tween()
	tween.tween_property($player/Camera2D, "zoom", Vector2(3.5, 3.5), 3)
	await get_tree().create_timer(2.5, false, false, false).timeout
	play_sound(electricity)
	$"map behind/out_left/p2/cabin/eye1".visible = 1
	$"map behind/out_left/p2/cabin/eye2".visible = 1
	await get_tree().create_timer(0.5, false, false, false).timeout
	#$CanvasLayer/image.visible = 1
	#$CanvasLayer/image.texture = frank1
	#play_sound(frank_scream)
	#await get_tree().create_timer(0.3, false, false, false).timeout
	#$CanvasLayer/image.texture = null
	#await get_tree().create_timer(0.1, false, false, false).timeout
	#$CanvasLayer/image.texture = frank2
	#play_sound(electricity)
	#await get_tree().create_timer(0.3, false, false, false).timeout
	#$CanvasLayer/image.texture = null
	#await get_tree().create_timer(0.1, false, false, false).timeout
	#$CanvasLayer/image.texture = frank3
	#play_sound(frank_scream)
	#await get_tree().create_timer(0.3, false, false, false).timeout
	#$CanvasLayer/image.texture = null
	#sprite
	#$player/Camera2D.zoom = Vector2(1.4, 1.4)
	#await get_tree().create_timer(2, false, false, false).timeout
	
	await get_tree().create_timer(2.3, false, false, false).timeout
	screen_shake(35, 5)
	$CanvasLayer/overscreen/black.visible = 1
	$CanvasLayer/js.visible = 1
	play_sound(fnaf, 10)
	await get_tree().create_timer(0.5, false, false, false).timeout
	play_sound(fnaf, 10)
	await get_tree().create_timer(0.5, false, false, false).timeout
	play_sound(fnaf, 10)
	await get_tree().create_timer(2, false, false, false).timeout
	$CanvasLayer/js.visible = 0
	lose()

func day6_battery_leave():
	$"map behind/out_left/p2/frank/outline".visible = 0
	print("battery no")
	call_index = temp_call_index
	hide_decisions()

var day6_end_chat = [
	["day6end", 1.0, "manager"],
]


func _on_left_pressed() -> void:
	Input.action_press("left")
	Input.action_release("left")
func _on_right_pressed() -> void:
	Input.action_press("right")
	Input.action_release("right")

func _on_news_body_entered(body: Node2D) -> void:
	if body == $player:
		$"map behind/room/news/outline". visible = 1
		if pc: $CanvasLayer/gui/press_e.visible = 1
		news_area = 1
func _on_news_body_exited(body: Node2D) -> void:
	if body == $player:
		close_news()
		$"map behind/room/news/hover".visible = 0
		$"map behind/room/news/outline". visible = 0
		$CanvasLayer/gui/press_e.visible = 0
		
		news_area = 0

func _on_news_mouse_entered() -> void:
	if news_area:
		$"map behind/room/news/hover".visible = 1
		$"map behind/room/news/outline". visible = 0
		
func _on_news_mouse_exited() -> void:
	if news_area:
		$"map behind/room/news/hover".visible = 0
		$"map behind/room/news/outline". visible = 1

func open_news():
	news_open = 1
	$CanvasLayer/news.visible = 1

func close_news():
	news_open = 0
	$CanvasLayer/news.visible = 0

var news_open = 0
var opened_news_page = 0

func _on_left_news_pressed() -> void:
	$CanvasLayer/news/pages.get_child(opened_news_page).visible = 0
	opened_news_page -= 1
	if opened_news_page < 0:
		opened_news_page = $CanvasLayer/news/pages.get_child_count() - 1
	$CanvasLayer/news/pages.get_child(opened_news_page).visible = 1
	play_sound(paper_turn)
func _on_right_news_pressed() -> void:
	$CanvasLayer/news/pages.get_child(opened_news_page).visible = 0
	opened_news_page += 1
	if opened_news_page > $CanvasLayer/news/pages.get_child_count() - 1:
		opened_news_page = 0
	$CanvasLayer/news/pages.get_child(opened_news_page).visible = 1
	play_sound(paper_turn)

	### page1
	#$CanvasLayer/news/pages/page1/topic1/title
	#$CanvasLayer/news/pages/page1/topic1/col1
	#$CanvasLayer/news/pages/page1/topic1/col2
	#$CanvasLayer/news/pages/page1/topic1/col3
	#$CanvasLayer/news/pages/page1/topic1/image.texture = day1_page1[0][4]

func newspaper_translation():
	match shift:
		1: day1_newspaper_translation()
		2: day2_newspaper_translation()
		3: day3_newspaper_translation()
		4: day4_newspaper_translation()
		5: day5_newspaper_translation()
		6: day6_newspaper_translation()
		7: day3_newspaper_translation()
		

func day1_newspaper_translation():
	var page1 = $CanvasLayer/news/pages/page1
	var page2 = $CanvasLayer/news/pages/page2
	var page3 = $CanvasLayer/news/pages/page3
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day1_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day1_page1[topic][part]

	for topic in page2.get_child_count():
		if page2.get_child(topic).name == "control": break
		for part in page2.get_child(topic).get_child_count():
			if page2.get_child(topic).get_child(part) is Label:
				page2.get_child(topic).get_child(part).text = tr(day1_page2[topic][part])
			else:
				page2.get_child(topic).get_child(part).texture = day1_page2[topic][part]

	for topic in page3.get_child_count():
		if page3.get_child(topic).name == "control": break
		for part in page3.get_child(topic).get_child_count():
			if page3.get_child(topic).get_child(part) is Label:
				page3.get_child(topic).get_child(part).text = tr(day1_page3[topic][part])
			else:
				page3.get_child(topic).get_child(part).texture = day1_page3[topic][part]

func day2_newspaper_translation():
	var page1 = $CanvasLayer/news/pages/page1
	var page2 = $CanvasLayer/news/pages/page2
	var page3 = $CanvasLayer/news/pages/page3
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day2_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day2_page1[topic][part]

	for topic in page2.get_child_count():
		if page2.get_child(topic).name == "control": break
		for part in page2.get_child(topic).get_child_count():
			if page2.get_child(topic).get_child(part) is Label:
				page2.get_child(topic).get_child(part).text = tr(day2_page2[topic][part])
			else:
				page2.get_child(topic).get_child(part).texture = day2_page2[topic][part]

	for topic in page3.get_child_count():
		if page3.get_child(topic).name == "control": break
		for part in page3.get_child(topic).get_child_count():
			if page3.get_child(topic).get_child(part) is Label:
				page3.get_child(topic).get_child(part).text = tr(day2_page3[topic][part])
			else:
				page3.get_child(topic).get_child(part).texture = day2_page3[topic][part]

func day3_newspaper_translation():
	var page1 = $CanvasLayer/news/pages/page1
	var page2 = $CanvasLayer/news/pages/page2
	var page3 = $CanvasLayer/news/pages/page3
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day3_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day3_page1[topic][part]

	for topic in page2.get_child_count():
		if page2.get_child(topic).name == "control": break
		for part in page2.get_child(topic).get_child_count():
			if page2.get_child(topic).get_child(part) is Label:
				page2.get_child(topic).get_child(part).text = tr(day3_page2[topic][part])
			else:
				page2.get_child(topic).get_child(part).texture = day3_page2[topic][part]

	for topic in page3.get_child_count():
		if page3.get_child(topic).name == "control": break
		for part in page3.get_child(topic).get_child_count():
			if page3.get_child(topic).get_child(part) is Label:
				page3.get_child(topic).get_child(part).text = tr(day3_page3[topic][part])
			else:
				page3.get_child(topic).get_child(part).texture = day3_page3[topic][part]

func day4_newspaper_translation():
	var page1 = $CanvasLayer/news/pages/page1
	var page2 = $CanvasLayer/news/pages/page2
	var page3 = $CanvasLayer/news/pages/page3
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day4_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day4_page1[topic][part]

	for topic in page2.get_child_count():
		if page2.get_child(topic).name == "control": break
		for part in page2.get_child(topic).get_child_count():
			if page2.get_child(topic).get_child(part) is Label:
				page2.get_child(topic).get_child(part).text = tr(day4_page2[topic][part])
			else:
				page2.get_child(topic).get_child(part).texture = day4_page2[topic][part]

	for topic in page3.get_child_count():
		if page3.get_child(topic).name == "control": break
		for part in page3.get_child(topic).get_child_count():
			if page3.get_child(topic).get_child(part) is Label:
				page3.get_child(topic).get_child(part).text = tr(day4_page3[topic][part])
			else:
				page3.get_child(topic).get_child(part).texture = day4_page3[topic][part]

func day5_newspaper_translation():
	var page1 = $CanvasLayer/news/pages/page1
	var page2 = $CanvasLayer/news/pages/page2
	var page3 = $CanvasLayer/news/pages/page3
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day4_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day4_page1[topic][part]

	for topic in page2.get_child_count():
		if page2.get_child(topic).name == "control": break
		for part in page2.get_child(topic).get_child_count():
			if page2.get_child(topic).get_child(part) is Label:
				page2.get_child(topic).get_child(part).text = tr(day4_page2[topic][part])
			else:
				page2.get_child(topic).get_child(part).texture = day4_page2[topic][part]

	for topic in page3.get_child_count():
		if page3.get_child(topic).name == "control": break
		for part in page3.get_child(topic).get_child_count():
			if page3.get_child(topic).get_child(part) is Label:
				page3.get_child(topic).get_child(part).text = tr(day4_page3[topic][part])
			else:
				page3.get_child(topic).get_child(part).texture = day4_page3[topic][part]

func day6_newspaper_translation():
	var page1 = $CanvasLayer/news/pages/page1
	var page2 = $CanvasLayer/news/pages/page2
	var page3 = $CanvasLayer/news/pages/page3
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day6_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day6_page1[topic][part]

	for topic in page2.get_child_count():
		if page2.get_child(topic).name == "control": break
		for part in page2.get_child(topic).get_child_count():
			if page2.get_child(topic).get_child(part) is Label:
				page2.get_child(topic).get_child(part).text = tr(day6_page2[topic][part])
			else:
				page2.get_child(topic).get_child(part).texture = day6_page2[topic][part]

	for topic in page3.get_child_count():
		if page3.get_child(topic).name == "control": break
		for part in page3.get_child(topic).get_child_count():
			if page3.get_child(topic).get_child(part) is Label:
				page3.get_child(topic).get_child(part).text = tr(day6_page3[topic][part])
			else:
				page3.get_child(topic).get_child(part).texture = day6_page3[topic][part]

func day7_newspaper_translation():
	#var page1 = $CanvasLayer/news/pages/page1
	#var page2 = $CanvasLayer/news/pages/page2
	#var page3 = $CanvasLayer/news/pages/page3
	var page1 = $CanvasLayer/news/pages/page3
	
	
	for topic in page1.get_child_count():
		if page1.get_child(topic).name == "control": break
		for part in page1.get_child(topic).get_child_count():
			if page1.get_child(topic).get_child(part) is Label:
				page1.get_child(topic).get_child(part).text = tr(day7_page1[topic][part])
			else:
				page1.get_child(topic).get_child(part).texture = day7_page1[topic][part]


var day1_page1 = [
	["day1_page1_topic1_title", "day1_page1_topic1_col1", "day1_page1_topic1_col2", "day1_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day1_page1_topic2_title", "day1_page1_topic2_col1", preload("res://assets/newspaper/market.PNG")],
	["day1_page1_topic3_title", "day1_page1_topic3_col1"],
	["day1_page1_topic4_title", "day1_page1_topic4_col1"],
	["day1_page1_topic5_title", "day1_page1_topic5_col1"],
	["day1_page1_topic6_title", "day1_page1_topic6_col1", preload("res://assets/newspaper/weather.PNG")],
]
var day1_page2 = [
	["day1_page2_topic1_title", "day1_page2_topic1_col1", preload("res://assets/newspaper/reunion.PNG")],
	["day1_page2_topic2_title", "day1_page2_topic2_col1", preload("res://assets/newspaper/internt.PNG")],
	["day1_page2_topic3_title", "day1_page2_topic3_col1", preload("res://assets/newspaper/lake.PNG")],
	["day1_page2_topic4_title", "day1_page2_topic4_col1", preload("res://assets/newspaper/secret.PNG")],
	["day1_page2_topic5_title", "day1_page2_topic5_col1", preload("res://assets/newspaper/charity.PNG")],
]
var day1_page3 = [
	["day1_page3_topic1_title", "day1_page3_topic1_col1", preload("res://assets/newspaper/elec.PNG")],
	["day1_page3_topic2_title", "day1_page3_topic2_col1", preload("res://assets/newspaper/prison.PNG")],
	["day1_page3_topic3_title", "day1_page3_topic3_col1", preload("res://assets/newspaper/mystery.PNG")],
	["day1_page3_topic4_title", "day1_page3_topic4_col1", preload("res://assets/newspaper/demo.PNG")],
	["day1_page3_topic5_title", "day1_page3_topic5_col1", preload("res://assets/newspaper/sports.PNG")],
]

var day2_page1 = [
	["day2_page1_topic1_title", "day2_page1_topic1_col1", "day2_page1_topic1_col2", "day2_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day2_page1_topic2_title", "day2_page1_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page1_topic3_title", "day2_page1_topic3_col1"],
	["day2_page1_topic4_title", "day2_page1_topic4_col1"],
	["day2_page1_topic5_title", "day2_page1_topic5_col1"],
	["day2_page1_topic6_title", "day2_page1_topic6_col1", preload("res://assets/newspaper/cons.png")],
]
var day2_page2 = [
	["day2_page2_topic1_title", "day2_page2_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page2_topic2_title", "day2_page2_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page2_topic3_title", "day2_page2_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page2_topic4_title", "day2_page2_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page2_topic5_title", "day2_page2_topic5_col1", preload("res://assets/newspaper/cons.png")],
]
var day2_page3 = [
	["day2_page3_topic1_title", "day2_page3_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page3_topic2_title", "day2_page3_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page3_topic3_title", "day2_page3_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page3_topic4_title", "day2_page3_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day2_page3_topic5_title", "day2_page3_topic5_col1", preload("res://assets/newspaper/cons.png")],
]

var day3_page1 = [
	["day3_page1_topic1_title", "day3_page1_topic1_col1", "day3_page1_topic1_col2", "day3_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day3_page1_topic2_title", "day3_page1_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page1_topic3_title", "day3_page1_topic3_col1"],
	["day3_page1_topic4_title", "day3_page1_topic4_col1"],
	["day3_page1_topic5_title", "day3_page1_topic5_col1"],
	["day3_page1_topic6_title", "day3_page1_topic6_col1", preload("res://assets/newspaper/cons.png")],
]
var day3_page2 = [
	["day3_page2_topic1_title", "day3_page2_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page2_topic2_title", "day3_page2_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page2_topic3_title", "day3_page2_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page2_topic4_title", "day3_page2_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page2_topic5_title", "day3_page2_topic5_col1", preload("res://assets/newspaper/cons.png")],
]
var day3_page3 = [
	["day3_page3_topic1_title", "day3_page3_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page3_topic2_title", "day3_page3_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page3_topic3_title", "day3_page3_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page3_topic4_title", "day3_page3_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day3_page3_topic5_title", "day3_page3_topic5_col1", preload("res://assets/newspaper/cons.png")],
]

var day4_page1 = [
	["day4_page1_topic1_title", "day4_page1_topic1_col1", "day4_page1_topic1_col2", "day4_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day4_page1_topic2_title", "day4_page1_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page1_topic3_title", "day4_page1_topic3_col1"],
	["day4_page1_topic4_title", "day4_page1_topic4_col1"],
	["day4_page1_topic5_title", "day4_page1_topic5_col1"],
	["day4_page1_topic6_title", "day4_page1_topic6_col1", preload("res://assets/newspaper/cons.png")],
]
var day4_page2 = [
	["day4_page2_topic1_title", "day4_page2_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page2_topic2_title", "day4_page2_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page2_topic3_title", "day4_page2_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page2_topic4_title", "day4_page2_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page2_topic5_title", "day4_page2_topic5_col1", preload("res://assets/newspaper/cons.png")],
]
var day4_page3 = [
	["day4_page3_topic1_title", "day4_page3_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page3_topic2_title", "day4_page3_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page3_topic3_title", "day4_page3_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page3_topic4_title", "day4_page3_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day4_page3_topic5_title", "day4_page3_topic5_col1", preload("res://assets/newspaper/cons.png")],
]

var day5_page1 = [
	["day5_page1_topic1_title", "day5_page1_topic1_col1", "day5_page1_topic1_col2", "day5_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day5_page1_topic2_title", "day5_page1_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page1_topic3_title", "day5_page1_topic3_col1"],
	["day5_page1_topic4_title", "day5_page1_topic4_col1"],
	["day5_page1_topic5_title", "day5_page1_topic5_col1"],
	["day5_page1_topic6_title", "day5_page1_topic6_col1", preload("res://assets/newspaper/cons.png")],
]
var day5_page2 = [
	["day5_page2_topic1_title", "day5_page2_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page2_topic2_title", "day5_page2_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page2_topic3_title", "day5_page2_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page2_topic4_title", "day5_page2_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page2_topic5_title", "day5_page2_topic5_col1", preload("res://assets/newspaper/cons.png")],
]
var day5_page3 = [
	["day5_page3_topic1_title", "day5_page3_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page3_topic2_title", "day5_page3_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page3_topic3_title", "day5_page3_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page3_topic4_title", "day5_page3_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day5_page3_topic5_title", "day5_page3_topic5_col1", preload("res://assets/newspaper/cons.png")],
]

var day6_page1 = [
	["day6_page1_topic1_title", "day6_page1_topic1_col1", "day6_page1_topic1_col2", "day6_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day6_page1_topic2_title", "day6_page1_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page1_topic3_title", "day6_page1_topic3_col1"],
	["day6_page1_topic4_title", "day6_page1_topic4_col1"],
	["day6_page1_topic5_title", "day6_page1_topic5_col1"],
	["day6_page1_topic6_title", "day6_page1_topic6_col1", preload("res://assets/newspaper/cons.png")],
]
var day6_page2 = [
	["day6_page2_topic1_title", "day6_page2_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page2_topic2_title", "day6_page2_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page2_topic3_title", "day6_page2_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page2_topic4_title", "day6_page2_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page2_topic5_title", "day6_page2_topic5_col1", preload("res://assets/newspaper/cons.png")],
]
var day6_page3 = [
	["day6_page3_topic1_title", "day6_page3_topic1_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page3_topic2_title", "day6_page3_topic2_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page3_topic3_title", "day6_page3_topic3_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page3_topic4_title", "day6_page3_topic4_col1", preload("res://assets/newspaper/cons.png")],
	["day6_page3_topic5_title", "day6_page3_topic5_col1", preload("res://assets/newspaper/cons.png")],
]

var day7_page1 = [
	["day7_page1_topic1_title", "day7_page1_topic1_col1", "day7_page1_topic1_col2", "day7_page1_topic1_col3", preload("res://assets/newspaper/cons.png")],
	["day7_page1_topic2_title", "day7_page1_topic2_col1"],
	["day7_page1_topic3_title", "day7_page1_topic3_col1"],
	["day7_page1_topic4_title", "day7_page1_topic4_col1"],
	["day7_page1_topic5_title", "day7_page1_topic5_col1"],
	["day7_page1_topic6_title", "day7_page1_topic6_col1"],
]


func _on_pause_pressed() -> void:
	get_tree().paused = 1
	refresh_brief()
	#$CanvasLayer/pause/brief_.visible = 1
	$CanvasLayer/pause.visible = 1

func _on_resume_pressed() -> void:
	get_tree().paused = 0
	$CanvasLayer/pause.visible = 0

var brief = [

]

func refresh_brief():
	for i in $CanvasLayer/pause/brief_/mask/scroll/text.get_children():
		i.queue_free()
	
	for i in range(len(brief)-1):
		var label = Label.new()
		label.text = brief[i][0] + ": " + brief[i][1]
		label.set("theme_override_fonts/font", preload("res://assets/LibreBaskerville-Italic.ttf"))
		label.custom_minimum_size.x = 705.0
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
		$CanvasLayer/pause/brief_/mask/scroll/text.add_child(label)


func _on_restart_pressed() -> void:
	$CanvasLayer/pause/restart_.visible = 1
func _on_restart_yes_pressed() -> void:
	get_tree().paused = 0
	$CanvasLayer/pause.visible = 0
	#await get_tree().create_timer(1.0, false, false, false).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
func _on_restart_no_pressed() -> void:
	$CanvasLayer/pause/restart_.visible = 0

func _on_quit_yes_pressed() -> void:
	get_tree().paused = 0
	$CanvasLayer/pause.visible = 0
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_quit_no_pressed() -> void:
	$CanvasLayer/pause/quit_.visible = 0
func _on_quit_pressed() -> void:
	$CanvasLayer/pause/quit_.visible = 1
func _on_brief_pressed() -> void:
	refresh_brief()
	$CanvasLayer/pause/brief_.visible = !$CanvasLayer/pause/brief_.visible
	$CanvasLayer/pause/settings_.visible = 0
	$CanvasLayer/pause/restart_.visible = 0
	$CanvasLayer/pause/quit_.visible = 0

# Red Moon Night

func day7_time():
	if shift_time == 1:
		#day_generator_steal()
		print("shift", shift)
	elif shift_time == 60:
		set_shift_values(15, 20)
	elif shift_time == 150:
		set_shift_values(12, 16)
	elif shift_time == 250:
		vamp_despawn()
	elif shift_time == 240:
		set_shift_values(8, 14)

var day7_call1_chat = [
	["day7start", 1.0, "manager"],
]

var day7_end_chat = [
	["day7end", 1.0, "manager"],
]

func day7_start():
	shift_start()
	generator_steal_prob()
	#sabo_time()

func day_generator_steal():
	$anomalies/robber.visible = 1
	subtitle("generator_steal", 1.0)
	generator_steal_time()

func generator_steal_time():
	for i in range(11):
		if generator_area: 
			generator_steal_stop()
			return
		await get_tree().create_timer(1.0, false, false, false).timeout
		subtitle(str(10-i), 0.2)
	await get_tree().create_timer(1.0, false, false, false).timeout
	subtitle("", 0)
	generator_steal_apply()

func generator_steal_stop():
	subtitle("steal stop", 0)
	$anomalies/robber.visible = 0
	generator_steal_prob()

func generator_steal_prob():
	var temp = randi_range(35, 60)
	await get_tree().create_timer(temp, false, false, false).timeout
	day_generator_steal()
	

func _on_arabic_pressed() -> void:
	TranslationServer.set_locale("ar")
	translation()
	newspaper_translation()

func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	translation()
	newspaper_translation()


func _on_settings_pressed() -> void:
	$CanvasLayer/pause/settings_.visible = !$CanvasLayer/pause/settings_.visible
	$CanvasLayer/pause/brief_.visible = 0
	$CanvasLayer/pause/restart_.visible = 0
	$CanvasLayer/pause/quit_.visible = 0


var timeshifter_exist = 0
var timeshifter_options = 0


func timeshifter_spawn():
	timeshifter_exist = 1
	$anomalies/timeshifter.visible = 1
	$areas/timeshifter/CollisionShape2D.set_deferred("disabled", 0)
	
	await get_tree().create_timer(60, false, false, false).timeout
	timeshifter_depsawn()

func timeshifter_depsawn():
	timeshifter_exist = 0
	$anomalies/timeshifter.visible = 0
	$areas/timeshifter/CollisionShape2D.set_deferred("disabled", 1)


func _on_timeshifter_body_entered(body: Node2D) -> void:
	timeshifter_options = 1
	show_decision_option("What's time now?", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00")

func _on_timeshifter_body_exited(body: Node2D) -> void:
	timeshifter_options = 0
	hide_decisions()

func timeshifter_apply(option):
		option += 1
		option *= 60
		option -= 1
		
		$CanvasLayer/decision/o3.visible = 0
		$CanvasLayer/decision/o4.visible = 0
		$CanvasLayer/decision/o5.visible = 0
		$CanvasLayer/decision/o6.visible = 0
		hide_decisions()
		timeshifter_depsawn()
		await get_tree().create_timer(5, false, false, false).timeout
		shift_time = option

func end_game():
	print("game over")
	$CanvasLayer/end_screen/black.visible = 1
	await get_tree().create_timer(0.6, false, false, false).timeout
	$CanvasLayer/end_screen/poster.visible = 1
	await get_tree().create_timer(4, false, false, false).timeout
	$CanvasLayer/end_screen/poster.visible = 0
	global.temp_reset()
	await get_tree().create_timer(1, false, false, false).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


#ideas to do
## high scores
#### newspapre player's name on day7
### achievements
## leaderboard
## visitors mode
# save/load



#
