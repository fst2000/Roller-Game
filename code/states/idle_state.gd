class_name IdleState

var roller

func _init(roller):
	roller.anim_player.play("idle")
	self.roller = roller
	
func update(delta):
	roller.velocity.x = 0
	roller.velocity.z = 0

func next_state():
	if roller.floor_check():
		if roller.roller_input.input().z > 0.1:
			return RaceState.new(roller)
	else:
		return FallState.new(roller)
	return self

func exit():
	pass
