extends Control

func _ready():
	if (Global.ending == 1):
		$RichTextLabel.text = "Well done. Everyone is dead"
	if (Global.ending == 2):
		$RichTextLabel.text = "You left town, why though?"
