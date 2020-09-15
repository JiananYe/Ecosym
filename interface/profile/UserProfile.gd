extends Control

var firestore

func _ready() -> void:
	firestore = Firebase.Firestore.collection("users")
	Firebase.Auth.connect("userdata_received", self, "_on_userdata_received")
	firestore.connect("get_document", self, "_on_get_doc_received")

func _on_ConfirmButton_pressed():
	if Firebase.Auth.auth:
		#firestore = Firebase.Firestore.collection("new1")
		#firestore.add("new2", {"fields": {"new3": {"stringValue": "new4"}}})
		print(Local.profile)

func _on_userdata_received(userdata):
	print("userdata received")
	firestore.get(userdata.local_id)

func _on_get_doc_received(doc):
	print("doc received")
	Local.profile = doc
	print(Local.profile)

"""

onready var http : HTTPRequest = $HTTPRequest
onready var nickname : LineEdit = $Container/VBoxContainer/Name/LineEdit
onready var notification : Label = $Container/Notification
onready var credits : Label = $Container/VBoxContainer/Credits/Credits

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
