extends Node2D

@export var jugador = 1
var diccionarioInputs := {}
var listaTexturas = [ load("res://Sprites/Comandos/flechaArriba.png"), \
load("res://Sprites/Comandos/FlechaAbajo.png"), \
load("res://Sprites/Comandos/FlechaIzquierda.png"), \
load("res://Sprites/Comandos/FlechaDerecha.png") ]
var listaSfxComer 
var listaSfxAcabarPlato
var ultimoNom
var ultimoAcabarPlato
var chokesonido
var stunSonido

@export var duracionStun = 2
var ultimoInputRegistrado = null
var procesosPausados = false
@onready var anim = $AnimationPlayer
@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
@export var spriteGato : AnimatedSprite2D  
@onready var tmrSacarJeta = $TmrSacarJeta
var sacarJeta = true
var errorContinuo = false
var rachaGanadora = false
var comandos : Array = []
var comandosConFlechas : Array = []
var permitirEntradas = true
var devices
var numeroMitadComida
var sfx_comer := AudioStreamPlayer.new()
var comer_flag


func _ready() -> void:
	comer_flag = false
	sfx_comer.bus = "SFX"
	add_child(sfx_comer)
	#Señales
	Eventos.bajarTelon.connect(pausarProcesos)
	Eventos.finalEvento.connect(reanudarProcesos)
	Eventos.nuevaComida.connect(set_comandos)
	spriteGato.play("idle")
	
	# Dependiendo del jugador tiene ciertas teclas para el physic process
	diccionarioInputs[Enums.Arriba] = "ArribaPj" + str(jugador)
	diccionarioInputs[Enums.Abajo]  = "AbajoPj" + str(jugador)
	diccionarioInputs[Enums.Izquierda] = "IzquierdaPj" + str(jugador)
	diccionarioInputs[Enums.Derecha] = "DerechaPj" + str(jugador)
	
	if jugador == 2:
		stunSonido = load("res://SFX/sonidosNoImplementadosSebastian/stun1.mp3")
		chokesonido= load("res://Escenas/Maingame/sfx/buzz1.mp3")
		listaSfxComer=[load("res://SFX/nom1.mp3"),load("res://SFX/nom2.mp3"),\
		load("res://SFX/nom3.mp3"),load("res://SFX/nom4.mp3"),\
		load("res://SFX/nom5.mp3"),load("res://SFX/nom6.mp3"),
		load("res://SFX/nom7.mp3")]
		listaSfxAcabarPlato = [load("res://SFX/finalComida1.mp3"), load("res://SFX/finalComida2.mp3"),\
		load("res://SFX/finalComida3.mp3"), load("res://SFX/finalComida4.mp3")]
		$NamePlayer.modulate = Color("#F2DF6F")
		for i in comandoNodos:
			i.modulate = Color("#F2DF6F")

	else:
		stunSonido = load("res://SFX/GatoProta/dizzy.mp3")
		chokesonido= load("res://SFX/GatoProta/choke.mp3")
		listaSfxComer=[load("res://SFX/GatoProta/ÑAM1.mp3"),load("res://SFX/GatoProta/ñam2.mp3"),\
		load("res://SFX/GatoProta/ñam3.mp3"),load("res://SFX/GatoProta/ñam4.mp3"),\
		load("res://SFX/GatoProta/ñam5.mp3")]
		listaSfxAcabarPlato = [load("res://SFX/GatoProta/terminar1.mp3"), load("res://SFX/GatoProta/terminar2.mp3"),\
		load("res://SFX/GatoProta/terminar3.mp3"), load("res://SFX/GatoProta/terminar4.mp3"),load("res://SFX/GatoProta/terminar5.mp3"),\
		load("res://SFX/GatoProta/terminar6.mp3")]
		$NamePlayer.modulate = Color("#88D662")
		for i in comandoNodos:
			i.modulate = Color("#88D662")

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
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):# or (jugador == 2 and Input.is_action_pressed(diccionarioInputs[Enums.Arriba]) and Eventos.singleplayer):
		ultimoInputRegistrado = Enums.Arriba
	elif Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):# or (jugador == 2 and Input.is_action_pressed(diccionarioInputs[Enums.Abajo]) and Eventos.singleplayer):
		ultimoInputRegistrado = Enums.Abajo
	elif Input.is_action_just_pressed(diccionarioInputs[Enums.Izquierda]):# or (jugador == 2 and Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]) and Eventos.singleplayer):
		ultimoInputRegistrado = Enums.Izquierda
	elif Input.is_action_just_pressed(diccionarioInputs[Enums.Derecha]):# or (jugador == 2 and Input.is_action_pressed(diccionarioInputs[Enums.Derecha]) and Eventos.singleplayer):
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
		var sfxRand
		if comandosConFlechas.size() > 1:
			sfxRand = listaSfxComer.pick_random()
			while sfxRand == ultimoNom:
				sfxRand = listaSfxComer.pick_random()
			sfx_comer.stream = sfxRand
			ultimoNom = sfxRand
		else:
			sfxRand = listaSfxAcabarPlato.pick_random()
			while sfxRand == ultimoAcabarPlato:
				sfxRand = listaSfxAcabarPlato.pick_random()
			sfx_comer.stream = sfxRand
			ultimoAcabarPlato = sfxRand
			
		# Spam
		if !sacarJeta:
			spriteGato.play("comer_fast")
			tmrSacarJeta.start(0.3)
		else:
			spriteGato.play("comer_normal")
			tmrSacarJeta.start(0.3)
			sacarJeta = false
			
		sfx_comer.play()
		actualizar_flechas()
	else:
		sfx_comer.stream = chokesonido
		spriteGato.play("choke")
		sfx_comer.play()
		error_flechas()
		await get_tree().create_timer(.5).timeout
		spriteGato.play("idle")

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
		spriteGato.play("idle")
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

func pausarProcesos():
	procesosPausados = true
	spriteGato.visible = false
	for i in comandoNodos:
		i.visible = false

func reanudarProcesos(ganador):
	# Esperar que el telon se vaya
	await get_tree().create_timer(3).timeout
	#Si se stunea:
	if ganador == jugador or ganador == 0:
		procesosPausados = false
		spriteGato.visible = true
		for i in comandoNodos.size()-1:
			comandoNodos[i].visible = true
	else:
		spriteGato.visible = true
		sfx_comer.stream = stunSonido
		sfx_comer.play()
		spriteGato.play("begin_stun")
		await get_tree().create_timer(.2).timeout
		spriteGato.play("loop_stun")
		await get_tree().create_timer(duracionStun).timeout
		spriteGato.play("idle")
		procesosPausados = false
		for i in comandoNodos.size()-1:
			comandoNodos[i].visible = true


func _on_tmr_sacar_jeta_timeout() -> void:
	sacarJeta = true
	spriteGato.play("loop_comer")
