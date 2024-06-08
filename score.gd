extends RichTextLabel

var _score = 0
var score:
	get:
		return _score
	set(value):
		_score = value
		text = str(_score)

func start():
	$Timer.start()
	
func pause():
	$Timer.paused = true
	
func unpause():
	$Timer.paused = false
	
func stop():
	$Timer.stop()

func _on_timer_timeout():
	score += 1
