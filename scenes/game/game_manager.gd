extends Node2D

var minigames = [
	"res://scenes/minigames/click_pokemon.tscn"
]

var lives = 4
var score = 0

var countdown = 3
var current_game = null

func _ready() -> void:
	randomize()
	update_hearts()
	$UI/ReadyPanel/ReadyLabel.text = str(countdown)

func start_first_minigame():
	$UI/HUD.hide()
	var scene_path = minigames.pick_random()

	current_game = load(scene_path).instantiate()

	$GameContainer.add_child(current_game)

	current_game.game_finished.connect(_on_game_finished)

func _on_ready_timer_timeout() -> void:
	countdown -= 1

	if countdown > 0:
		$UI/ReadyPanel/ReadyLabel.text = str(countdown)

	elif countdown == 0:
		$UI/ReadyPanel/ReadyLabel.text = "GO!"

	else:
		$ReadyTimer.stop()
		$UI/ReadyPanel.hide()
		start_first_minigame()

func _on_game_finished(win: bool):
	$UI/HUD.show()
	if win:
		score += 1
		print("Score:", score)
	else:
		lives -= 1
		update_hearts()
		print("Lives:", lives)

		if lives <= 0:
			print("GAME OVER")
			return

	current_game = null

	await get_tree().create_timer(1.0).timeout

	countdown = 3
	$UI/ReadyPanel.show()
	$UI/ReadyPanel/ReadyLabel.text = str(countdown)
	$ReadyTimer.start()

func update_hearts():
	$UI/HUD/HeartsContainer/Heart1.visible = lives >= 1
	$UI/HUD/HeartsContainer/Heart2.visible = lives >= 2
	$UI/HUD/HeartsContainer/Heart3.visible = lives >= 3
	$UI/HUD/HeartsContainer/Heart4.visible = lives >= 4
