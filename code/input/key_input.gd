class_name KeyInput

func input():
	return Vector3(
		Input.get_axis("right", "left"),
		0,
		Input.get_axis("down", "up"))

func is_jump():
	return Input.is_action_just_pressed("jump")

func turn():
	return Input.get_axis("turn_l", "turn_r")
