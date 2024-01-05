class_name LandState

var roller
var time = 0.0

func _init(roller):
	self.roller = roller
	roller.anim_tree["parameters/conditions/is_falling"] = false
	roller.anim_tree["parameters/conditions/is_on_floor"] = true
	
func update(delta):
	roller.race(delta)
	time += delta

func next_state():
	if time > 0.25:
		print(time)
		return RaceState.new(roller) 
	return self

func exit():
	pass