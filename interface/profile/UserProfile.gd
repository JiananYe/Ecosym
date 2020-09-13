extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var nickname : LineEdit = $Container/VBoxContainer/Name/LineEdit
onready var notification : Label = $Container/Notification
onready var credits : Label = $Container/VBoxContainer/Credits/Credits

var new_profile := false
var information_sent := false
var profile := {
	"nickname": {},
	"credits": { "integerValue": 1000 }
} setget set_profile, get_profile


func _ready() -> void:
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print("http result ",result_body)
	match response_code:
		404:
			notification.text = "Please, enter your information"
			new_profile = true
			return
		200:
			if information_sent:
				notification.text = "Information saved successfully"
				information_sent = false
			self.profile = result_body.fields


func _on_ConfirmButton_pressed() -> void:
	if nickname.text.empty():
		notification.text = "Please, enter your nickname"
		return
	profile.nickname = { "stringValue": nickname.text }
	profile.credits = { "integerValue": 1000 }
	match new_profile:
		true:
			print("new profile")
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			print("old profile")
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
			Local.profile = self.profile
			get_tree().change_scene("res://Game/World.tscn")
	information_sent = true


func set_profile(value: Dictionary) -> void:
	profile = value
	nickname.text = profile.nickname.stringValue
	credits.text = profile.credits.integerValue

func get_profile():
	return profile
