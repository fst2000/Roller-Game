class_name RaceState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_tree["parameters/conditions/is_race"] = true
func update(delta):
	var right = roller.quaternion * Vector3.RIGHT
	var slide_blend = 0.5 + ((-roller.velocity.normalized().dot(right) * 0.5) * roller.velocity.length() * 0.2)
	slide_blend = clamp(slide_blend, 0, 1)
	var race_slide_blend = abs(0.5 - slide_blend) * 2
	var race_blend = roller.forward().dot(roller.velocity)
	race_blend = clamp(race_blend, 0, 1)
	roller.anim_tree["parameters/race/slide_blend/blend_amount"] = slide_blend
	roller.anim_tree["parameters/race/race_slide_blend/blend_amount"] = race_slide_blend
	roller.anim_tree["parameters/race/race_blend/blend_amount"] = race_blend
	roller.race(delta)

func next_state():
	if !roller.floor_check():
		return FallState.new(roller)
	
	if roller.roller_input.is_jump():
		return JumpState.new(roller)
	
	if roller.velocity.length() < 0.1:
		return IdleState.new(roller)
	return self

func exit():
	roller.anim_tree["parameters/conditions/is_race"] = false
