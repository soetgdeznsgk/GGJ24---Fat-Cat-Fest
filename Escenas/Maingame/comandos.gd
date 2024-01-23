extends Node2D

@export var jugador = 1
var diccionario := {}
var listaTexturas = [ load("res://Sprites/Comandos/flechaArriba.png"), \
load("res://Sprites/Comandos/FlechaAbajo.png"), \
load("res://Sprites/Comandos/FlechaIzquierda.png"), \
load("res://Sprites/Comandos/FlechaDerecha.png") ]

var ultimoInputRegistrado = null

@onready var anim = $AnimationPlayer
@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
var comandos : Array = []
var comandosConFlechas : Array = []
var permitirEntradas = true
var devices
func _ready() -> void:
	# Dependiendo del jugador tiene ciertas teclas para el physic process
	if jugador == 1:
		diccionario[Enums.Arriba] = "ArribaPj1"
		diccionario[Enums.Abajo] = "AbajoPj1"
		diccionario[Enums.Izquierda] = "IzquierdaPj1"
		diccionario[Enums.Derecha] = "DerechaPj1"
	else:
		diccionario[Enums.Arriba] = "ArribaPj2"
		diccionario[Enums.Abajo]  = "AbajoPj2"
		diccionario[Enums.Izquierda] = "IzquierdaPj2"
		diccionario[Enums.Derecha] = "DerechaPj2"
		
	# TODO deberian llegar en la comida
	comandos = [Enums.Arriba,Enums.Abajo,Enums.Izquierda,Enums.Derecha]
	comandosConFlechas = [Enums.Arriba,Enums.Abajo,Enums.Izquierda,Enums.Derecha]
	
	# Colocar las primeras 3 flechas que llegan de la comida
	for i in range(3):
		var ultimo = comandos.pop_front()
		comandoNodos[i].texture = listaTexturas[ultimo]

func _physics_process(_delta: float) -> void:
	# Input buffering para teclado
	if Input.is_action_just_pressed(diccionario[Enums.Arriba]):
		ultimoInputRegistrado = Enums.Arriba
	elif Input.is_action_just_pressed(diccionario[Enums.Abajo]):
		ultimoInputRegistrado = Enums.Abajo
	elif Input.is_action_just_pressed(diccionario[Enums.Izquierda]):
		ultimoInputRegistrado = Enums.Izquierda
	elif Input.is_action_just_pressed(diccionario[Enums.Derecha]):
		ultimoInputRegistrado = Enums.Derecha
	
	
	# Si está spameando entonces va mas rápido la animación
	if ultimoInputRegistrado != null and anim.is_playing() \
	and anim.assigned_animation == "scroll_izquierda":
		anim.speed_scale = 4
	# Si ya no hay buffer vuelve la animación a ser lenta
	if ultimoInputRegistrado == null and anim.assigned_animation == "scroll_izquierda":
		anim.speed_scale = 1
	# Acá es donde verifica si quedan comandos en la lista y verifica justo cuando
	# lo permita la entrada según el buffer
	if comandosConFlechas.size() > 0:
		if ultimoInputRegistrado != null and permitirEntradas:
			verificarCorrecta(ultimoInputRegistrado)
			ultimoInputRegistrado = null
			permitirEntradas = false
			

func verificarCorrecta(Direccion):
	var correcta = comandosConFlechas[0]
	if correcta == Direccion:
		actualizar_flechas()
	else:
		error_flechas()

func reemplazarTexturas():
	comandos.pop_front()
	comandosConFlechas.pop_front()
	comandoNodos[0].texture = comandoNodos[1].texture
	comandoNodos[1].texture = comandoNodos[2].texture
	comandoNodos[2].texture = comandoNodos[3].texture
	for i in comandoNodos.size():
		comandoNodos[i].position = Vector2((i+1)*128, 51)
		comandoNodos[i].self_modulate = Color(1,1,1,1)

func actualizar_flechas():
	# le pone textura a la nueva flecha por salir
	if comandos.size() > 0:
		var ultimo = comandos[0]
		comandoNodos[3].texture = listaTexturas[ultimo]
	else:
		comandoNodos[3].texture = null
	anim.play("scroll_izquierda")

func error_flechas():
	# Lo demora arto si se equivocó de manera greedy
	if anim.is_playing():
		anim.speed_scale = 5
		await anim.animation_finished 
		anim.speed_scale = 0.3
		anim.queue("error_flecha")
	else: # lo demora menos si se equivocó en el mismo
		anim.speed_scale = 0.7
		anim.queue("error_flecha")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scroll_izquierda":
		reemplazarTexturas()
	elif anim_name == "error_flecha":
		anim.speed_scale = 1
	permitirEntradas = true
	

