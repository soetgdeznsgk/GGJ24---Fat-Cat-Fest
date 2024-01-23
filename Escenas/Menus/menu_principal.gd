extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")

func _on_play_button_mouse_entered():
	pass # Replace with function body.


func _on_play_button_mouse_exited():
	pass # Replace with function body.


func _on_option_button_pressed():
	pass # Replace with function body.


func _on_option_button_mouse_entered():
	pass # Replace with function body.


func _on_option_button_mouse_exited():
	pass # Replace with function body.


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_credits_button_mouse_entered():
	pass # Replace with function body.


func _on_credits_button_mouse_exited():
	pass # Replace with function body.
