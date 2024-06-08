extends RichTextLabel

var score = 0:
	get:
		return score
	set(value):
		score = value
		text = str(score)

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
