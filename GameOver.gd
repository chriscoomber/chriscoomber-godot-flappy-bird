extends Control

signal retry_pressed

func set_score(score):
	$Score.text = str(score)


func _on_button_pressed():
	retry_pressed.emit()
