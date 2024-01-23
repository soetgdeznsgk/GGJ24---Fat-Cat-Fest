extends Node2D

var textureEnum = [ load("res://Sprites/Comandos/flechaArriba.png"), \
load("res://Sprites/Comandos/FlechaAbajo.png"), \
load("res://Sprites/Comandos/FlechaIzquierda.png"), \
load("res://Sprites/Comandos/FlechaDerecha.png") ]

@onready var anim = $AnimationPlayer

@onready var comandoNodos = [$Comando0, $Comando1, $Comando2, $Comando3]
var comandos : Array = []
var esperarError := false

enum {
	Arriba,
	Abajo,
	Izquierda,
	Derecha
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# deberian llegar en la comida
	comandos = [Arriba,Abajo,Izquierda,Derecha,Abajo,Izquierda,Derecha,Arriba,Abajo,Arriba,Abajo]
	for i in range(3):
		var ultimo = comandos.pop_front()
		comandoNodos[i].texture = textureEnum[ultimo]

func _physics_process(delta: float) -> void:
	# Quiza falta input buffering
	# Lo hace bien
	if Input.is_action_just_pressed("ui_accept"):
		actualizar_flechas()
	# Se equivoca
	if Input.is_action_just_pressed("ui_cancel"):
		error_flechas()

func actualizar_flechas():
	if !esperarError:
		if comandos.size() > 0:
			var ultimo = comandos.pop_front()
			comandoNodos[3].texture = textureEnum[ultimo]
		else:
			var ultimo = null
			comandoNodos[3].texture = null
		if anim.is_playing():
			anim.play("scroll_izquierda",-1,5)
		else:
			anim.play("scroll_izquierda",-1,1)

func error_flechas():
	esperarError = true
	if anim.is_playing():
		anim.speed_scale = 5
		await anim.animation_finished 
		anim.speed_scale = 0.3
		anim.play("error_flecha")
	else:
		anim.speed_scale = 0.7
		anim.play("error_flecha")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scroll_izquierda":
		comandoNodos[0].texture = comandoNodos[1].texture
		comandoNodos[1].texture = comandoNodos[2].texture
		comandoNodos[2].texture = comandoNodos[3].texture
		for i in comandoNodos.size():
			comandoNodos[i].position = Vector2((i+1)*128, 51)
			comandoNodos[i].self_modulate = Color(1,1,1,1)
	if anim_name == "error_flecha":
		esperarError = false
		anim.speed_scale = 1
			
	
	
