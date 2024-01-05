class_name KeyInput

func input():
	return Vector3(
		Input.get_axis("ui_right", "ui_left"),
		0,
		Input.get_axis("ui_down", "ui_up"))

func is_jump():
	return Input.is_action_just_pressed("jump")
