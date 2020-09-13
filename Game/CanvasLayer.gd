extends CanvasLayer

func _on_SettingsButton_pressed():
	$Settings.popup()

func _input(event):
	if event.is_action_released("ui_cancel"):
		print("true")
		if $TileView.visible == true:
			$TileView.visible = false
		else: 
			if $Settings.visible == true:
				$Settings.visible = false
			else:
				$Settings.popup()
