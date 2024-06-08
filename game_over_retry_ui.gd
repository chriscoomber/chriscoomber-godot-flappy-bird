extends Control

signal retry_pressed

func set_score(score):
	$Score.text = str(score)


func _on_button_pressed():
	retry_pressed.emit()
	$Button/ButtonSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and Input.is_action_just_pressed("restart"):
		retry_pressed.emit()
