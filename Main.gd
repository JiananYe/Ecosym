extends Control

func _on_RegisterButton_pressed():
	$Title.hide()
	$Register.show()

func _on_LoginButton_pressed():
	$Title.hide()
	$Login.show()

func _on_TestButton_pressed():
	print("nothing")
