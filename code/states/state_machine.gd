class_name StateMachine

var state

func _init(state):
	self.state = state

func update(delta):
	var next = state.next_state()
	if state != next:
		state.exit()
		state = next
	state.update(delta)
