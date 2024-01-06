extends AnimationTree

func set_condition(name : String, value : bool):
	self["parameters/conditions/" + name] = value

func set_blend(name : String, value : float):
	value = clamp(value, 0,1)
	self["parameters/race/" + name + "/blend_amount"] = value
