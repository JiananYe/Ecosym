extends WindowDialog

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.


func _on_BuildButton_pressed():
	get_tree().get_root().get_node("World/CanvasLayer/TileView").visible = false
	get_tree().get_root().get_node("World/CanvasLayer/BuildMenu").popup()
