extends Node2D

var soundQueue = []

var resourcesP1 
var resourcesP2 

@onready var gato1 = $Gato1
@onready var gato2 = $Gato2

func _ready() -> void:
	resourcesP1 = RecursosGatos.recursos[RecursosGatos.catSelectionP1 if Eventos.ganador == 1 \
										 else RecursosGatos.catSelectionP2]["winnerScreen"]
	
	resourcesP2 = RecursosGatos.recursos[RecursosGatos.catSelectionP2 if Eventos.ganador == 1 \
										 else RecursosGatos.catSelectionP1]["winnerScreen"]
	
	gato1.sprite_frames = resourcesP1["anims"]
	gato1.position = resourcesP1["posWinner"]
	gato1.scale = resourcesP1["scaleWinner"]
	gato1.play("begin_victoria")
	
	gato2.sprite_frames = resourcesP2["anims"]
	gato2.position = resourcesP2["posLoser"]
	gato2.scale = resourcesP2["scaleLoser"]
	gato2.play("begin_derrota")
	
	$AnimationPlayer.play("mostrar_ganador")
	$Label.text = "WINNER OF CAT FAST FEST IS ... " + Names.name_player1 if Eventos.ganador == 1 else Names.name_player2
	$LabelNombre.text = Names.name_player1 if Eventos.ganador == 1 else Names.name_player2
	$LabelNombre.modulate = Color("#88D662") if Eventos.ganador == 1 else Color("#F2DF6F")
	
	soundQueue.append(load(Names.dirAudioInitial1 if Eventos.ganador == 1 else Names.dirAudioInitial2))
	soundQueue.append(load(Names.dirAudioFinal1 if Eventos.ganador == 1 else Names.dirAudioFinal2))
	soundQueue.append(resourcesP1["soundsWinner"].pick_random())
	#soundQueue.append(resourcesP2["soundsLoser"].pick_random())
	
	$AudioStreamPlayer.stream = soundQueue.pop_front()
	$AudioStreamPlayer.play()

func cheer(prob : float):
	Eventos.catCheer.emit(prob)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menus/main.tscn")
	Eventos.ganador = 0
	queue_free()

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.stream = soundQueue.pop_front()
	$AudioStreamPlayer.play()

func _on_gato_1_animation_finished():
	if gato1.animation == "begin_victoria": gato1.play("loop_victoria")
	if gato1.animation == "begin_derrota": gato1.play("loop_derrota")

func _on_gato_2_animation_finished():
	if gato2.animation == "begin_victoria": gato2.play("loop_victoria")
	if gato2.animation == "begin_derrota": gato2.play("loop_derrota")
