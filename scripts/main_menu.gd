extends Node2D

func _ready() -> void:
	translation()
	if global.shift != 1:
		$CanvasLayer/buttons/continue.disabled = 0

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
	$CanvasLayer/scores.visible = 0
	$CanvasLayer/scores_.visible = 1
	$CanvasLayer/scores_/title.text = tr('shift') + str(shift)

func _on_scores_back_pressed() -> void:
	$CanvasLayer/scores.visible = 1
	$CanvasLayer/scores_.visible = 0

func _on_achievments_pressed() -> void:
	$CanvasLayer/buttons.visible = 0
	$CanvasLayer/achievments.visible = 1









#
