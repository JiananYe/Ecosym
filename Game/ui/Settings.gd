extends Control

func _on_UploadButton_pressed():
	get_tree().get_root().get_node("World").set_map()

func _on_GenerateButton_pressed():
	get_tree().get_root().get_node("World").generate_simplex()

func _on_LoadButton_pressed():
	get_tree().get_root().get_node("World").load_map()

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Main.tscn")
