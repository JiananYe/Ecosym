extends Control

var firestore_users
onready var notification: Label = $Container/Notification

func _ready():
	firestore_users = Firebase.Firestore.collection("users")
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "on_login_failed")
	Firebase.Auth.connect("userdata_received", self, "_on_userdata_received")
	pass

func _on_LoginButton_pressed() -> void:
	var email = $Container/VBoxContainer/Username/LineEdit.text
	var password = $Container/VBoxContainer/Password/LineEdit.text
	Firebase.Auth.login_with_email_and_password(email, password)
	
func on_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
	
func _on_FirebaseAuth_login_succeeded(auth):
	Firebase.Auth.get_user_data()
	hide()
	get_node("../UserProfile").show()

func _on_userdata_received(userdata):
	Local.userdata = userdata
	firestore_users.get(Local.userdata.local_id)
	print("userdata received")
