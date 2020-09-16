extends VBoxContainer

var firestore_users

func _ready():
	firestore_users = Firebase.Firestore.collection("users")
	firestore_users.connect("get_document", self, "_on_get_doc_received")

func _on_get_doc_received(doc):
	$NicknameContainer/Nickname.text = doc.doc_fields.nickname.stringValue
	$CreditsContainer/Credits.text = str(doc.doc_fields.credits.integerValue)
