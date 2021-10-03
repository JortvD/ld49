extends Node2D

onready var hour = 6
onready var minutes = 30
onready var tween = get_node("Tween")
var transition = false

func _ready():
	$MinuteTimer.start()

func _process(delta):
	
	if (hour < 6 or hour > 23 and transition):
		tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 0.6), Color(1, 1, 1, 0.6), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		transition = false
	elif (hour == 7 and not transition):
		tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 0.6), Color(1, 1, 1, 0.2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		transition = true
	elif (hour == 8 and transition):
		tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 0.2), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		transition = false
	elif(hour == 21 and not transition):
		tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 0.2), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		transition = true
	elif(hour == 22 and transition):
		tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 0.2), Color(1, 1, 1, 0.4), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		transition = false
	elif(hour == 23 and not transition):
		tween.interpolate_property($Panel, "modulate", Color(1, 1, 1, 0.4), Color(1, 1, 1, 0.6), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		transition = true

func _on_MinuteTimer_timeout():
	minutes += 10
	if (minutes == 60):
		minutes = 0
		hour += 1
	if (hour == 24):
		hour = 0
	$MinuteTimer.start()
