extends Node2D

const M = 50 #n number of pixels to represent a meter. here 50 pixels represent a meter
var wheels = []
var pos

export var h : float
export var v : float
var m : float
var g = 9.8

var ke : float
var pe : float
var te :float

var ke_vs_v_id 
var pe_vs_h_id


var table: TableManager.Table
var tablePlugin: TableManager.Plugin

onready var kev = $"Exp1_UI/Graph_Window/Graph_Panel/KE vs v"
onready var peh = $"Exp1_UI/Graph_Window/Graph_Panel/PE vs h"

func _ready():
	if Global.GWindow_state:
		$Exp1_UI/Graph_Window.popup()
	wheels = get_tree().get_nodes_in_group("Wheel")
	
	ke_vs_v_id = $Exp1_UI/Graph_Window/Graph_Panel/Ke_vs_V.add_curve("KE vs V",Color.dodgerblue)
	pe_vs_h_id = $Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.add_curve("PE vs H",Color.crimson)
	
	tablePlugin = $Exp1_UI/Graph_Window/Data_Panel/Table
	var colDefs = {
		"h":{
			"columnId": "h",
			"columnName": "h",
			"columnType": TableConstants.ColumnType.LABEL,
						"columnAlign": TableConstants.Align.CENTER
		},
		"v":{
			"columnId": "v",
			"columnName": "v",
			"columnType": TableConstants.ColumnType.LABEL,
						"columnAlign": TableConstants.Align.CENTER
		},
	}	
	
	
	var textRect = TextureRect.new()
	textRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	textRect.set_texture(load("res://icon.png"))
	var colNodeDefs = {
		"textureRect": textRect
	}
	var tblConfig = TableManager.createTableConfig(colDefs)
	table = TableManager.createTable(tablePlugin, tblConfig)
	TableManager.setTableData(table, Global.data)
	
	print(tablePlugin.to_string())
	
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
	
	Global.h_data.append(round(h))
	Global.v_data.append(round(v))
	
	#updating info
	$Exp1_UI/info/FPS.text = "FPS: "+str(Engine.get_frames_per_second())
	$Exp1_UI/info/Height.text ="h: "+ str(round(h))
	$Exp1_UI/info/Velocity.text = "v: "+str(round(v))
	
	#updating the ke bar
	$Exp1_UI/COE_info/VerticalBars/ke.max_value = te
	$Exp1_UI/COE_info/VerticalBars/ke.value = ke
	
	#updating the pe bar
	$Exp1_UI/COE_info/VerticalBars/pe.max_value = te
	$Exp1_UI/COE_info/VerticalBars/pe.value = pe
	
	#updating the te bar
	$Exp1_UI/COE_info/VerticalBars/te.max_value = te
	$Exp1_UI/COE_info/VerticalBars/te.value = te
	
	#updating the pie
	$Exp1_UI/COE_info/PieChart/Pie.max_value = te
	$Exp1_UI/COE_info/PieChart/Pie.value = ke
	
	#plotting graph
	#$Exp1_UI/Graph_Window/Graph_Panel/Ke_vs_V.set_y_axis_label("KE")
	#$Exp1_UI/Graph_Window/Graph_Panel/Ke_vs_V.set_y_axis_max_value(te*m)
	#$Exp1_UI/Graph_Window/Graph_Panel/Ke_vs_V.set_x_axis_max_value(20.0*m)
	#$Exp1_UI/Graph_Window/Graph_Panel/Ke_vs_V.add_point(ke_vs_v_id,Vector2(v,ke))
	
	#$Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.set_x_axis_label("h")
	#$Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.set_y_axis_label("PE")
	#$Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.set_y_axis_max_value(150*m)
	#$Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.set_x_axis_max_value(20.0)
	#$Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.add_point(pe_vs_h_id,Vector2(h,pe))
	
	
func get_distance(point1,point2):
	# √(x2-x1)2 + (y2-y1)2
	return sqrt(pow(point2[0]-point1[0],2)+pow(point2[1]-point1[1],2))/M
	




func _on_Button_pressed():
	pass


func _on_graph_button_pressed():
	$Exp1_UI/Graph_Window.popup()
	Global.GWindow_state = true
	kev.create_new_point({
	label = str(Global.v_data[0]),
	values = {
	  KE = $Car.mass * Global.v_data[0] * Global.v_data[0] * 0.5
	}
  })
	$graph_button.hide()
	clearChart()

func _on_Area2D_body_entered(body):
	$Exp1_UI/Graph_Window/Graph_Panel/Ke_vs_V.clear_curve(ke_vs_v_id)
	$Exp1_UI/Graph_Window/Graph_Panel/Pe_vs_H.clear_curve(ke_vs_v_id)
	get_tree().reload_current_scene()


func _on_Reset_button_pressed():
	get_tree().reload_current_scene()


func _on_Graph_Window_popup_hide():
	pass # Replace with function body.


func _on_Mass_Slider_value_changed(value):
	$Car.mass = value
	


func _on_CP1_body_entered(body):
	Global.h_data.append(h)
	Global.v_data.append(v)

func getCollectedHData():
	return Global.h_data

func getCollectedVData():
	return Global.v_data

func clearChart():
	kev.clear_chart()
	peh.clear_chart()
