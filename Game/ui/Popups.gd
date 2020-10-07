extends WindowDialog

func _on_BuildButton_pressed():
	get_tree().get_root().get_node("World/CanvasLayer/Popup").visible = false
	get_tree().get_root().get_node("World/CanvasLayer/BuildMenu").popup()

func _on_BuyButton_pressed():
	get_tree().get_root().get_node("World").set_tile_owner()

func _on_TradeButton_pressed():
	view_trade()

func _on_ExploreButton_pressed():
	$TileView/Body/Actions.visible = false
	$TileView/Body/Explore.visible = true

func _on_BackButton_pressed():
	$TileView/Body/Actions.visible = true
	$TileView/Body/Explore.visible = false

func view_tile():
	popup()
	$TileView.visible = true
	$BuildingView.visible = false
	$CityView.visible = false
	$TradeView.visible = false
	$ResearchView.visible = false

func view_building():
	popup()
	$TileView.visible = false
	$BuildingView.visible = true
	$CityView.visible = false
	$TradeView.visible = false
	$ResearchView.visible = false

func view_city():
	popup()
	$TileView.visible = false
	$BuildingView.visible = false
	$CityView.visible = true
	$TradeView.visible = false
	$ResearchView.visible = false

func view_trade():
	popup()
	$TileView.visible = false
	$BuildingView.visible = false
	$CityView.visible = false
	$TradeView.visible = true
	$ResearchView.visible = false

func view_research():
	popup()
	$TileView.visible = false
	$BuildingView.visible = false
	$CityView.visible = false
	$TradeView.visible = false
	$ResearchView.visible = true
