extends Node

const ENVIRONMENT_VARIABLES : String = "environment_variables/"
onready var Auth = HTTPRequest.new()
onready var Firestore = Node.new()
onready var Database = Node.new()

# Configuration used by all files in this project
# These values can be found in your Firebase Project
# See the README on Github for how to access
var config = {  
	"apiKey": "AIzaSyCfKYnYg8P9HCQbd7YnxvjKfySXPIwiCBo",
	"authDomain": "test-75d0d.firebaseapp.com",
	"databaseURL": "https://test-75d0d.firebaseio.com",
	"projectId": "test-75d0d",
	"storageBucket": "test-75d0d.appspot.com",
	"messagingSenderId": "156334913829",
	"appId": "1:156334913829:web:12af3aa859a3fbe6b642cc",
	"measurementId": "G-1QV2Z7W0YY"
	}

func load_config():
	if ProjectSettings.has_setting(ENVIRONMENT_VARIABLES+"apiKey"):
		for key in config.keys():
			config[key] = ProjectSettings.get_setting(ENVIRONMENT_VARIABLES+key)
		print(config)
	else:
		printerr("No configuration settings found, add them in override.cfg file.")

func _ready():
	load_config()
	Auth.set_script(preload("res://addons/GDFirebase/FirebaseAuth.gd"))
	Firestore.set_script(preload("res://addons/GDFirebase/FirebaseFirestore.gd"))
	Database.set_script(preload("res://addons/GDFirebase/FirebaseDatabase.gd"))
	Auth.set_config(config)
	Firestore.set_config(config)
	Database.set_config(config)
	add_child(Auth)
	add_child(Firestore)
	add_child(Database)
	Auth.connect("login_succeeded", Database, "_on_FirebaseAuth_login_succeeded")
	Auth.connect("login_succeeded", Firestore, "_on_FirebaseAuth_login_succeeded")
