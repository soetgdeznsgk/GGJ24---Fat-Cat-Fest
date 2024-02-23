extends Node2D

@export var jugador : int = 1
var duracionStun : int = 2

@export var comandosConFlechas : Array = []

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

var procesosPausados = false

@onready var anim = $AnimationPlayer
@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
@onready var spriteGato = $Gato

@onready var playerLabel = $NamePlayer
@onready var tmrSacarJeta = $TmrSacarJeta


var sacarJeta = true
var errorContinuo = false
var rachaGanadora = false
var comandos : Array = []
var permitirEntradas = true
var devices
var numeroMitadComida
var sfx_comer := AudioStreamPlayer.new()
var comer_flag = false
var inputArray = []
signal llegaronComandos(comandos)
signal nuevoInputRegistrado(input)
var isInputInCooldown = false

func _ready() -> void:
	sfx_comer.bus = "SFX"
	add_child(sfx_comer)
	#region SEÑALES
	Eventos.bajarTelon.connect(pausarProcesos)
	Eventos.finalEvento.connect(reanudarProcesos)
	Eventos.nuevaComida.connect(set_comandos)
	Eventos.enviarInput.connect(recibir_nuevo_input)
	#endregion
	#region CONTROLES
	if !Eventos.multiOnline:
	# Dependiendo del jugador tiene ciertas teclas para el physic process
		diccionarioInputs[Enums.Arriba] = "ArribaPj" + str(jugador)
		diccionarioInputs[Enums.Abajo]  = "AbajoPj" + str(jugador)
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj" + str(jugador)
		diccionarioInputs[Enums.Derecha] = "DerechaPj" + str(jugador)
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1" 
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1" 
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1" 
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
	#endregion
	
	#Carga dinámica de recursos basado en el personaje seleccionado
	var recursos = RecursosGatos.recursos[RecursosGatos.catSelectionP1 if jugador == 1 else \
				   						  RecursosGatos.catSelectionP2]["mainGame"]
	spriteGato.sprite_frames = recursos["anims"]
	var sprPosition = recursos["positionLeft" if jugador == 1 else "positionRight"]
	spriteGato.position.x = sprPosition[0]
	spriteGato.position.y = sprPosition[1]
	spriteGato.scale = recursos["scale"]
	spriteGato.play("loop_victoria")
	
	var sonidos = recursos["sonidos"]
	

	if jugador == 2:
		stunSonido = load("res://SFX/sonidosNoImplementadosSebastian/stun1.mp3")
		chokesonido= load("res://SFX/sonidosNoImplementadosSebastian/buzz1.mp3")
		listaSfxComer=[load("res://SFX/nom1.mp3"),load("res://SFX/nom2.mp3"),\
		load("res://SFX/nom3.mp3"),load("res://SFX/nom4.mp3"),\
		load("res://SFX/nom5.mp3"),load("res://SFX/nom6.mp3"),
		load("res://SFX/nom7.mp3")]
		listaSfxAcabarPlato = [load("res://SFX/finalComida1.mp3"), load("res://SFX/finalComida2.mp3"),\
		load("res://SFX/finalComida3.mp3"), load("res://SFX/finalComida4.mp3")]
	else:
		stunSonido = load("res://SFX/GatoProta/dizzy.mp3")
		chokesonido= load("res://SFX/GatoProta/choke.mp3")
		listaSfxComer=[load("res://SFX/GatoProta/ÑAM1.mp3"),load("res://SFX/GatoProta/ñam2.mp3"),\
		load("res://SFX/GatoProta/ñam3.mp3"),load("res://SFX/GatoProta/ñam4.mp3"),\
		load("res://SFX/GatoProta/ñam5.mp3")]
		listaSfxAcabarPlato = [load("res://SFX/GatoProta/terminar1.mp3"), load("res://SFX/GatoProta/terminar2.mp3"),\
		load("res://SFX/GatoProta/terminar3.mp3"), load("res://SFX/GatoProta/terminar4.mp3"),load("res://SFX/GatoProta/terminar5.mp3"),\
		load("res://SFX/GatoProta/terminar6.mp3")]
		

	playerLabel.text = Names.name_player1 if jugador == 1 else Names.name_player2
	
	var playerColor = Color("#88D662") if jugador == 1 else Color("#F2DF6F")
	playerLabel.modulate = playerColor
	for i in comandoNodos:
		i.modulate = playerColor

