extends Node2D

export(int) var index

var locked = false
var days
var hours

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_locked(v):
	locked = v
	if(locked): $Label.text = "Locked"

func set_time(d, h):
	days = d
	hours = h
	$Label.text = "In " + str(days) + " and " + str(hours) + " hours"
