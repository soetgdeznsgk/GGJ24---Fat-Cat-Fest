extends Node2D

var soundQueue = []

func _ready() -> void:
	$AnimationPlayer.play("mostrar_ganador")
	if Eventos.ganador == 1:
		$Label.text = "WINNER OF CAT FAST FEST IS ... " + Names.name_player1
		$LabelNombre.text = Names.name_player1
		$Gato1.play("begin_victoria")
		$Gato2.play("begin_derrota")
		await get_tree().create_timer(.2).timeout
		$Gato1.play("loop_victoria")
		$Gato2.play("loop_derrota")
		soundQueue.append(load(Names.dirAudioInitial1))
		soundQueue.append(load(Names.dirAudioFinal1))
		$AudioStreamPlayer.stream = soundQueue.pop_front()
		$AudioStreamPlayer.play()
	elif Eventos.ganador == 2:
		$Label.text = "WINNER OF CAT FAST FEST IS ... " + Names.name_player2
		$LabelNombre.text = Names.name_player2
		$Gato1.position = Vector2(902,435)
		$Gato1.scale = Vector2(0.367,0.367)
		$Gato2.position = Vector2(677,365)
		$Gato2.scale = Vector2(0.7,0.7)
		$Gato1.play("begin_derrota")
		$Gato2.play("begin_victoria")
		await get_tree().create_timer(.2).timeout
		$Gato1.play("loop_derrota")
		$Gato2.play("loop_victoria")
		soundQueue.append(load(Names.dirAudioInitial2))
		soundQueue.append(load(Names.dirAudioFinal2))
		$AudioStreamPlayer.stream = soundQueue.pop_front()
		$AudioStreamPlayer.play()
func _process(delta: float) -> void:
	pass

func cheer(prob : float):
	Eventos.catCheer.emit(prob)

func set_sfx_random_anuncia():
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menus/menu_principal.tscn")

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.stream = soundQueue.pop_front()
	$AudioStreamPlayer.play()
