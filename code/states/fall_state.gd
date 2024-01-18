class_name FallState

var roller
var crash_state

func _init(roller):
	roller.anim_player.play("fall")
	self.roller = roller
	
func update(delta):
	roller.fall(delta)
	roller.flip(delta)
	crash_state = roller.get_crash_state()
	if !crash_state:
		roller.collide()

func next_state():
	if roller.floor_check():
		return LandState.new(roller)

	if crash_state:
		return crash_state
	
	return self

func exit():
	pass
