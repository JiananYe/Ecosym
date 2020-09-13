extends VBoxContainer

func _ready():
	$NicknameContainer/Nickname.text = Local.profile.nickname.stringValue
	$CreditsContainer/Credits.text = str(Local.profile.credits.integerValue)
