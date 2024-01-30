extends Node2D

@onready var anim = $AnimationPlayer
@onready var arrowp1 = $arrowP1
@onready var arrowp2 = $arrowP2
@onready var sprGato1 = $Gato
@onready var sprGato2 = $Gato2
@onready var sprBomba = $SprBomba

var lista_random_sfx_boom = [preload("res://Escenas/Eventos/pepino/sfx/explosion1.mp3"), preload("res://Escenas/Eventos/pepino/sfx/explosion2.mp3"),\
 preload("res://Escenas/Eventos/pepino/sfx/explosion3.mp3")]

var ganador
var finished = false

var bombPos = null
enum {LEFT,RIGHT}
var speed = 0.55

func _ready():
	$Label.modulate = Color("#88D662")
	$Label.text = Names.name_player1
	$Label2.modulate = Color("#F2DF6F")
	$Label2.text = Names.name_player2
	var tiempoExplox = randi_range(5,10)
	$TimerExplosion.start(tiempoExplox)
	$TimerPepinoAudioAcel.start(tiempoExplox - 1.5)
	sprGato1.play("idle_loop")
	sprGato2.play("idle_loop")
	if randf() < 0.5:
		arrowp2.visible=false
		arrowp1.visible=true
		# Play your animation
		anim.play("spawn_left")
		await get_tree().create_timer(.8).timeout
		sprGato1.play("arriveth")
		sprGato2.play("idle_loop")
		bombPos = LEFT

	else:
		arrowp1.visible=false
		arrowp2.visible=true
		# Do something else or don't play the animation
		anim.play("spawn_right")
		await get_tree().create_timer(.8).timeout
		sprGato2.play("arriveth")
		sprGato1.play("idle_loop")
		bombPos = RIGHT

func _physics_process(_delta: float) -> void:
	if !finished:
		if bombPos==LEFT and !anim.is_playing() and Input.is_action_just_pressed("DerechaPj1"):
			anim.play("swipe_right", -1 , randf_range(0,0.3) + speed)
			sprGato1.play("leaveth")
			bombPos=RIGHT
			speed += 0.13
			arrowp1.visible=false
			await get_tree().create_timer(1.5-speed).timeout
			sprGato2.play("its_here")
			arrowp2.visible=true
			sprBomba.speed_scale = randi_range(1,4)
			sprBomba.play("default")
		if (Input.is_action_just_pressed("IzquierdaPj2") or (Eventos.singleplayer and Input.is_action_pressed("IzquierdaPj2") ) )  and bombPos==RIGHT and !anim.is_playing():
			anim.play("swipe_left" ,-1 ,randf_range(0,0.3) + speed)
			sprGato2.play("leaveth")
			bombPos=LEFT
			speed += 0.13
			arrowp2.visible=false
			await get_tree().create_timer(1-speed).timeout
			sprGato1.play("its_here")
			arrowp1.visible=true
			sprBomba.speed_scale = randi_range(1,4)
			sprBomba.play("default")

func _on_timer_final_evento_timeout():
	Eventos.finalEvento.emit(ganador)
	queue_free()	

func _on_timer_explosion_timeout():
	$AudioStreamPlayer.stream = lista_random_sfx_boom.pick_random()
	$AudioStreamPlayer.play()
	$piptimer.stop()
	$TimerFinalEvento.start(3)
	finished = true 
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

func _on_timer_pepino_audio_acel_timeout() -> void:
	$piptimer.wait_time = 0.4


func _on_piptimer_timeout() -> void:
	$PepinoPipipi.play()
	$piptimer.start()
