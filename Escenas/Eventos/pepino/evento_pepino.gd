extends Node2D

@onready var anim = $AnimationPlayer
var bombPos = null
enum {LEFT,RIGHT}
var speed = 0.6

func _ready():
	$TimerFinalEvento.start(randi_range(8,15))
	if randf() < 0.5:
		# Play your animation
		anim.play("spawn_left")
		bombPos = LEFT
	else:
		# Do something else or don't play the animation
		anim.play("spawn_right")
		bombPos = RIGHT

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("DerechaPj1") and bombPos==LEFT and !anim.is_playing():
		anim.play("swipe_right", -1 ,randf_range(0,1) + speed)
		bombPos=RIGHT
		speed += 0.2
	if Input.is_action_just_pressed("IzquierdaPj2") and bombPos==RIGHT and !anim.is_playing():
		anim.play("swipe_left" ,-1 ,randf_range(0,1) + speed)
		bombPos=LEFT
		speed += 0.2

func _on_timer_final_evento_timeout():
	var ganador
	# Según la bomba al final elige el ganador
	if bombPos == RIGHT:
		ganador = 1
	if bombPos == LEFT:
		ganador = 2
	Eventos.finalEvento.emit(ganador)
	queue_free()
