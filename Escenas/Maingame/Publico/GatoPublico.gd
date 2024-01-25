extends Node2D
# Called when the node enters the scene tree for the first time.
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer

func _ready():
	sprite.frame = randi() % 70
	anim.play("idle_appear")
