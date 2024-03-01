extends Node2D
# Called when the node enters the scene tree for the first time.
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
var yipee

func _ready():
	sprite.frame = randi() % 70
	anim.play("idle_appear")
	$AudioStreamPlayer.stream = yipee

func play_yipee():
	if randf() < 0.5:
		$AudioStreamPlayer.pitch_scale = randf_range(0.98,1.02)
		await get_tree().create_timer(randi_range(0,10)/10).timeout
		$AudioStreamPlayer.play()
