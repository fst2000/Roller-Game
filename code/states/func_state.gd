class_name FuncState

var update_func
var end_func
var next_state_func

func _init(start_func, update_func, end_func, next_state_func):
	start_func.call()
	self.update_func = update_func
	self.end_func = end_func
	self.next_state_func = next_state_func
	
func update(delta):
	update_func.call(delta)
	
func end():
	end_func.call()

func next_state():
	next_state_func.call()
