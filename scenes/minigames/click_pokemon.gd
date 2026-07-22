extends Control

signal game_finished(win: bool)

var clicks = 0
var target_clicks = 10
var time_left = 5

func _ready() -> void:
	$CounterLabel.text = "0/" + str(target_clicks)
	$TimeLabel.text = str(time_left)
	
func _process(delta):
	time_left = max(0, int(ceil($GameTimer.time_left)))
	$TimeLabel.text = str(time_left)

func _on_pokemon_button_pressed() -> void:
	clicks += 1
	$CounterLabel.text = str(clicks) + "/" + str(target_clicks)

	$PokemonButton.position = Vector2(
	randi_range(150, 800),
	randi_range(120, 380)
)

	if clicks >= target_clicks:
		$GameTimer.stop()
		game_finished.emit(true)
		queue_free()

func _on_game_timer_timeout() -> void:
	game_finished.emit(false)
	queue_free()

	
		
