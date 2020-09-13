extends Control


func _on_QuarryButton_pressed():
	print("building Quarry")
	get_tree().get_root().get_node("World").set_map_obj(4)
	self.visible = false

func _on_WoodButton_pressed():
	print("building Woodcutter")
	get_tree().get_root().get_node("World").set_map_obj(3)
	self.visible = false

func _on_FarmButton_pressed():
	print("building Farm")
	get_tree().get_root().get_node("World").set_map_obj(5)
	self.visible = false
