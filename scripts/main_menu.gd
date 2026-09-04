extends Node2D

var current_shift = 1

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
		row.get_node("Label3").text = str(entry["max_danger"])
		row.get_node("Label4").text = str(entry["anomalies_reported"])
		row.get_node("Label5").text = str(entry["sabotages_fixed"])


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
	loading()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_continue_pressed() -> void:
	loading()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func loading():
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
		$CanvasLayer/Container/Label.text = "Loading .."
		await get_tree().create_timer(0.3).timeout
		$CanvasLayer/Container/Label.text = "Loading ."
		await get_tree().create_timer(0.3).timeout
		$CanvasLayer/Container/Label.text = "Loading .."
		await get_tree().create_timer(0.3).timeout
		$CanvasLayer/Container/Label.text = "Loading ..."
		await get_tree().create_timer(0.3).timeout
	
	var tween3 = create_tween()
	tween3.tween_property($CanvasLayer/Container/Label, "modulate:a", 0.0, 0.3)
	await get_tree().create_timer(0.5).timeout

func _on_close_pressed() -> void:
	$CanvasLayer/settings.visible = 0
	$CanvasLayer/scores.visible = 0
	$CanvasLayer/scores_.visible = 0
	$CanvasLayer/achievments_.visible = 0
	
	
	$CanvasLayer/buttons.visible = 1
	
	

func _on_settings_pressed() -> void:
	
	#var tween = create_tween()
	#tween.tween_property($CanvasLayer/buttons, "modulate:a", 1.0, 0.3)
	
	$CanvasLayer/buttons.visible = 0
	$CanvasLayer/settings.visible = 1

func translation():
	$CanvasLayer/buttons/continue.text = tr("continue")
	$CanvasLayer/buttons/newgame.text = tr("newgame")
	$CanvasLayer/buttons/settings.text = tr("settings")
	$CanvasLayer/buttons/scores.text = tr("scores")
	$CanvasLayer/buttons/quit.text = tr("quit")
	$CanvasLayer/buttons/name.placeholder_text = tr("name") 


func _on_arabic_pressed() -> void:
	TranslationServer.set_locale("ar")
	translation()

func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	translation()

func _on_scores_pressed() -> void:
	$CanvasLayer/buttons.visible = 0
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
	load_shift(shift)
	$CanvasLayer/scores.visible = 0
	$CanvasLayer/scores_.visible = 1
	$CanvasLayer/scores_/title.text = tr('shift') + str(shift)

func _on_scores_back_pressed() -> void:
	$CanvasLayer/scores.visible = 1
	$CanvasLayer/scores_.visible = 0

func _on_achievments_pressed() -> void:
	$CanvasLayer/buttons.visible = 0
	$CanvasLayer/achievments_.visible = 1

func _on_signup_pressed() -> void:
	supabase.sign_up($CanvasLayer/mail.text, $CanvasLayer/password.text)

func _on_login_pressed() -> void:
	await supabase.login($CanvasLayer/mail.text, $CanvasLayer/password.text, $CanvasLayer/player.text)
	
	var progress = await supabase.get_progress()
	if progress:
		$CanvasLayer/player.text = str(progress["player_name"])
	
	if global.shift != 1:
		$CanvasLayer/buttons/continue.disabled = 0
	
func _on_save_pressed() -> void:
	var name = $CanvasLayer/player.text.strip_edges()

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





#
