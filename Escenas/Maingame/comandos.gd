extends Node2D

@export var jugador = 1
var diccionario := {}
var textureList = [ load("res://Sprites/Comandos/flechaArriba.png"), \
load("res://Sprites/Comandos/FlechaAbajo.png"), \
load("res://Sprites/Comandos/FlechaIzquierda.png"), \
load("res://Sprites/Comandos/FlechaDerecha.png") ]

@onready var anim = $AnimationPlayer
@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
var comandos : Array = []
var esperarError := false
var comandosConFlechas : Array = []
enum {
	Arriba,
	Abajo,
	Izquierda,
	Derecha
}

func _ready() -> void:
	# Dependiendo del jugador tiene ciertas teclas para el physic process
	if jugador == 1:
		diccionario[Arriba] = "ArribaPj1"
		diccionario[Abajo] = "AbajoPj1"
		diccionario[Izquierda] = "IzquierdaPj1"
		diccionario[Derecha] = "DerechaPj1"
	else:
		diccionario[Arriba] = "ArribaPj2"
		diccionario[Abajo]  = "AbajoPj2"
		diccionario[Izquierda] = "IzquierdaPj2"
		diccionario[Derecha] = "DerechaPj2"
		
	# deberian llegar en la comida
	comandos = [Arriba,Abajo,Izquierda,Derecha,Arriba,Abajo,Izquierda,Derecha]
	comandosConFlechas = [Arriba,Abajo,Izquierda,Derecha,Arriba,Abajo,Izquierda,Derecha]
	for i in range(3):
		var ultimo = comandos.pop_front()
		comandoNodos[i].texture = textureList[ultimo]

func _physics_process(delta: float) -> void:
	# Quiza falta input buffering
	# Lo hace bien
	if comandosConFlechas.size() > 0:
		if !esperarError:
			var correcta = comandosConFlechas[0]
			if Input.is_action_just_pressed(diccionario[Arriba]):
				if correcta == Arriba:
					comandosConFlechas.pop_front()
					if anim.is_playing():
						animacionRapida()
					actualizar_flechas()
				else:
					error_flechas()
			elif Input.is_action_just_pressed(diccionario[Abajo]):
				if correcta == Abajo:
					comandosConFlechas.pop_front()
					if anim.is_playing():
						animacionRapida()
					actualizar_flechas()
				else:
					error_flechas()
			elif Input.is_action_just_pressed(diccionario[Izquierda]):
				if correcta == Izquierda:
					comandosConFlechas.pop_front()
					print(comandosConFlechas)
					if anim.is_playing():
						animacionRapida()
					actualizar_flechas()
				else:
					error_flechas()
			elif Input.is_action_just_pressed(diccionario[Derecha]):
				if correcta == Derecha:
					comandosConFlechas.pop_front()
					if anim.is_playing():
						animacionRapida()
					actualizar_flechas()
				else:
					error_flechas()
			

func animacionRapida():
	anim.stop()
	anim.play("RESET")
	comandoNodos[0].texture = comandoNodos[1].texture
	comandoNodos[1].texture = comandoNodos[2].texture
	comandoNodos[2].texture = comandoNodos[3].texture
	for i in comandoNodos.size():
		comandoNodos[i].position = Vector2((i+1)*128, 51)
		comandoNodos[i].self_modulate = Color(1,1,1,1)

func actualizar_flechas():
	if comandos.size() > 0:
		var ultimo = comandos.pop_front()
		comandoNodos[3].texture = textureList[ultimo]
	else:
		var ultimo = null
		comandoNodos[3].texture = null
	if anim.is_playing():
		anim.play("scroll_izquierda",-1,5)
	else:
		anim.play("scroll_izquierda",-1,1)

func error_flechas():
	esperarError = true
	if anim.is_playing():
		anim.speed_scale = 5
		await anim.animation_finished 
		anim.speed_scale = 0.3
		anim.play("error_flecha")
	else:
		anim.speed_scale = 0.7
		anim.play("error_flecha")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scroll_izquierda":
		comandoNodos[0].texture = comandoNodos[1].texture
		comandoNodos[1].texture = comandoNodos[2].texture
		comandoNodos[2].texture = comandoNodos[3].texture
		for i in comandoNodos.size():
			comandoNodos[i].position = Vector2((i+1)*128, 51)
			comandoNodos[i].self_modulate = Color(1,1,1,1)
	if anim_name == "error_flecha":
		esperarError = false
		anim.speed_scale = 1
			
	
	
