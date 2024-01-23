extends Control

var bg_music := AudioStreamPlayer.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.stream = load("res://Escenas/Menus/Musik/Warped-Alien-Band_Looping.mp3")
	bg_music.autoplay = true
	add_child(bg_music)
	
#AÑADIR ESTO A CREDITOS EPIC MUSICA

#"Warped Alien Band"
#by Eric Matyas
#www.soundimage.org


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
