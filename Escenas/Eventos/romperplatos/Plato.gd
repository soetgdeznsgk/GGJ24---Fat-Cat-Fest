extends Area2D

var vida = 3
@export var jugador = 2
var diccionarioInputs := {}
@onready var anim = $AnimationPlayer
@export var speed : int = 100
var canMove = true


func _ready() -> void:
	pass
	
func cambiar_rol():
	vida = 3
	$Sprite2D2.texture = load("res://Sprites/QuickTimeEvent/patasPlato.png")
	if jugador == 1:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo] = "AbajoPj1"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
		$Label.text = Names.name_player1
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj2"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj2"
		diccionarioInputs[Enums.Derecha] = "DerechaPj2"
		$Label.text = Names.name_player2

func _physics_process(delta: float) -> void:
	if !canMove:
		return
	if Input.is_action_pressed(diccionarioInputs[Enums.Arriba]):
		if position.y > 160:
			position.y -= speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Abajo]):
		if position.y < 620:
			position.y += speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]):
		if position.x > 160:
			position.x -= speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Derecha]):
		if position.x < 1220:
			position.x += speed * delta
	
func perder_vida():
	if !canMove:
		return
	vida -= 1
	if vida == 2:
		$Sprite2D2.texture = load("res://Sprites/QuickTimeEvent/patasPlatoGrieta1.png")
		get_parent().reiniciar_pos()
	elif vida == 1:
		$Sprite2D2.texture = load("res://Sprites/QuickTimeEvent/patasPlatoGrieta2.png")
		get_parent().reiniciar_pos()
	if vida <= 0:
		$Sprite2D2.texture = load("res://Sprites/QuickTimeEvent/patasPlatoRoto.png")
		if jugador == 2:
			get_parent().puntajePj1 += 1
		else:
			get_parent().puntajePj2 += 1
		get_parent().pop_timer()
		
	
