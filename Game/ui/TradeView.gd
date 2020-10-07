extends VBoxContainer

onready var buy_tree = $TabContainer/Buy/BuyTree

func _ready():
	var root = buy_tree.create_item()
	root.set_text(0,"ROOT")
	
	var section1 = buy_tree.create_item(root)
	section1.set_text(0, "section1")

	var item1 = buy_tree.create_item(section1)
	item1.set_text(0, "item1")

	var item2 = buy_tree.create_item(section1)
	item2.set_text(0, "item2")
