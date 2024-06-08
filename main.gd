extends Node2D

var ground_scene_path
var ground_scene
var obstacle_scene_path
var obstacle_scene

var last_ground_offset = 0
var ground_width = 578
var last_obstacle_offset = 500
var obstacle_spacing = 600

var speed = 400.0
var player_start_position
var camera_start_position
var loaded_area_start_position
var is_paused = false
var preventing_pause_screen = false
var current_position = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_scene_path = $Ground.scene_file_path
	ground_scene = load(ground_scene_path)
	obstacle_scene_path = $Obstacle.scene_file_path
	obstacle_scene = load(obstacle_scene_path)
	
	$UiLayer/GameOverRetryUi.hide()
	player_start_position = $Player.position
	camera_start_position = $Camera.position
	loaded_area_start_position = $LoadedArea.position
	$UiLayer/Score.start()

func restart_game():
	current_position = 0.0
	last_ground_offset = 0
	last_obstacle_offset = 500
	get_tree().get_nodes_in_group("spawned").map(func(node): remove_child(node))
	is_paused = true
	$UiLayer/GameOverRetryUi.hide()
	$Player.get_ready(player_start_position)
	$Camera.position = camera_start_position
	$LoadedArea.position = loaded_area_start_position
	$UiLayer/Score.score = 0
	
	await get_tree().create_timer(1.0).timeout
	preventing_pause_screen = false
	is_paused = false
	$Player.go()
	$UiLayer/Score.start()
	
func game_over():
	preventing_pause_screen = true
	$UiLayer/PauseScreen.hide()
	print('game_over')
	$UiLayer/Score.stop()
	$UiLayer/GameOverRetryUi.set_score($UiLayer/Score.score)
	$UiLayer/GameOverRetryUi.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not preventing_pause_screen and Input.is_action_just_pressed("pause"):
		if not is_paused:
			is_paused = true
			$UiLayer/Score.pause()
			$UiLayer/PauseScreen.show()
			$Player.pause()
		else:
			is_paused = false
			$UiLayer/Score.unpause()
			$UiLayer/PauseScreen.hide()
			$Player.unpause()
	
	if not is_paused:
		current_position += delta * speed
		$Camera.position.x += delta * speed
		$LoadedArea.position.x += delta * speed
		maybe_spawn_ground()
		maybe_spawn_obstacle()
		
func maybe_spawn_ground():
	if last_ground_offset < current_position + ground_width:
		var new_ground = ground_scene.instantiate()
		last_ground_offset += ground_width
		new_ground.position.x += last_ground_offset
		new_ground.add_to_group("spawned")
		add_child(new_ground)
		
func maybe_spawn_obstacle():
	if last_obstacle_offset < current_position + obstacle_spacing:
		var new_obstacle = obstacle_scene.instantiate()
		last_obstacle_offset += obstacle_spacing
		new_obstacle.position.x += last_obstacle_offset
		# random height
		new_obstacle.position.y = randf_range(0, 250)
	
		new_obstacle.add_to_group("spawned")
		add_child(new_obstacle)

func _on_player_player_died():
	game_over()

func _on_game_over_retry_pressed():
	restart_game()

func _on_loaded_area_body_exited(body):
	if body.is_in_group("spawned"):
		remove_child(body)
