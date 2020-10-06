extends WindowDialog

func _on_BuildButton_pressed():
	get_tree().get_root().get_node("World/CanvasLayer/Popup").visible = false
	get_tree().get_root().get_node("World/CanvasLayer/BuildMenu").popup()

func _on_BuyButton_pressed():
	get_tree().get_root().get_node("World").set_tile_owner()

func view_tile():
	popup()
	$TileView.visible = true
	$CityView.visible = false
	$ResearchView.visible = false
	
func view_city():
	popup()
	$TileView.visible = false
	$CityView.visible = true
	$ResearchView.visible = false

func view_research():
	popup()
	$TileView.visible = false
	$CityView.visible = false
	$ResearchView.visible = true
