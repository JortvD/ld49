extends Control
var time

func _ready():
	$RichTextLabel.bbcode_enabled = true
	time = OS.get_unix_time_from_datetime(OS.get_datetime()) - Global.time
	var hours = time / 24.0
	var days = floor(hours / 24.0)
	hours = abs(int(hours) % 24)
	
	if (Global.ending == 1): #TOWN IS DEATH
		set_text("Well done. Everyone is dead.")
		set_subtext("And you only needed " + str(days) + " days and " + str(hours) + " hours to do it")
	if (Global.ending == 2): #LEFT TOWN
		set_text("You left town, why though?")
		set_subtext("It took you " + str(days) + " days and " + str(hours) + " hours to find the exit")
	if (Global.ending == 3): #PLAYER DIED
		set_text("Please don't die")
		set_subtext("At " + str(days) + " days and " + str(hours) + " hours old")
	
	Global.hours = hours
	Global.days = days
	
	$Timer.start()

func set_text(text):
	$RichTextLabel.bbcode_text = "[center]" + text + "[/center]"

func set_subtext(text):
	$Label.text = text

func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
