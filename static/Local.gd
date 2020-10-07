extends Node

var profile
var userdata

func set_credit(value):
	profile.credits.integerValue = value + int(profile.credits.integerValue)
	get_tree().get_root().get_node("World/CanvasLayer/PlayerUI/CreditsContainer/Credits").text = str(profile.credits.integerValue)
	print(value, "credits",profile.credits.integerValue)