func recibir_nuevo_input(input, jugadorARecibir):
	if jugador == jugadorARecibir:
		inputArray.append(input)

func set_comandos(numeroJugador, nuevosComandos : Array):
	#Solo actualiza si es el jugador correcto
	if numeroJugador == jugador:
		comandos = nuevosComandos.duplicate()
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
#region NO ONLINE INPUT
	if !Eventos.multiOnline:
		if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
			inputArray.append(Enums.Arriba)
			isInputInCooldown = true
			$TmrInputCooldown.start()
		elif Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
			inputArray.append(Enums.Abajo)
			isInputInCooldown = true
			$TmrInputCooldown.start()
		elif Input.is_action_just_pressed(diccionarioInputs[Enums.Izquierda]):
			inputArray.append(Enums.Izquierda)
			isInputInCooldown = true
			$TmrInputCooldown.start()
		elif Input.is_action_just_pressed(diccionarioInputs[Enums.Derecha]):
			inputArray.append(Enums.Derecha)
			isInputInCooldown = true
			$TmrInputCooldown.start()
#endregion
#region ONLINE INPUT
	else:
		if !isInputInCooldown:
			if (multiplayer.is_server() and jugador == 1) or (!multiplayer.is_server() and jugador == 2):
				if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
					Eventos.nuevoInputRegistrado.emit(Enums.Arriba, jugador)
					isInputInCooldown = true
					$TmrInputCooldown.start()
				elif Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
					Eventos.nuevoInputRegistrado.emit(Enums.Abajo, jugador)
					isInputInCooldown = true
					$TmrInputCooldown.start()
				elif Input.is_action_just_pressed(diccionarioInputs[Enums.Izquierda]):
					Eventos.nuevoInputRegistrado.emit(Enums.Izquierda, jugador)
					isInputInCooldown = true
					$TmrInputCooldown.start()
				elif Input.is_action_just_pressed(diccionarioInputs[Enums.Derecha]):
					Eventos.nuevoInputRegistrado.emit(Enums.Derecha, jugador)
					isInputInCooldown = true
					$TmrInputCooldown.start()
#endregion
		
	# Si está spameando entonces va mas rápido la animación
	if inputArray.size() > 0 and anim.is_playing() \
	and anim.assigned_animation == "scroll_izquierda" and rachaGanadora:
		anim.speed_scale = 4
	# Si ya no hay buffer vuelve la animación a ser lenta
	if inputArray.size() == 0 and anim.assigned_animation == "scroll_izquierda":
		anim.speed_scale = 1
	# Acá es donde verifica si quedan comandos en la lista y verifica justo cuando
	# lo permita la entrada según el buffer
	if comandosConFlechas.size() > 0:
		if inputArray.size() > 0 and permitirEntradas:
			var ult = inputArray.pop_front()
			verificarCorrecta(ult)
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
		procesosPausados = true
		await get_tree().create_timer(.5).timeout
		if (!Eventos.isThereAnEvent): procesosPausados = false
		spriteGato.play("idle")

func reemplazarTexturas():
	comandos.pop_front()
	comandosConFlechas.pop_front()
	for i in range(3):
		var texture = null
		if comandosConFlechas.size() > i:
			texture = listaTexturas[comandosConFlechas[i]]
		comandoNodos[i].texture = texture
			
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
		anim.speed_scale = 0.6
		anim.queue("error_flecha")
		errorContinuo = true
	else: # lo demora menos si se equivocó en el mismo
		anim.speed_scale = 1.1
		anim.queue("error_flecha")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scroll_izquierda":
		reemplazarTexturas()
		errorContinuo = false
		rachaGanadora = true
		permitirEntradas = true
	elif anim_name == "error_flecha":
		anim.speed_scale = 1
		permitirEntradas = true

func pausarProcesos():
	Eventos.isThereAnEvent = true
	procesosPausados = true
	spriteGato.visible = false
	for i in comandoNodos:
		i.visible = false

func reanudarProcesos(ganador):
	# Esperar que el telon se vaya
	await get_tree().create_timer(3).timeout
	Eventos.isThereAnEvent = false
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

func _on_tmr_input_cooldown_timeout() -> void:
	isInputInCooldown = false

func _on_gato_animation_finished():
	if(spriteGato.animation == "comer_normal"):
		spriteGato.play("idle")
	elif (spriteGato.animation == "comer_finish"):
		spriteGato.play("idle")
	elif (spriteGato.animation == "comer_fast"):
		spriteGato.play("comer_finish")

