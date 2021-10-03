extends Control
var time

func _ready():
	time = OS.get_unix_time_from_datetime(OS.get_datetime()) - Global.time
	if (Global.ending == 1): #TOWN IS DEATH
		$RichTextLabel.text = "Well done. Everyone is dead. TIME:" + str(time)
	if (Global.ending == 2): #LEFT TOWN
		$RichTextLabel.text = "You left town, why though?"
	if (Global.ending == 3): #PLAYER DIED
		$RichTextLabel.text = "Please don't die"
