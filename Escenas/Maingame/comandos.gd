extends Node2D

@export var jugador = 1
var diccionarioInputs := {}
var listaTexturas = [ load("res://Sprites/Comandos/flechaArriba.png"), \
load("res://Sprites/Comandos/FlechaAbajo.png"), \
load("res://Sprites/Comandos/FlechaIzquierda.png"), \
load("res://Sprites/Comandos/FlechaDerecha.png") ]

var ultimoInputRegistrado = null
var procesosPausados = false
@onready var anim = $AnimationPlayer
@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
var errorContinuo = false
var rachaGanadora = false
var comandos : Array = []
var comandosConFlechas : Array = []
var permitirEntradas = true
var devices
var numeroMitadComida
var sfx_comer := AudioStreamPlayer.new()


func _ready() -> void:
	sfx_comer.bus = "SFX"
	add_child(sfx_comer)
	#Señales
	Eventos.nuevoEvento.connect(pausarProcesos)
	Eventos.finalEvento.connect(reanudarProcesos)
	Eventos.nuevaComida.connect(set_comandos)
	
	# Dependiendo del jugador tiene ciertas teclas para el physic process
	if jugador == 1:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj2"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj2"
		diccionarioInputs[Enums.Derecha] = "DerechaPj2"
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo] = "AbajoPj1"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"

func set_comandos(numeroJugador, nuevosComandos : Array):
	#Solo actualiza si es el jugador correcot
	if numeroJugador == jugador:
		comandos = nuevosComandos
		comandosConFlechas = nuevosComandos.duplicate()
		numeroMitadComida = ceili(nuevosComandos.size() / 2)
		# Colocar las primeras 3 flechas que llegan de la comida
		for i in range(3):
			var ultimo = comandos.pop_front()
			comandoNodos[i].texture = listaTexturas[ultimo]

func _physics_process(_delta: float) -> void:
	if procesosPausados:
		return
	# Input buffering
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
		ultimoInputRegistrado = Enums.Arriba
	elif Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
		ultimoInputRegistrado = Enums.Abajo
	elif Input.is_action_just_pressed(diccionarioInputs[Enums.Izquierda]):
		ultimoInputRegistrado = Enums.Izquierda
	elif Input.is_action_just_pressed(diccionarioInputs[Enums.Derecha]):
		ultimoInputRegistrado = Enums.Derecha
	# Si está spameando entonces va mas rápido la animación
	if ultimoInputRegistrado != null and anim.is_playing() \
	and anim.assigned_animation == "scroll_izquierda" and rachaGanadora:
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

func verificarCorrecta(Direccion : int): #ésta función no se está llamando siempre que la CPU presiona tecla
	if comandosConFlechas[0] == Direccion:
		sfx_comer.stream = load("res://Escenas/Maingame/sfx/potatoñam.mp3")
		sfx_comer.play()
		actualizar_flechas()
	else:
		sfx_comer.stream = load("res://Escenas/Maingame/sfx/buzzer.mp3")
		sfx_comer.play()
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
	

	if comandosConFlechas.size() == numeroMitadComida:
		Eventos.mediaComida.emit(jugador)
	elif comandosConFlechas.size() == 3:
		Eventos.comidaAPuntoDeTerminar.emit(jugador)
	elif comandosConFlechas.size() == 0:
		# Emitir que ya se comió todo
		Eventos.comandosAcabados.emit(jugador)
		

func actualizar_flechas():
	# le pone textura a la nueva flecha por salir
	if comandos.size() > 0:
		var ultimo = comandos[0]
		comandoNodos[3].texture = listaTexturas[ultimo]
	else:
		comandoNodos[3].texture = null
	anim.play("scroll_izquierda")

func error_flechas():
	rachaGanadora =false
	# Lo demora arto si se equivocó de manera greedy
	if !errorContinuo:
		anim.speed_scale = 0.2
		anim.queue("error_flecha")
		errorContinuo = true
	else: # lo demora menos si se equivocó en el mismo
		anim.speed_scale = 0.8
		anim.queue("error_flecha")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scroll_izquierda":
		reemplazarTexturas()
		errorContinuo = false
		rachaGanadora = true
	elif anim_name == "error_flecha":
		anim.speed_scale = 1
	permitirEntradas = true

func pausarProcesos(_cache):
	procesosPausados = true
	visible = false

func reanudarProcesos(_ganador):
	await get_tree().create_timer(3).timeout
	procesosPausados = false
	visible = true
