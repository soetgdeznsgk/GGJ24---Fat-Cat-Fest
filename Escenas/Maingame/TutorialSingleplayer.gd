extends Node2D

var bg_music_tutorial:= AudioStreamPlayer.new()
@export var animationPlayador:AnimationPlayer
@export var pantallprogamerproooo:AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayador.play("iniciotutorialprogamer")
	pantallprogamerproooo.play("SinglePlayer")
	bg_music_tutorial.stream = load("res://Musica/tfcf_plato_v2.wav")
	bg_music_tutorial.autoplay = true
	bg_music_tutorial.bus = "Music"
	add_child(bg_music_tutorial)

func pasandoaltutorial():
	animationPlayador.play("eneltutorial")
func pasandoalfinal():
	animationPlayador.play("adios_tutorialprogamer")

func _on_animation_player_animation_finished(anim_name):
	Eventos.tutorialSingleplayerHecho = true
	get_tree().change_scene_to_file("res://Escenas/Maingame/Maingame.tscn")
