extends Node2D

var ground_scene_path
var ground_scene
var speed = 400.0
var player_start_position
var camera_start_position
var ui_start_position
var loaded_area_start_position
var last_ground_offset = 0
var ground_width = 578
var is_paused = false
var current_position = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_scene_path = $Ground.scene_file_path
	ground_scene = load(ground_scene_path)
	$Ui.hide()
	player_start_position = $Player.position
	camera_start_position = $Camera.position
	ui_start_position = $Ui.position
	loaded_area_start_position = $LoadedArea.position

func restart_game():
	current_position = 0.0
	last_ground_offset = 0
	is_paused = true
	$Ui.hide()
	$Player.get_ready(player_start_position)
	$Camera.position = camera_start_position
	$Ui.position = ui_start_position
	$LoadedArea.position = loaded_area_start_position
	await get_tree().create_timer(1.0).timeout
	is_paused = false
	$Player.go()
	
func game_over():
	print('game_over')
	$Ui.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_paused:
		current_position += delta * speed
		$Camera.position.x += delta * speed
		$Ui.position.x += delta * speed
		$LoadedArea.position.x += delta * speed
		maybe_spawn_ground()
		
func maybe_spawn_ground():
	if last_ground_offset < current_position + ground_width:
		var new_ground = ground_scene.instantiate()
		last_ground_offset += ground_width
		new_ground.position.x += last_ground_offset
		new_ground.add_to_group("spawned")
		add_child(new_ground)

func _on_player_player_died():
	game_over()

func _on_game_over_retry_pressed():
	restart_game()

func _on_loaded_area_body_exited(body):
	if body.is_in_group("spawned"):
		remove_child(body)
