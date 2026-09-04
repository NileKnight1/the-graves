extends Node2D

var current_shift = 1
var loggedin = 0

func _ready() -> void:
	translation()
	#supabase.get_leaderboard(1)
	
	if global.shift != 1:
		$CanvasLayer/buttons/continue.disabled = 0
	
	load_shift(1)

func load_shift(shift_number: int):
	current_shift = shift_number

	var data = await supabase.get_leaderboard(shift_number)

	if data == null:
		return

	fill_leaderboard(data)
	update_my_score(shift_number)


func fill_leaderboard(data):
	var container = $CanvasLayer/scores_/ScrollContainer/VBoxContainer
	var template = $CanvasLayer/scores_/ScrollContainer/VBoxContainer/HBoxContainer1

	# Delete old rows
	for child in container.get_children():
		if child != template:
			child.queue_free()

	# Create rows
	for i in range(data.size()):
		var row = template.duplicate()

		container.add_child(row)
		row.visible = true

		var entry = data[i]

		row.get_node("Label1").text = str(i + 1)
		row.get_node("Label2").text = str(entry["player"])
		row.get_node("Label3").text = str(int(entry["max_danger"]))
		row.get_node("Label4").text = str(int(entry["anomalies_reported"]))
		row.get_node("Label5").text = str(int(entry["sabotages_fixed"]))


func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	TranslationServer.set_locale("ar")


func _on_button_2_pressed() -> void:
	TranslationServer.set_locale("en")

func _on_line_edit_text_changed(new_text: String) -> void:
	global.player_name = new_text

func _on_o_2_pressed() -> void:
	global.temp_reset()
	await loading()
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_continue_pressed() -> void:
	await loading()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func loading():
	disable_buttons()
	$CanvasLayer/buttons/continue.disabled = 1
	$CanvasLayer/buttons/newgame.disabled = 1
	$CanvasLayer/buttons/settings.disabled = 1
	$CanvasLayer/buttons/scores.disabled = 1
	$CanvasLayer/buttons/quit.disabled = 1
	
	var tween = create_tween()
	var tween2 = create_tween()
	
	$CanvasLayer/black.modulate = 0
	$CanvasLayer/black.visible = 1
	tween.tween_property($CanvasLayer/black, "modulate:a", 1.0, 0.3)
	
	#$CanvasLayer/Container/Label.modulate = 0
	$CanvasLayer/Container/Label.visible = 1
	tween2.tween_property($CanvasLayer/Container/Label, "modulate:a", 1.0, 0.3)
	
	await get_tree().create_timer(0.3).timeout
	#
	for i in range(3):
		print(i)
		$CanvasLayer/Container/Label.text = tr("Loading ..")
		await get_tree().create_timer(0.3).timeout
		$CanvasLayer/Container/Label.text = tr("Loading .")
		await get_tree().create_timer(0.3).timeout
		$CanvasLayer/Container/Label.text = tr("Loading ..")
		await get_tree().create_timer(0.3).timeout
		$CanvasLayer/Container/Label.text = tr("Loading ...")
		await get_tree().create_timer(0.3).timeout
	
	var tween3 = create_tween()
	tween3.tween_property($CanvasLayer/Container/Label, "modulate:a", 0.0, 0.3)
	await get_tree().create_timer(0.5).timeout

func _on_close_pressed() -> void:
	$CanvasLayer/settings.visible = 0
	$CanvasLayer/scores.visible = 0
	$CanvasLayer/scores_.visible = 0
	$CanvasLayer/achievments_.visible = 0
	
	$CanvasLayer/account.visible = 1
	$CanvasLayer/buttons.visible = 1
	
	

func _on_settings_pressed() -> void:
	
	#var tween = create_tween()
	#tween.tween_property($CanvasLayer/buttons, "modulate:a", 1.0, 0.3)
	
	$CanvasLayer/buttons.visible = 0
	$CanvasLayer/account.visible = 0
	$CanvasLayer/settings.visible = 1

