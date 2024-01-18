extends AnimationTree

func set_condition(blend_name : String, value : bool):
	self["parameters/conditions/" + blend_name] = value

func set_blend2(blend_name : String, value : float):
	value = clamp(value, 0,1)
	self["parameters/" + blend_name + "/blend_amount"] = value

func set_blend3(blend_name : String, value : float):
	value = clamp(value, -1,1)
	self["parameters/" + blend_name + "/blend_amount"] = value
