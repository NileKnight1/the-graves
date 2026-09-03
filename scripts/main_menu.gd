extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	TranslationServer.set_locale("ar")


func _on_button_2_pressed() -> void:
	TranslationServer.set_locale("en")

func _on_line_edit_text_changed(new_text: String) -> void:
	global.player_name = new_text

func _on_o_2_pressed() -> void:
	$CanvasLayer/o1.disabled = 1
	$CanvasLayer/o2.disabled = 1
	$CanvasLayer/o3.disabled = 1
	$CanvasLayer/o4.disabled = 1
	var tween = create_tween()
	
	$CanvasLayer/black.modulate = 0
	$CanvasLayer/black.visible = 1
	tween.tween_property($CanvasLayer/black, "modulate:a", 1.0, 0.3)

	await get_tree().create_timer(5).timeout
	
	
	#get_tree().change_scene_to_file("res://scenes/game.tscn")
	
