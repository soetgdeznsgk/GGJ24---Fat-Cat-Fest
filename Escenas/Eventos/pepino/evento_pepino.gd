extends Node2D

@onready var anim = $AnimationPlayer
@onready var arrowp1 = $arrowP1
@onready var arrowp2 = $arrowP2

var bombPos = null
enum {LEFT,RIGHT}
var speed = 0.6

func _ready():
	$TimerFinalEvento.start(randi_range(8,15))
	if randf() < 0.5:
		# Play your animation
		anim.play("spawn_left")
		bombPos = LEFT
		arrowp2.visible=false
		arrowp1.visible=true
	else:
		# Do something else or don't play the animation
		anim.play("spawn_right")
		bombPos = RIGHT
		arrowp1.visible=false
		arrowp2.visible=true
	$Label.modulate = Color("#F2DF6F")
	$Label.text = Names.name_player1
	$Label2.modulate = Color("#88D662")
	$Label2.text = Names.name_player2
	

func _physics_process(_delta: float) -> void:
	if bombPos==LEFT and !anim.is_playing() and \
	(Input.is_action_just_pressed("DerechaPj2") or \
	(Eventos.singleplayer and Input.is_action_pressed("DerechaPj2") ) ) : # multijugador
		anim.play("swipe_right", -1 ,randf_range(0,1) + speed)
		bombPos=RIGHT
		speed += 0.2 
		arrowp1.visible=false
		arrowp2.visible=true
	if Input.is_action_just_pressed("IzquierdaPj1") and bombPos==RIGHT and !anim.is_playing():
		anim.play("swipe_left" ,-1 ,randf_range(0,1) + speed)
		bombPos=LEFT
		speed += 0.2
		arrowp2.visible=false
		arrowp1.visible=true

func _on_timer_final_evento_timeout():
	var ganador
	# Según la bomba al final elige el ganador
	if bombPos == RIGHT:
		ganador = 1
	if bombPos == LEFT:
		ganador = 2
	Eventos.finalEvento.emit(ganador)
	queue_free()
