extends Camera2D

func _input(event) -> void:
	if event is InputEventScreenDrag:
		offset -= event.relative
		print(offset)
		self.offset = offset