func translation():
	$CanvasLayer/buttons/continue.text = tr("continue")
	$CanvasLayer/buttons/newgame.text = tr("newgame")
	$CanvasLayer/buttons/settings.text = tr("settings")
	$CanvasLayer/buttons/scores.text = tr("scores")
	$CanvasLayer/buttons/achievments.text = tr("achievments")
	$CanvasLayer/buttons/quit.text = tr("quit")
	
	$CanvasLayer/settings/options/lang/label.text = tr("language")
	$CanvasLayer/settings/title.text = tr("settings")
	
	$CanvasLayer/scores/options/shift1.text = ">   " + tr("shift") + " 1"
	$CanvasLayer/scores/options/shift2.text = ">   " + tr("shift") + " 2"
	$CanvasLayer/scores/options/shift3.text = ">   " + tr("shift") + " 3"
	$CanvasLayer/scores/options/shift4.text = ">   " + tr("shift") + " 4"
	$CanvasLayer/scores/options/shift5.text = ">   " + tr("shift") + " 5"
	$CanvasLayer/scores/options/shift6.text = ">   " + tr("shift") + " 6"
	$CanvasLayer/scores/options/shift7.text = ">   " + tr("shift") + " 7"
	$CanvasLayer/scores/title.text = tr("leaderboard")
	
	$CanvasLayer/scores_/HBoxContainer/Label.text = tr("rank")
	$CanvasLayer/scores_/HBoxContainer/Label2.text = tr("Player")
	$CanvasLayer/scores_/HBoxContainer/Label3.text = tr("max_danger")
	$CanvasLayer/scores_/HBoxContainer/Label4.text = tr("anomalies_reported")
	$CanvasLayer/scores_/HBoxContainer/Label6.text = tr("sabotages_fixed")
	$CanvasLayer/scores_/title.text = tr("leaderboard")
	
	$CanvasLayer/achievments_/title.text = tr("achievments")
	
	$CanvasLayer/account/title.text = tr("account")
	$CanvasLayer/account/player.placeholder_text = tr("acc_name")
	$CanvasLayer/account/savename.text = tr("save_name")
	$CanvasLayer/account/mail.placeholder_text = tr("acc_mail")
	$CanvasLayer/account/password.placeholder_text = tr("acc_pass")
	$CanvasLayer/account/HBoxContainer/signup.text = tr("signup")
	$CanvasLayer/account/HBoxContainer/login.text = tr("login")
	
	
	#$CanvasLayer/buttons/name.placeholder_text = tr("name") 


func _on_arabic_pressed() -> void:
	TranslationServer.set_locale("ar")
	translation()

func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	translation()

func _on_scores_pressed() -> void:
	$CanvasLayer/buttons.visible = 0
	$CanvasLayer/account.visible = 0
	$CanvasLayer/scores.visible = 1
	

func _on_shift1_scores_pressed() -> void:
	show_scores(1)
func _on_shift2_scores_pressed() -> void:
	show_scores(2)
func _on_shift3_scores_pressed() -> void:
	show_scores(3)
func _on_shift4_scores_pressed() -> void:
	show_scores(4)
func _on_shift5_scores_pressed() -> void:
	show_scores(5)
func _on_shift6_scores_pressed() -> void:
	show_scores(6)
func _on_shift7_scores_pressed() -> void:
	show_scores(7)

func show_scores(shift):
	disable_score_buttons()
	await load_shift(shift)
	enable_score_buttons()
	$CanvasLayer/scores.visible = 0
	$CanvasLayer/scores_.visible = 1
	$CanvasLayer/scores_/title.text = tr('shift') + str(shift)

func disable_score_buttons():
	$CanvasLayer/scores/options/shift1.disabled = 1
	$CanvasLayer/scores/options/shift2.disabled = 1
	$CanvasLayer/scores/options/shift3.disabled = 1
	$CanvasLayer/scores/options/shift4.disabled = 1
	$CanvasLayer/scores/options/shift5.disabled = 1
	$CanvasLayer/scores/options/shift6.disabled = 1
	$CanvasLayer/scores/options/shift7.disabled = 1
	$CanvasLayer/scores/close.disabled = 1

func enable_score_buttons():
	$CanvasLayer/scores/options/shift1.disabled = 0
	$CanvasLayer/scores/options/shift2.disabled = 0
	$CanvasLayer/scores/options/shift3.disabled = 0
	$CanvasLayer/scores/options/shift4.disabled = 0
	$CanvasLayer/scores/options/shift5.disabled = 0
	$CanvasLayer/scores/options/shift6.disabled = 0
	$CanvasLayer/scores/options/shift7.disabled = 0
	$CanvasLayer/scores/close.disabled = 0


func _on_scores_back_pressed() -> void:
	$CanvasLayer/scores.visible = 1
	$CanvasLayer/scores_.visible = 0

func _on_achievments_pressed() -> void:
	$CanvasLayer/buttons.visible = 0
	$CanvasLayer/account.visible = 0
	$CanvasLayer/achievments_.visible = 1

