extends Tabs

onready var tree = $LocalTree

func _ready():
	var root = tree.create_item()
	root.set_text(0,"Local Market")
	
	var city1 = tree.create_item(root)
	city1.set_text(0, "city1")

	var item1 = tree.create_item(city1)
	item1.set_text(0, "item1")

	var item2 = tree.create_item(city1)
	item2.set_text(0, "item2")
	
	var city2 = tree.create_item(root)
	city2.set_text(0, "city2")

	var item3 = tree.create_item(city2)
	item3.set_text(0, "item3")

	var item4 = tree.create_item(city2)
	item4.set_text(0, "item4")
