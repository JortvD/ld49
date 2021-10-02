extends Panel

var tween_in = false
var tween_out = false
var duration
onready var tween = get_node("Tween")

func effect(dur):
	tween.interpolate_property(self, "modulate", Color(0, 0, 0, 0), Color(1, 1, 1, 1), dur, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween_in = true
	duration = dur

func _on_Tween_tween_completed(object, key):
	if(tween_in == false): tween_out = false
	else: 
		tween_in = false
		$Timer.wait_time = duration
		$Timer.start()

func _on_Timer_timeout():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(0, 0, 0, 0), duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	tween_out = true
	$Timer.stop()
