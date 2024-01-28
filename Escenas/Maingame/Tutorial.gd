extends Node2D

var bg_music_tutorial:= AudioStreamPlayer.new()
@export var animationPlayador:AnimationPlayer
@export var pantallprogamerproooo:AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayador.play("tutorialprogamer")
	if Eventos.singleplayer:
		pantallprogamerproooo.play("SinglePlayer")
		print("tamos solitos")
	else:
		pantallprogamerproooo.play("MultiPlayer")
		print("tamos no solitos")
	bg_music_tutorial.stream = load("res://Musica/tfcf_plato_v2.wav")
	bg_music_tutorial.autoplay = true
	bg_music_tutorial.bus = "Music"
	add_child(bg_music_tutorial)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
