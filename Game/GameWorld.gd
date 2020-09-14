extends Node2D

signal started
signal finished

var _rng = RandomNumberGenerator.new()
var d = {}
var new_map := false
var tile_pos
const ressource = {
	0: "can",
	1: "cargo",
	2: "crystal",
	3: "wheat",
	4: "wood",
	5: "oil",
	6: "coal",
	7: "stone",
	8: "",
	9: "",
}


onready var http : HTTPRequest = $HTTPRequest
onready var _tilemap = $Navigation2D/TileMap
onready var _tilemap_obj = $Navigation2D/TileMapObj
onready var _tilemap_img = $Navigation2D/TileMapImg
onready var _tile_view = preload("res://Game/ui/TileView.tscn")

export var size_units = Vector2(32,18)

const CUSTOM_OFFSET_X = 0
const CUSTOM_OFFSET_Y = 36

func _ready() -> void:
	Firebase.get_document("map_data/%s" % "world", http)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and not $CanvasLayer/TileView.visible and Input.is_action_pressed("main_click"):
			var pos = event.position
			var camera_pos = $KinematicBody2D.position
			tile_pos = getSelectedHexagon(pos + camera_pos)
			var tile_index = _tilemap.get_cell(tile_pos.x, tile_pos.y)
			var resource_index = d[str(tile_pos.x)].mapValue.fields[str(tile_pos.y)].mapValue.fields.ressource.integerValue
			print(pos,"tile_pos",tile_pos)
			#print("dictionary content", d, " tile_index", tile_index)
			$CanvasLayer/TileView.popup()
			$CanvasLayer/TileView/Content/Body/TileInfo/TileImage.texture = _tilemap.tile_set.tile_get_texture(tile_index)
			$CanvasLayer/TileView/Content/Body/TileInfo/TilePosition.text = str(tile_pos.x) + ", " + str(tile_pos.y)
			$CanvasLayer/TileView/Content/Body/Ressources/HBoxContainer/TextureRect.texture = _tilemap_img.tile_set.tile_get_texture(int(resource_index))
			$CanvasLayer/TileView/Content/Body/Ressources/HBoxContainer/Label.text = ressource[int(resource_index)]
			#Debug Hex Cells
			#$Navigation2D/TileMap.set_cell(tile_pos.x,tile_pos.y,tile_index+1)

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	print(result_body)
	match response_code:
		404:
			print("404")
			return
		200:
			print("Information loaded successfully")
			self.d = result_body.fields
			load_map()

func load_map():
	for x in range(0,size_units.x):
		for y in range(0,size_units.y):
			_tilemap.set_cell(x,y,
			int(d[str(x)].mapValue.fields[str(y)].mapValue.fields.tile_index.integerValue))
			_tilemap_obj.set_cell(x,y,
			int(d[str(x)].mapValue.fields[str(y)].mapValue.fields.building.integerValue))

func setup() -> void:
	var map_size_px = (size_units+Vector2(0.5,0)) * _tilemap.cell_size
	generate_simplex()

func generate() -> void:
	emit_signal("started")
	_rng.randomize()    
	for x in range(0,size_units.x):
		for y in range(0,size_units.y):
			var cell = get_random_tile()
			_tilemap.set_cell(x,y,cell)
	emit_signal("finished")
	
func generate_simplex() -> void:
	d = {}
	emit_signal("started")
	_rng.randomize()
	var simplexNoise = OpenSimplexNoise.new()
	#configuring noise properties
	simplexNoise.seed = _rng.randi()
	simplexNoise.octaves = 10
	simplexNoise.period = 20.0
	simplexNoise.persistence = 1
	simplexNoise.lacunarity = 2
	for x in range(0,size_units.x):
		d[x]= {"mapValue": {"fields":{}}}
		for y in range(0,size_units.y):
			var cell = get_random_tile_simplex(simplexNoise.get_noise_2d(x,y))
			var value = {
				"tile_index": {"integerValue": cell},
				"ressource": {"integerValue": _rng.randi_range(0,7)},
				"owner": {"stringValue": ""},
				"building": {"integerValue": -1},
			}
			d[x].mapValue.fields[y] = {
				"mapValue": {"fields": value}
			}
			_tilemap.set_cell(x,y,cell)
	_tilemap_obj.clear()
	emit_signal("finished")

func set_tile_owner():
	#davor noch updaten sonst race condition bzw. in eigenes document packen
	print(d[str(tile_pos.x)].mapValue.fields[str(tile_pos.y)].mapValue.fields.owner.stringValue)
	d[str(tile_pos.x)].mapValue.fields[str(tile_pos.y)].mapValue.fields.owner.stringValue = Firebase.user_info.id
	Firebase.update_document("map_data/%s" % "world", d, http)
	#weiterer http node wird benötigt. sonst wird nur der erste request abgeschickt
	Local.set_credit(-150)
	#var profile = Local.profile
	#Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)

func set_map_obj(cell):
	if d[str(tile_pos.x)].mapValue.fields[str(tile_pos.y)].mapValue.fields.owner.stringValue == Firebase.user_info.id:
		_tilemap_obj.set_cell(tile_pos.x,tile_pos.y,cell)
		d[str(tile_pos.x)].mapValue.fields[str(tile_pos.y)].mapValue.fields.building.integerValue = cell
		Firebase.update_document("map_data/%s" % "world", d, http)
		#weiterer http node wird benötigt. sonst wird nur der erste request abgeschickt
		Local.set_credit(-100)
		#var profile = Local.profile
		#Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	else:
		print("You have to own the tile first")

func set_map():
	match new_map:
		true:
			Firebase.save_document("map_data?documentId=%s" % "world", d, http)
		false:
			Firebase.update_document("map_data/%s" % "world", d, http)

func get_random_tile() -> int:
	return _rng.randi_range(0,9)
	
func get_random_tile_simplex(noise_value:float) -> int:
	if(noise_value<-0.6):
		#print("sand")
		return _rng.randi_range(0,7)
	elif(noise_value<-0.2):
		#print("clay")
		return _rng.randi_range(8,16)
	elif(noise_value<0.2):
		#print("sand")
		return _rng.randi_range(0,7)
	elif(noise_value<0.6):
		#print("grass")
		return _rng.randi_range(17,24)
	else:
		#print("sand")
		return _rng.randi_range(0,7)

func getSelectedHexagon(pos):
	var gridHeight = $Navigation2D/TileMap.cell_size.y
	var gridWidth = $Navigation2D/TileMap.cell_size.x
	var halfWidth = gridWidth/2
	var c = 140 - gridHeight
	var m = float(c)/halfWidth
	var y = pos.y
	var x = pos.x
	var row = _tilemap.world_to_map(pos).y#int(y / gridHeight)
	var column
	var rowIsOdd = abs(fmod(row,2)) == 1;
	
	column = _tilemap.world_to_map(pos).x
	
	var relY = y - (row * gridHeight)
	var relX
	
	if rowIsOdd:
		relX = (x - (column * gridWidth)) - halfWidth
	else:
		relX = x - (column * gridWidth)
	
	print(relY, " ", -m,  " ", m, " ", relX, " ", c, " ", (-m * relX) + c, " ", (m * relX) - c, " ", _tilemap.world_to_map(pos))
	if (relY < (-m * relX) + c):
		row = row - 1
		if !rowIsOdd:
			column = column - 1
			
	else: if (relY < (m * relX) - c):
		row = row - 1
		if rowIsOdd:
			column = column + 1
	return Vector2(column,row);

func getDictionary():
	return d
