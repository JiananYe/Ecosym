extends Control

onready var notification: Label = $Container/Notification

func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "on_login_failed")
	pass

func _on_LoginButton_pressed() -> void:
	var email = $Container/VBoxContainer/Username/LineEdit.text
	var password = $Container/VBoxContainer/Password/LineEdit.text
	Firebase.Auth.login_with_email_and_password(email, password)
	
func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
	
func _on_FirebaseAuth_login_succeeded(auth):
	get_tree().change_scene("res://interface/profile/UserProfile.tscn")
