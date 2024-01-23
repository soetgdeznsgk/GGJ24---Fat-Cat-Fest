extends Node2D

@onready var anim = $AnimationPlayer
var bombPos = null

enum {LEFT,RIGHT}

# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() < 0.5:
		# Play your animation
		anim.play("spawn_left")
		bombPos = LEFT
	else:
		# Do something else or don't play the animation
		anim.play("spawn_right")
		bombPos = RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("DerechaPj1") and bombPos==LEFT and !anim.is_playing():
		anim.play("swipe_right")
		bombPos=RIGHT
	if Input.is_action_just_pressed("IzquierdaPj2") and bombPos==RIGHT and !anim.is_playing():
		anim.play("swipe_left")
		bombPos=LEFT

func _on_timer_final_evento_timeout():
	#TODO: MANDAR SEÑAL PARA INDICAR QUIEN GANO DEPENDIENDO DE LA BOMBPOS FINAL
	Eventos.finalEvento.emit()
	queue_free()
