extends Control

var firestore_users
var new_profile

onready var nickname : LineEdit = $Container/VBoxContainer/Name/LineEdit
onready var credits : Label = $Container/VBoxContainer/Credits/Credits
onready var notification : Label = $Container/Notification

func _ready() -> void:
	firestore_users = Firebase.Firestore.collection("users")
	firestore_users.connect("get_document", self, "_on_get_doc_received")
	firestore_users.connect("error", self, "on_error_received")

func _on_ConfirmButton_pressed():
	if Firebase.Auth.auth:
		if nickname.text.empty():
			notification.text = "Please, enter your nickname"
			return
		else:
			if new_profile:
				var profile := {
					"nickname": {"stringValue": nickname.text},
					"credits": {"integerValue": 1000}
				}
				firestore_users.add(Local.userdata.local_id, {"fields": profile})
			get_tree().change_scene("res://Game/World.tscn")
			

func _on_error_received(code,status,message):
	new_profile = true

func _on_get_doc_received(doc):
	print("doc received", doc.doc_fields)
	Local.profile = doc.doc_fields
	print(Local.profile.nickname.stringValue, nickname)
	nickname.text = Local.profile.nickname.stringValue
	credits.text = Local.profile.credits.integerValue

"""

onready var http : HTTPRequest = $HTTPRequest

var new_profile := false
var information_sent := false
var profile := {
	"nickname": {},
	"credits": {}
} setget set_profile, get_profile

func _ready() -> void:
	FirestoreDocument.get("users/%s" % Firebase.user_info.id)

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
	match new_profile:
		true:
			print("new profile")
			profile.credits = { "integerValue": 1000 }
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
			Local.profile = self.profile
			get_tree().change_scene("res://Game/World.tscn")
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

"""
