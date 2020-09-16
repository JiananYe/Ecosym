extends WindowDialog

func _on_BuildButton_pressed():
	get_tree().get_root().get_node("World/CanvasLayer/TileView").visible = false
	get_tree().get_root().get_node("World/CanvasLayer/BuildMenu").popup()

func _on_BuyButton_pressed():
	get_tree().get_root().get_node("World").set_tile_owner()
