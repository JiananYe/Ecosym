extends CanvasLayer

func _input(event):
	if event.is_action_released("ui_cancel"):
		print("true")
		if $Popup.visible == true:
			$Popup.visible = false
		else: 
			if $Settings.visible == true:
				$Settings.visible = false
			else:
				$Settings.popup()

func _on_SettingsButton_pressed():
	$Settings.popup()

func _on_Research_pressed():
	$Popup.view_research()
