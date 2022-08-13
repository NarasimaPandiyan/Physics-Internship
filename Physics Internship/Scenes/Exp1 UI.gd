extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_b_toggle_toggled(button_pressed):
	pass # Replace with function body.


func _on_Reset_button_pressed():
	get_tree().reload_current_scene()
	get_parent().reload()


func _on_Start_button_pressed():
	get_parent().stopper(false)
