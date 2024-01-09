class_name RaceState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_tree.set_condition("is_race", true)
	roller.anim_tree.set_condition("is_idle", false)

func update(delta):
	var up = roller.quaternion * Vector3.UP
	var velocity_length = roller.velocity.length()
	var accelerate_blend = abs(roller.roller_input.input().z) * max(0, up.dot(Vector3.UP)) * velocity_length * 0.2
	var right = roller.quaternion * Vector3.RIGHT
	var slide_blend = 0.5 + ((-roller.velocity.normalized().dot(right) * 0.5) * roller.velocity.length() * 0.2)
	var race_slide_blend = abs(0.5 - slide_blend) * 2 - accelerate_blend * 0.7
	var race_blend = roller.forward().dot(roller.velocity)
	
	roller.anim_tree.set_blend2("race/accelerate_blend", accelerate_blend)
	roller.anim_tree.set_blend2("race/accelerate_back_blend", accelerate_blend)
	roller.anim_tree.set_blend2("race/slide_blend", slide_blend)
	roller.anim_tree.set_blend2("race/race_slide_blend", race_slide_blend)
	roller.anim_tree.set_blend2("race/race_blend", race_blend)
	
	roller.race(delta)
	roller.collide()

func next_state():
	if !roller.floor_check():
		return FallState.new(roller)
	
	if roller.roller_input.is_jump():
		return JumpState.new(roller)
	
	var colliding_rays = roller.collision_rays.get_colliding_rays()
	if colliding_rays:
		var ray = colliding_rays.front()
		var normal = ray.get_collision_normal()
		var is_floor = normal.angle_to(Vector3.UP) < 45 * PI / 180
		if is_floor:
			return CrashFloorState.new(roller, ray)
	
	return self

func exit():
	roller.anim_tree.set_condition("is_race", false)
	roller.anim_tree.set_condition("is_idle", true)
