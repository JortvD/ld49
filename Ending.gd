extends Control

func _ready():
	if (Global.ending == 1):
		$RichTextLabel.text = "Well done. Everyone is dead"
