class_name JumpState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_player.play("jump")
	roller.jump()
	
func update(delta):
	roller.fall(delta)
	roller.flip(delta)
	roller.collide()

func next_state():
	
	if !roller.anim_player.is_playing():
		return FallState.new(roller)
	
	if roller.floor_check():
		return LandState.new(roller)
	return self

func exit():
	pass
