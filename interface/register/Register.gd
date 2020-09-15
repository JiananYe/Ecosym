extends Control

onready var username: LineEdit = $Container/VBoxContainer/Username/LineEdit
onready var password: LineEdit = $Container/VBoxContainer/Password/LineEdit
onready var notification: Label = $Container/Notification
	
func _on_Button_pressed() -> void:
	Firebase.Auth.signup_with_email_and_password(username, password)
	get_tree().change_scene("res://interface/login/Login.tscn")
