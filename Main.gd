extends Control

func _on_RegisterButton_pressed():
	get_tree().change_scene("res://interface/register/Register.tscn")


func _on_LoginButton_pressed():
	get_tree().change_scene("res://interface/login/Login.tscn")


func _on_TestButton_pressed():
	get_tree().change_scene("res://Game/World.tscn")
