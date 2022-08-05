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
var pe_vs_h_id
const start_points = Vector2(68,8)
var loop = true
var h_data = []
var v_data = []

func _ready():
	wheels = get_tree().get_nodes_in_group("Wheel")
	ke_vs_v_id = $Graph_Window/KE_vs_v.add_curve("KE vs V",Color.dodgerblue)
	pe_vs_h_id = $Graph_Window/PE_vs_h.add_curve("PE vs H",Color.crimson)
	

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
	
	h_data.append(round(h))
	v_data.append(round(v))
	
	#updating info
	$info/FPS.text = "FPS: "+str(Engine.get_frames_per_second())
	$info/Height.text ="h: "+ str(round(h))
	$info/Velocity.text = "v: "+str(round(v))
	
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
		$Graph_Window/KE_vs_v.x_axis_label = "v"
		$Graph_Window/KE_vs_v.y_axis_label = "KE"
		$Graph_Window/KE_vs_v.y_axis_max_value = te*m
		$Graph_Window/KE_vs_v.x_axis_max_value = 20.0*m
		$Graph_Window/KE_vs_v.add_point(ke_vs_v_id,Vector2(v,ke))
		
		$Graph_Window/PE_vs_h.x_axis_label = "h"
		$Graph_Window/PE_vs_h.y_axis_label = "PE"
		$Graph_Window/PE_vs_h.y_axis_max_value = 150*m
		$Graph_Window/PE_vs_h.x_axis_max_value = 20.0
		$Graph_Window/PE_vs_h.add_point(pe_vs_h_id,Vector2(h,pe))
		
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
	$Car.hide()
	$info/Height.hide()
	$info/Velocity.hide()


func _on_graph_button_pressed():
	$Graph_Window.popup()
	

func _on_Area2D_body_entered(body):
	if loop:
		$Graph_Window/KE_vs_v.clear_curve(ke_vs_v_id)
		$Graph_Window/PE_vs_h.clear_curve(ke_vs_v_id)
		
		reload()
	else:
		$Car.hide()
		$info/Height.hide()
		$info/Velocity.hide()


func _on_Loop_toggled(button_pressed):
	loop = button_pressed
	
func reload():
	$Car.show()
	$Car.position = $SpawnPoint.position
	$Car.rotation_degrees = $SpawnPoint.rotation_degrees
	for wheel in wheels:
		wheel.angular_velocity = 0
		wheel.linear_velocity = Vector2(0,0)
		wheel.applied_torque = 0
		wheel.applied_force = Vector2(0,0)



func _on_Reset_button_pressed():
	get_tree().reload_current_scene()
	reload()


func _on_Graph_Window_popup_hide():
	pass # Replace with function body.


func _on_Mass_Slider_value_changed(value):
	$Car.mass = value
	
