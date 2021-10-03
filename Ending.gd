extends Control

func _ready():
	if ($"/root/MainScene".ending == 1):
		$RichTextLabel.text = "Well done. Everyone is dead"
