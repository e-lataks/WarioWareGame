extends Control

var berries_fed = 0
var target_berries = 5

var closed_texture = preload("res://assets/sprites/snorlax.png")
var open_texture = preload("res://assets/sprites/snorlax-open.png")

var dragging = false
var drag_offset = Vector2.ZERO

signal game_finished(win: bool)

func _ready():
	spawn_new_berry()
	$FeedLabel.text = "0/" + str(target_berries)
	$Snorlax.texture = closed_texture
	$GameTimer.start()

func _on_game_timer_timeout():
	game_finished.emit(false)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				if $Berry.get_global_rect().has_point(event.position):
					dragging = true
					drag_offset = $Berry.position - event.position
			else:
				dragging = false
			
				check_feed()

	elif event is InputEventMouseMotion:
		if dragging:
			$Berry.position = event.position + drag_offset
			
func check_feed():
	print("Checking...")

	var berry_center = $Berry.get_global_rect().get_center()

	if $MouthArea.get_global_rect().has_point(berry_center):
		print("EAT!")
		feed_snorlax()
			
func feed_snorlax():
	berries_fed += 1
	$FeedLabel.text = str(berries_fed) + "/" + str(target_berries)

	$Berry.hide()

	$Snorlax.texture = open_texture
	$Snorlax.scale = Vector2(1.18, 1.18)

	await get_tree().create_timer(0.5).timeout

	$Snorlax.texture = closed_texture
	$Snorlax.scale = Vector2(1, 1)

	if berries_fed >= target_berries:
		game_finished.emit(true)
	else:
		spawn_new_berry()

func spawn_new_berry():
	$Berry.show()

	$Berry.position = Vector2(
		randi_range(100, 800),
		randi_range(100, 400)
	)
	
func _process(delta):
	var time_left = max(0, int(ceil($GameTimer.time_left)))
	$TimeLabel.text = str(time_left)
