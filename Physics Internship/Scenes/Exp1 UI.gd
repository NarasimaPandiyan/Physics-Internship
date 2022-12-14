extends Control


#	
onready var KE_graph = get_node("Graph_Window/Graph_Panel/KE vs v")
onready var KE_graph_m = get_node("Graph_Window/Graph_Panel/KE vs v_m")
onready var PE_graph = get_node("Graph_Window/Graph_Panel/PE vs h")

onready var parent = get_node("/root/Experiment 1")

var op = ["MERCURY","VENUS","EARTH","MOON" ,"MARS", "JUPITER ","SATURN","URANUS", "NEPTUNE","PLUTO"]
var val = [3.7,8.9,9.8,1.6,3.7,23.1,9.0,8.7,11.0,0.7]
var pred = ["next 1 value","next 2 values","next 5 values","next 10 values"]
var g = 9.8


export var speed = 6000
export var max_speed = 50
var wheels = []
var state = 7
func _ready():
	wheels = get_tree().get_nodes_in_group("Wheel")
	$UI/p_toggle.pressed = Global.p_toggle_state
	
	KE_graph.initialize(KE_graph.LABELS_TO_SHOW.Y_LABEL,
	{
	KE = Color8(0, 137, 161),
	})
	PE_graph.initialize(PE_graph.LABELS_TO_SHOW.NO_LABEL,
	{
	PE = Color8(220, 26, 52)
	})
	KE_graph_m.initialize(state,
	{
	KE = Color8(220, 26, 52),
	})
	
	for i in op:
		$Graph_Window/Slider_Panel/GravityOption.add_item(i)
	for i in pred:
		$Graph_Window/Slider_Panel/OptionButton.add_item(i)
	
	$Graph_Window/Slider_Panel/GravityOption.add_separator()
	$Graph_Window/Slider_Panel/GravityOption.add_item("CUSTOM")
	$Graph_Window/Slider_Panel/GravityOption.select(2)
	
	$Graph_Window/Slider_Panel/Gravity_Slider.max_value = 23.1
	$Graph_Window/Slider_Panel/Gravity_Slider.min_value = 0.7
	$Graph_Window/Slider_Panel/Gravity_Slider.editable = false

func _on_b_toggle_toggled(button_pressed):
	$COE_info/VerticalBars.visible = button_pressed


func _on_Reset_button_pressed():
	return get_tree().reload_current_scene()
	


func _on_Start_button_pressed():
	Global.data = []
	for wheel in wheels:
		if wheel.angular_velocity < max_speed:
			wheel.apply_torque_impulse(speed * get_physics_process_delta_time() * 60)
	
func _on_p_toggle_toggled(button_pressed):
	
	$COE_info/PieChart.visible = button_pressed
	Global.p_toggle_state = button_pressed


func _on_Graph_Window_popup_hide():
	parent.get_node("graph_button").show()
	Global.GWindow_state = false
	


func _on_Mass_Slider_value_changed(value):
	get_node("/root/Experiment 1").drawScatterKE(KE_graph_m,((value/10)/9.8)*g)
	get_node("%Mass_Label").text= str(value) 


func _on_GravityOption_item_selected(index):
	
	if(index != 11):
		get_node("/root/Experiment 1").drawScatterKE(KE_graph_m,(($Graph_Window/Slider_Panel/Mass_Slider.value/10)/9.8)*val[index])
		$Graph_Window/Slider_Panel/Gravity_Slider.value = val[index]
		g=val[index]
		$Graph_Window/Slider_Panel/Gravity_Slider.editable = false
		get_node("%Gravity_Label").text = str(val[index])
	else:
		$Graph_Window/Slider_Panel/Gravity_Slider.editable = true
		


func _on_TextureButton2_pressed():
	$Graph_Window.hide()


func _on_Button_pressed():
	Global.v_data = lr.addNoise(Global.v_data)
	Global.ke_data = lr.addNoise(Global.ke_data)
	lr.fit(Global.v_data,Global.ke_data)
	print(lr.optionPredict($Graph_Window/Slider_Panel/OptionButton.selected))


func _on_Gravity_Slider_value_changed(value):
	get_node("%Gravity_Label").text = str(value)
	get_node("/root/Experiment 1").drawScatterKE(KE_graph_m,(($Graph_Window/Slider_Panel/Mass_Slider.value/10)/9.8)*value)
	$Graph_Window/Slider_Panel/Gravity_Slider.value = value
	g=value
