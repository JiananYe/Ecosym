extends Control

onready var username: LineEdit = $Container/VBoxContainer/Username/LineEdit
onready var password: LineEdit = $Container/VBoxContainer/Password/LineEdit
onready var notification: Label = $Container/Notification

func _ready():
	Firebase.Auth.connect("login_failed", self, "on_login_failed")

func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))

func _on_Button_pressed() -> void:
	Firebase.Auth.signup_with_email_and_password(username.text, password.text)
	hide()
	get_node("../Login").show()
