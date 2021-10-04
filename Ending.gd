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
	if (Global.ending == 4): #CITY BURNED DOWN
		set_text("You let the city burn down")
		set_subtext("It was out of control after " + str(days) + " days and " + str(hours) + " hours")
	if (Global.ending == 5): #CITY BURNED DOWN
		set_text("You bought the whole city")
		set_subtext("After just " + str(days) + " days and " + str(hours) + " hours of playing")
	if (Global.ending == 6): #DIED WITH RESPECT
		set_text("You died while everyone liked you")
		set_subtext("But it took you " + str(days) + " days and " + str(hours) + " hours of playing")
	if (Global.ending == 7): #KILLED WITH RESPECT
		set_text("All the NPCs died while respecting you")
		set_subtext("But it took you " + str(days) + " days and " + str(hours) + " hours of playing")
	if (Global.ending == 8): # CITY FORGOTTEN
		set_text("With no communication to the outside, the city has been forgotten")
		set_subtext("You were there for " + str(days) + " days and " + str(hours) + " hours")
	if (Global.ending == 9): # BARRICADED DOORS
		set_text("As all the doors are barricaded everyone is stuck")
		set_subtext("You were able to after " + str(days) + " days and " + str(hours) + " hours of playing")
	
	Global.hours = hours
	Global.days = days
	
	$Timer.start()

func set_text(text):
	$RichTextLabel.bbcode_text = "[center]" + text + "[/center]"

func set_subtext(text):
	$Label.text = text

func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/MainMenu.tscn")
