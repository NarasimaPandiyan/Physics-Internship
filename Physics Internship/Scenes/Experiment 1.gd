extends Node2D

#car 
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

var v_data = []
var h_data = []
var ke_data = []
var pe_data = []

var table: TableManager.Table
var tablePlugin: TableManager.Plugin

onready var kev = $"Exp1_UI/Graph_Window/Graph_Panel/KE vs v"
onready var kevm = $"Exp1_UI/Graph_Window/Graph_Panel/KE vs v_m"
onready var peh = $"Exp1_UI/Graph_Window/Graph_Panel/PE vs h"

func _ready():
	if Global.GWindow_state:
		$Exp1_UI/Graph_Window.popup()
	wheels = get_tree().get_nodes_in_group("Wheel")
	
	tablePlugin = $Exp1_UI/Graph_Window/Data_Panel/Table
	var colDefs = {
		"v":{
			"columnId": "v",
			"columnName": "v",
			"columnType": TableConstants.ColumnType.LABEL,
						"columnAlign": TableConstants.Align.CENTER
		},
		"h":{
			"columnId": "ke",
			"columnName": "KE",
			"columnType": TableConstants.ColumnType.LABEL,
						"columnAlign": TableConstants.Align.CENTER
		},
		
	}	
	
	var tblConfig = TableManager.createTableConfig(colDefs)
	table = TableManager.createTable(tablePlugin, tblConfig)
	TableManager.setTableData(table, Global.data)
	# TODO print(tablePlugin.to_string())
	
func _physics_process(_delta):
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
	Global.mass = $Car.mass
	drawScatterKE(kev,Global.mass)
	drawScatterKE(kevm,Global.mass)
	$graph_button.hide()


func _on_Area2D_body_entered(body):
	if (len(Global.v_data) == 0): 
		Global.v_data = v_data
		Global.ke_data = ke_data
	else:	
		Global.ke_data = []
		Global.ke_data = []
	get_tree().reload_current_scene()
	

func _on_Reset_button_pressed():
	get_tree().reload_current_scene()


func _on_Graph_Window_popup_hide():
	pass # Replace with function body.

func _on_CP1_body_entered(body):
	h_data.append(h)
	v_data.append(v)
	ke_data.append(calcKE(m,v))
	Global.data.append({
		"ke" : str(round(calcKE(m,v))),
		"v" : str(round(v))
	})
	
func getCollectedHData():
	return Global.h_data

func getCollectedVData():
	return Global.v_data

func calcKE(mm,vv):
	return mm*vv*vv*0.5

func drawScatterKE(chart,mass):
	chart.clear_chart()
	chart.create_new_point({
	label = str(Global.v_data[0]),
	values = {
		 KE = calcKE(mass,Global.v_data[0])
	}})
	chart.create_new_point({
	label = str(Global.v_data[1]),
	values = {
		 KE = calcKE(mass,Global.v_data[1])
	}})
	chart.create_new_point({
	label = str(Global.v_data[2]),
	values = {
		 KE = calcKE(mass,Global.v_data[2])
	}})
	chart.create_new_point({
	label = str(Global.v_data[3]),
	values = {
		 KE = calcKE(mass,Global.v_data[3])
	}})
	chart.create_new_point({
	label = str(Global.v_data[4]),
	values = {
		 KE = calcKE(mass,Global.v_data[4])
	}})
	chart.create_new_point({
	label = str(Global.v_data[5]),
	values = {
		 KE = calcKE(mass,Global.v_data[5])
	}})
	chart.create_new_point({
	label = str(Global.v_data[6]),
	values = {
		 KE = calcKE(mass,Global.v_data[6])
	}})
	chart.create_new_point({
	label = str(Global.v_data[7]),
	values = {
		 KE = calcKE(mass,Global.v_data[7])
	}})
	chart.create_new_point({
	label = str(Global.v_data[8]),
	values = {
		 KE = calcKE(mass,Global.v_data[8])
	}})
	chart.create_new_point({
	label = str(Global.v_data[9]),
	values = {
		 KE = calcKE(mass,Global.v_data[9])
	}})
	print(str(Global.ke_data)+"\n\n"+str(Global.v_data)+"\n\n")

