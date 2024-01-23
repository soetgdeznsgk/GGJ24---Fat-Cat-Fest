extends Node2D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(5)
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	anim.play("pop_up")
