extends AnimationTree

func set_condition(name : String, value : bool):
	self["parameters/conditions/" + name] = value

func set_blend2(name : String, value : float):
	value = clamp(value, 0,1)
	self["parameters/" + name + "/blend_amount"] = value

func set_blend3(name : String, value : float):
	value = clamp(value, -1,1)
	self["parameters/" + name + "/blend_amount"] = value
