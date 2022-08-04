extends Node2D

const M = 50 #n number of pixels to represent a meter. here 50 pixels represent a meter
var wheels = []
var pos
var h : float
var v : float
var m : float
var g = 9.8
var ke : float
var pe : float
var te :float
var ke_vs_v_id 
var pe_vs_
const start_points = Vector2(68,8)
var loop = false


func _ready():
	wheels = get_tree().get_nodes_in_group("Wheel")
	ke_vs_v_id = $Graph_Window/Graph2D.add_curve("KE vs V",Color.dodgerblue)
	

func _physics_process(delta):
	#Calculating parameters
	pos = $Car.position
	v = wheels[0].angular_velocity * 16
	v = v/M
	h = get_distance(pos,[pos[0],720])
	m = $Car.mass
	
	#Calculating Energy
	ke = 0.5 * m * v * v # ½mv2
	pe = m * g * h # mgh
	te = ke+pe
	
	#rounding them from decimal
	ke = round(ke)
	pe = round(pe)
	te = round(te)
	
	#updating info
	$info/FPS.text = "FPS: "+str(Engine.get_frames_per_second())
	$info/Height.text ="h: "+ str(h)
	$info/Velocity.text = "v: "+str(v)
	
	#updating the ke bar
	$COE_info/VerticalBars/ke.max_value = te
	$COE_info/VerticalBars/ke.value = ke
	
	#updating the pe bar
	$COE_info/VerticalBars/pe.max_value = te
	$COE_info/VerticalBars/pe.value = pe
	
	#updating the te bar
	$COE_info/VerticalBars/te.max_value = te
	$COE_info/VerticalBars/te.value = te
	
	#updating the pie
	$COE_info/PieChart/Pie.max_value = te
	$COE_info/PieChart/Pie.value = ke
	
	#plotting graph
	if $Car.position < Vector2(1280,720):
		$Graph_Window/Graph2D.x_axis_label = "v"
		$Graph_Window/Graph2D.y_axis_label = "KE"
		$Graph_Window/Graph2D.y_axis_max_value = te
		$Graph_Window/Graph2D.x_axis_max_value = 20.0
		$Graph_Window/Graph2D.add_point(ke_vs_v_id,Vector2(v,ke))
	else:
		#$Graph_Window/Graph2D.clear_curve(ke_vs_v_id)
		pass
	
	
func get_distance(point1,point2):
	# √(x2-x1)2 + (y2-y1)2
	return sqrt(pow(point2[0]-point1[0],2)+pow(point2[1]-point1[1],2))/M
	

func _on_p_toggle_toggled(button_pressed):
	$COE_info/PieChart.visible = button_pressed


func _on_b_toggle_toggled(button_pressed):
	$COE_info/VerticalBars.visible = button_pressed


func _on_Button_pressed():
	$Car.position = $Node2D.position


func _on_graph_button_pressed():
	$Graph_Window.popup()

func _on_Area2D_body_entered(body):
	if loop:
		$Car.position = $Node2D.position
		$Graph_Window/Graph2D.clear_curve(ke_vs_v_id)
		for wheel in wheels:
			wheel.angular_velocity = 0
		


func _on_Loop_toggled(button_pressed):
	loop = button_pressed
