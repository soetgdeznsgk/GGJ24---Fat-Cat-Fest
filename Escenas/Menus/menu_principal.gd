extends Control

var bg_music := AudioStreamPlayer.new()
var noMouse = false
var mousePos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.stream = load("res://Escenas/Menus/Musik/Warped-Alien-Band_Looping.mp3")
	bg_music.autoplay = true
	add_child(bg_music)
	
#AÑADIR ESTO A CREDITOS EPIC MUSICA

#"Warped Alien Band"
#by Eric Matyas
#www.soundimage.org

func deviceChanged():
	if noMouse:
		$MenuPrincipal/HBoxContainer/VBoxContainer/VBoxContainer/PlayButton.grab_focus()
	else:
		$MenuPrincipal/HBoxContainer/VBoxContainer/VBoxContainer/PlayButton.release_focus()
		$MenuPrincipal/HBoxContainer/VBoxContainer/VBoxContainer/PlayButton2.release_focus()
		$MenuPrincipal/HBoxContainer/VBoxContainer/VBoxContainer/PlayButton3.release_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("AbajoPj1") and !noMouse:
		noMouse = true
		deviceChanged()
		mousePos = get_global_mouse_position()
	if Input.is_action_just_pressed("ArribaPj1") and !noMouse:
		noMouse = true
		deviceChanged()
		mousePos = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and noMouse:
		noMouse = false
		deviceChanged()
	if mousePos.distance_squared_to(get_global_mouse_position()) > 200 and noMouse:
		noMouse = false
		deviceChanged()

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
