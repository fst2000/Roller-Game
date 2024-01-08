class_name CrashFloorBackState

var roller
var anim_tree

func _init(roller):
	self.roller = roller
	self.anim_tree = roller.anim_tree
	anim_tree.set_condition("is_crush_start", true)
	anim_tree.set_condition("is_crush_end", false)
	
func update():
	roller.slide()
	
func end():
	anim_tree.set_condition("is_crush_start", true)
	anim_tree.set_condition("is_crush_end", false)

func next_state():
	return self
