extends Node2D

@onready var anim = $AnimationPlayer
@onready var arrowp1 = $arrowP1
@onready var arrowp2 = $arrowP2
@onready var sprGato1 = $Gato
@onready var sprGato2 = $Gato2
@onready var sprBomba = $SprBomba
@onready var audioPGatos = $AudioPlayerGatos
@onready var audioPPepino = $AudioPlayerPepino
@onready var audioPPepino2 = $AudioPlayerPepino2

var sounds_boom = Globals.loadResources("res://SFX/QuickTimeEvents/Pepino/Explosion/")
var sounds_fall = Globals.loadResources("res://SFX/QuickTimeEvents/Pepino/PepinoCae/")
var sounds_slide = Globals.loadResources("res://SFX/QuickTimeEvents/Pepino/Slide/")
var sounds_beep = Globals.loadResources("res://SFX/QuickTimeEvents/Pepino/Pitidos/")

var ganador
var finished = false

var bombPos = null
var moving = false

enum {LEFT,RIGHT}
var speed = 2
var ultimoInputRegistrado = -1
var jugador = 1

var sonidosP1
var sonidosP2

func _ready():
	$Label.modulate = Color("#88D662")
	$Label.text = Names.name_player1
	$Label2.modulate = Color("#F2DF6F")
	$Label2.text = Names.name_player2
	
	var resources = RecursosGatos.recursos
	var p1 = resources[RecursosGatos.catSelectionP1]["pepino"]
	var p2 = resources[RecursosGatos.catSelectionP2]["pepino"]
	
	sprGato1.sprite_frames = p1["anims"]
	sprGato1.position = p1["posIzq"]
	sprGato1.scale = p1["scale"]
	sonidosP1 = p1["sounds"]
	
	sprGato2.sprite_frames = p2["anims"]
	sprGato2.position = p2["posDer"]
	sprGato2.scale = p2["scale"]
	sprGato2.scale.x *= -1
	sonidosP2 = p2["sounds"]
	
	var tiempoExplox = randi_range(8,12)
	var probLado = randf()
	Eventos.enviarInput.connect(recibir_nuevo_input)
	
	if !Eventos.multiOnline:
		set_pepino_lado(tiempoExplox, probLado)
	else:
		if multiplayer.is_server():
			set_pepino_lado.rpc(tiempoExplox, probLado)
		else:
			jugador = 2

func recibir_nuevo_input(input, jugadorARecibir):
	if jugador != jugadorARecibir:
		ultimoInputRegistrado = input

@rpc("authority","call_local","reliable")
func set_pepino_lado(tiempoExplox, probLado):
	$TimerExplosion.start(tiempoExplox)
	
	sprGato1.play("idle_loop")
	sprGato2.play("idle_loop")
	
	if probLado < 0.5:
		arrowp2.visible=false
		arrowp1.visible=true
		anim.play("spawn_left")
		await get_tree().create_timer(.3).timeout
		Globals.playRandomSound(audioPPepino, sounds_fall)
		await get_tree().create_timer(.6).timeout
		$piptimer.start()
		sprGato1.play("arriveth")
		Globals.playRandomSound(audioPGatos, sonidosP1)
		sprGato2.play("idle_loop")
		bombPos = LEFT
	else:
		arrowp1.visible=false
		arrowp2.visible=true
		anim.play("spawn_right")
		await get_tree().create_timer(.3).timeout
		Globals.playRandomSound(audioPPepino, sounds_fall)
		await get_tree().create_timer(.6).timeout
		$piptimer.start()
		sprGato2.play("arriveth")
		Globals.playRandomSound(audioPGatos, sonidosP2)
		sprGato1.play("idle_loop")
		bombPos = RIGHT

	audioPPepino.stream = load("res://SFX/QuickTimeEvents/Pepino/pipLento.mp3")

func _physics_process(_delta: float) -> void:
	if !finished:
		if !Eventos.multiOnline:
			if Input.is_action_just_pressed("DerechaPj1"):
				ultimoInputRegistrado = Enums.Derecha
			if Input.is_action_just_pressed("IzquierdaPj2"):
				ultimoInputRegistrado = Enums.Izquierda
		else:
			if Input.is_action_just_pressed("DerechaPj1") and jugador == 1:
				ultimoInputRegistrado = Enums.Derecha
				Eventos.nuevoInputRegistrado.emit(ultimoInputRegistrado, jugador)
			if Input.is_action_just_pressed("IzquierdaPj1") and jugador == 2:
				ultimoInputRegistrado = Enums.Izquierda
				Eventos.nuevoInputRegistrado.emit(ultimoInputRegistrado, jugador)
			
		if bombPos==LEFT and !moving and ultimoInputRegistrado == Enums.Derecha:
			Globals.playRandomSound(audioPPepino, sounds_slide)
			moving = true
			arrowp1.visible=false
			ultimoInputRegistrado = -1
			anim.play("swipe_right", -1 , randf_range(0,1) + speed)
			sprGato1.play("leaveth")
			speed += 0.13

		if bombPos==RIGHT and !moving and ultimoInputRegistrado == Enums.Izquierda or \
		(Eventos.singleplayer and Input.is_action_pressed("IzquierdaPj2")  and bombPos==RIGHT and !anim.is_playing() ):
			Globals.playRandomSound(audioPPepino, sounds_slide)
			moving = true
			arrowp2.visible=false
			ultimoInputRegistrado = -1
			anim.play("swipe_left" ,-1 ,randf_range(0,1) + speed)
			sprGato2.play("leaveth")
			speed += 0.13
			

func bombPosChange(side):
	bombPos = side
	
func finishMoving():
	moving = false
	
	if bombPos == LEFT:
		arrowp1.visible=true
		sprGato1.play("its_here")
		Globals.playRandomSound(audioPGatos, sonidosP1)

	else: 
		arrowp2.visible=true
		sprGato2.play("its_here")
		Globals.playRandomSound(audioPGatos, sonidosP2)

	sprBomba.speed_scale = randi_range(1,4)
	sprBomba.play("default")
	

func _on_timer_final_evento_timeout():
	Eventos.finalEvento.emit(ganador)
	queue_free()

func _on_timer_explosion_timeout():
	finished = true 
	Globals.playRandomSound(audioPGatos, sounds_boom)
	$piptimer.stop()
	$TimerFinalEvento.start(3)
	sprBomba.play("boom")
	anim.play("explosion")
	arrowp1.visible=false
	arrowp2.visible=false
	# Según la bomba al final elige el ganador
	if bombPos == RIGHT:
		ganador = 1
		sprGato2.play("bomba")
	if bombPos == LEFT:
		ganador = 2
		sprGato1.play("bomba")

func _on_gato_animation_finished():
	if !finished and sprGato1.animation!="idle_loop":
		sprGato1.play("idle_loop")

func _on_gato_2_animation_finished():
	if !finished and sprGato2.animation!="idle_loop":
		sprGato2.play("idle_loop")

func _on_piptimer_timeout() -> void:
	Globals.playRandomSound(audioPPepino2, sounds_beep)
	$piptimer.wait_time = clamp(remap(speed, 2, 5, 0.6, 0.1), 0.1, 0.6)
	$piptimer.start()
