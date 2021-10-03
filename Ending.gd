extends Control

func everyoneDead():
	if():
		return true
	else:
		return false

func _ready():
	if (everyoneDead()):
		$RichTextLabel.text = "Well done. Everyone is dead"