func _on_signup_pressed() -> void:
	disable_buttons()
	
	var code = await supabase.sign_up($CanvasLayer/account/mail.text, $CanvasLayer/account/password.text)

	if code == 422:
		$CanvasLayer/account/feedback.text = tr("Email is already registered.")
	elif code == 400:
		$CanvasLayer/account/feedback.text = tr("Please enter a valid email.")
	elif code == 200 or code == 201:
		$CanvasLayer/account/feedback.text = tr("Check your email!")
	elif code == 429:
		$CanvasLayer/account/feedback.text = tr("Try again later.")
	else:
		$CanvasLayer/account/feedback.text = tr("Signup failed.")
	enable_buttons()

func _on_login_pressed() -> void:
	disable_buttons()
	var code = await supabase.login($CanvasLayer/account/mail.text, $CanvasLayer/account/password.text, $CanvasLayer/account/player.text)

	if code == 200:
		$CanvasLayer/account/feedback.text = tr("Login successful!")
	else:
		$CanvasLayer/account/feedback.text = tr("Wrong email or password.")
		
	var progress = await supabase.get_progress()
	if progress:
		$CanvasLayer/account/player.text = str(progress["player_name"])
	
	if global.shift != 1:
		$CanvasLayer/buttons/continue.disabled = 0
	
	enable_buttons()
	logged()
	
	#
	#if global.loggedin:
		#logged()

func disable_buttons():
	#$CanvasLayer/buttons/continue.disabled = 1
	$CanvasLayer/buttons/newgame.disabled = 1
	$CanvasLayer/buttons/settings.disabled = 1
	$CanvasLayer/buttons/scores.disabled = 1
	$CanvasLayer/buttons/achievments.disabled = 1
	$CanvasLayer/buttons/quit.disabled = 1
	$CanvasLayer/account/savename.disabled = 1
	$CanvasLayer/account/HBoxContainer/signup.disabled = 1
	$CanvasLayer/account/HBoxContainer/login.disabled = 1
	$CanvasLayer/account/player.editable = 0
	$CanvasLayer/account/mail.editable = 0
	$CanvasLayer/account/password.editable = 0

func enable_buttons():
	$CanvasLayer/buttons/newgame.disabled = 0
	$CanvasLayer/buttons/settings.disabled = 0
	$CanvasLayer/buttons/scores.disabled = 0
	$CanvasLayer/buttons/achievments.disabled = 0
	$CanvasLayer/buttons/quit.disabled = 0
	$CanvasLayer/account/savename.disabled = 0
	$CanvasLayer/account/HBoxContainer/signup.disabled = 0
	$CanvasLayer/account/HBoxContainer/login.disabled = 0
	$CanvasLayer/account/player.editable = 1
	$CanvasLayer/account/mail.editable = 1
	$CanvasLayer/account/password.editable = 1


func _on_save_pressed() -> void:
	var name = $CanvasLayer/account/player.text.strip_edges()

	if name == "":
		print("Name cannot be empty!")
		return

	var progress = await supabase.get_progress()

	if progress == null:
		print("No progress found!")
		return

	var last_shift_won = int(progress["last_shift_won"])

	await supabase.save_progress(name, last_shift_won)

	print("Name updated to: ", name)
	$CanvasLayer/account/feedback.text = "Name upadted."


func update_my_score(shift_number: int):
	var data = await supabase.get_my_score(shift_number)

	if data == null:
		$CanvasLayer/scores_/HBoxContainer3/Label1.text = "-"
		$CanvasLayer/scores_/HBoxContainer3/Label2.text = "-"
		$CanvasLayer/scores_/HBoxContainer3/Label3.text = "-"
		$CanvasLayer/scores_/HBoxContainer3/Label4.text = "-"
		$CanvasLayer/scores_/HBoxContainer3/Label5.text = "-"
		return

	$CanvasLayer/scores_/HBoxContainer3/Label1.text = str(data["rank"])
	$CanvasLayer/scores_/HBoxContainer3/Label2.text = str(data["player"])
	$CanvasLayer/scores_/HBoxContainer3/Label3.text = str(data["max_danger"])
	$CanvasLayer/scores_/HBoxContainer3/Label4.text = str(data["anomalies_reported"])
	$CanvasLayer/scores_/HBoxContainer3/Label5.text = str(data["sabotages_fixed"])

func logged():
	$CanvasLayer/account/player.editable = 1
	$CanvasLayer/account/savename.disabled = 0



#
