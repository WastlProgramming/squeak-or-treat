extends Control


func _on_boy_button_pressed() -> void:
	GameState.selected_character = "boy"
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_girl_button_pressed() -> void:
	GameState.selected_character = "girl"
	get_tree().change_scene_to_file("res://scenes/level.tscn")
