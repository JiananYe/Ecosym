extends Node2D

signal started
signal finished

var _rng = RandomNumberGenerator.new()

onready var _tilemap = $Navigation2D/TileMap
onready var _tile_view = preload("res://Game/ui/TileView.tscn")

export var size_units = Vector2(32,18)

"""
this is the offsets with respect to the image size
we make in order for
the tilemap's Mode , square to function as hex grids
"""
const CUSTOM_OFFSET_X = 0
const CUSTOM_OFFSET_Y = 36 
func _ready() -> void:
	setup()
	return

func setup() -> void:
	var map_size_px = (size_units+Vector2(0.5,0)) * _tilemap.cell_size
	#get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,SceneTree.STRETCH_ASPECT_KEEP,map_size_px+Vector2(CUSTOM_OFFSET_X,CUSTOM_OFFSET_Y))
	#generate()
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
		for y in range(0,size_units.y):
			var cell = get_random_tile_simplex(simplexNoise.get_noise_2d(x,y))
			_tilemap.set_cell(x,y,cell)
	emit_signal("finished")
	
func get_random_tile() -> int:
	return _rng.randi_range(0,9)
	
func get_random_tile_simplex(noise_value:float) -> int:
	if(noise_value<-0.6):
		print("sand")
		return _rng.randi_range(0,7)
	elif(noise_value<-0.2):
		print("clay")
		return _rng.randi_range(8,16)
	elif(noise_value<0.2):
		print("sand")
		return _rng.randi_range(0,7)
	elif(noise_value<0.6):
		print("grass")
		return _rng.randi_range(17,24)
	else:
		print("sand")
		return _rng.randi_range(0,7)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and not $CanvasLayer/TileView.visible:
			var pos = event.position
			var camera_pos = $KinematicBody2D/CollisionShape2D/Camera2D.position
			var tile_pos = _tilemap.world_to_map(pos) - _tilemap.world_to_map(camera_pos)
			var tile_image = _tilemap.get_cell(tile_pos.x, tile_pos.y)
			print(tile_pos)
			print(tile_image)
			$CanvasLayer/TileView.visible = true
			$CanvasLayer/TileView/Background/Content/Body/TileInfo/TilePosition.text = str(tile_pos.x) + ", " + str(tile_pos.y)
			#$TileView/TextureRect/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect.texture = 
