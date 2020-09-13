extends Control

onready var http : HTTPRequest = $HTTPRequest

var information_sent := false
var new_map := false

func _ready() -> void:
	Firebase.get_document("map_data/%s" % "world", http)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	#print(result_body)
	match response_code:
		404:
			print("404")
			new_map = true
			return
		200:
			if information_sent:
				print("Information saved successfully")
				information_sent = false

func _on_UploadButton_pressed():
	var map_data = get_tree().get_root().get_node("World").getDictionary()
	match new_map:
		true:
			Firebase.save_document("map_data?documentId=%s" % "world", map_data, http)
		false:
			Firebase.update_document("map_data/%s" % "world", map_data, http)
	information_sent = true

func _on_GenerateButton_pressed():
	get_tree().get_root().get_node("World").generate_simplex()

func _on_LoadButton_pressed():
	get_tree().get_root().get_node("World").load_map()
	


