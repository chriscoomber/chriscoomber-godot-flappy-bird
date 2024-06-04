extends Node2D

var start_position

func restart_game():
	$GameOver.hide()
	$Player.get_ready(start_position)
	await get_tree().create_timer(1.0).timeout
	$Player.go()
	
func game_over():
	print('game_over')
	$GameOver.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOver.hide()
	start_position = $Player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_player_died():
	game_over()

func _on_game_over_retry_pressed():
	restart_game()
