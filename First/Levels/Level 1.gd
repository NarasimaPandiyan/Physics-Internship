extends Node2D

var plot1_id : int
var wheels = []
func _ready():
	var plot1_id = $"Graph/Graph2D".add_curve("y = 0.1*x")
	wheels = get_tree().get_nodes_in_group("wheel")
	
func set_KEBAR(val:float,m ):
	$"Kinetic Energy".max_value = m
	$"Kinetic Energy".value = val

func set_PEBAR(val:float,m):
	$"Potential Energy".max_value = m
	$"Potential Energy".value = val

func set_TEBAR(val:float):
	$"Total Energy".max_value = val
	$"Total Energy".value = val


func _process(delta):
	$FPS.text = "FPS: "+str(Engine.get_frames_per_second())
	var pos = $Player.position
	var h = $Player.get_distance(pos,[pos[0],1470])
	var v  = abs(wheels[0].angular_velocity * 64)/50
	var ke = round($Player.mass * v * v * 0.5)
	var pe = round($Player.mass * 9.8 * h)
	var te = round(ke + pe)
	$"Graph/Graph2D".add_point(plot1_id, Vector2(v,ke))
