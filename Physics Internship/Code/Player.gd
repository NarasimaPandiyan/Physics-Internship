extends RigidBody2D

var wheels = []
var speed = 60000
var max_speed = 50

func _ready():
	wheels = get_tree().get_nodes_in_group("wheel")

func _process(delta):
	var pos = self.position
	var h = get_distance(pos,[pos[0],1470])
	var v =abs(wheels[0].angular_velocity * 64)/50
	var ke = round(self.mass * v * v * 0.5)
	var pe = round(self.mass * 9.8 * h)
	var te = round(ke + pe)
	get_parent().set_KEBAR(ke,te)
	get_parent().set_PEBAR(pe,te)
	get_parent().set_TEBAR(te)
		

func _physics_process(delta):
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		for wheel in wheels:
			if wheel.angular_velocity < max_speed:
				wheel.apply_torque_impulse(speed * delta * 60)
				
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		for wheel in wheels:
			if wheel.angular_velocity > -max_speed:
				wheel.apply_torque_impulse(-speed * delta * 60)
	
func get_distance(point1,point2):
	# √(x2-x1)2 + (y2-y1)2
	return sqrt(pow(point2[0]-point1[0],2)+pow(point2[1]-point1[1],2))/50
