extends AnimatedSprite2D

@onready var gatoGif = $GatoGif

# Called when the node enters the scene tree for the first time.
func _ready():
	gatoGif.play("Eat")
	pass # Replace with function body.
