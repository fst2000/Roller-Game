class_name RaceState

var roller

var race_state_machine
var crash_state

func _init(roller):
	self.race_state_machine = StateMachine.new(RaceIdleState.new(roller))
	self.roller = roller

func update(delta):
	race_state_machine.update(delta)
	roller.race(delta)
	
	crash_state = roller.get_crash_state()

	if !crash_state:
		roller.collide()

func next_state():
	if !roller.floor_check():
		return FallState.new(roller)
	
	if roller.roller_input.is_jump():
		return JumpState.new(roller)
	
	if crash_state:
		return crash_state
	
	return self

func exit():
	pass
