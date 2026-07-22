extends Control

func _ready():
	print("GAME OVER SCENE LOADED")
	$ScoreLabel.text = "Score: " + str(Global.final_score)

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game_manager.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main.tscn")
