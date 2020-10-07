extends Tabs

onready var tree = $OfferTree

func _ready():
	var root = tree.create_item()
	root.set_text(0,"YOUR OFFERS")
	
	var section1 = tree.create_item(root)
	section1.set_text(0, "section1")

	var item1 = tree.create_item(section1)
	item1.set_text(0, "item1")

	var item2 = tree.create_item(section1)
	item2.set_text(0, "item2")
