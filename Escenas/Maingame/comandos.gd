extends Node2D

var textureEnum = [ load("res://Sprites/Comandos/flechaArriba.png"), \
load("res://Sprites/Comandos/FlechaAbajo.png"), \
load("res://Sprites/Comandos/FlechaIzquierda.png"), \
load("res://Sprites/Comandos/FlechaDerecha.png") ]

@onready var anim = $AnimationPlayer

@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
var comandos : Array = []

enum {
	Arriba,
	Abajo,
	Izquierda,
	Derecha
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# deberian llegar en la comida
	comandos = [Arriba,Abajo,Izquierda,Derecha,Abajo,Izquierda,Derecha,Arriba,Abajo]
	print(comandos)
	for i in range(3):
		var ultimo = comandos.pop_front()
		comandoNodos[i].texture = textureEnum[ultimo]
	print(comandos)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		actualizar_flechas()

func actualizar_flechas():
	print(comandos)
	if comandos.size() > 0:
		var ultimo = comandos.pop_front()
		comandoNodos[3].texture = textureEnum[ultimo]
	else:
		var ultimo = null
		comandoNodos[3].texture = null
	anim.play("scroll_izquierda")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	comandoNodos[0].texture = comandoNodos[1].texture
	comandoNodos[1].texture = comandoNodos[2].texture
	comandoNodos[2].texture = comandoNodos[3].texture
	
	
