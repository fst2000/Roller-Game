class_name LandState

var roller
var time = 0.0

func _init(roller):
	roller.anim_player.play("land")
	self.roller = roller
	
func update(delta):
	roller.race(delta)
	roller.collide()
	time += delta

func next_state():
	if time > 0.25:
		return RaceState.new(roller) 

	if !roller.floor_check():
		return FallState.new(roller)
	return self

func exit():
	pass
