extends Control

export var speed = 6000
export var max_speed = 50
var wheels = []
func _ready():
	wheels = get_tree().get_nodes_in_group("Wheel")
	$UI/p_toggle.pressed = Global.p_toggle_state
	


func _on_b_toggle_toggled(button_pressed):
	$COE_info/VerticalBars.visible = button_pressed


func _on_Reset_button_pressed():
	get_tree().reload_current_scene()


func _on_Start_button_pressed():
	for wheel in wheels:
		if wheel.angular_velocity < max_speed:
			wheel.apply_torque_impulse(speed * get_physics_process_delta_time() * 60)

func _on_p_toggle_toggled(button_pressed):
	$COE_info/PieChart.visible = button_pressed
	Global.p_toggle_state = button_pressed


func _on_Graph_Window_popup_hide():
	get_node("/root/Experiment 1/graph_button").show()
