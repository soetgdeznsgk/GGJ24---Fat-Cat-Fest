extends Area2D

var golpeando = false
var platoAqui = false
@export var jugador = 1
var diccionarioInputs := {}
@onready var anim = $AnimationPlayer
@export var speed : int = 30
var canMove = true

func set_golpeando(golpe):
	golpeando = golpe

func cambiar_rol():
	if jugador == 2:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2"
		diccionarioInputs[Enums.Abajo] = "AbajoPj2"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj2"
		diccionarioInputs[Enums.Derecha] = "DerechaPj2"
		$Label.text = Names.name_player1
		$Label.modulate = Color("#F2DF6F")
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
		$Label.text = Names.name_player2
		$Label.modulate = Color("#88D662")
	golpeando = false
	platoAqui = false
	anim.play("Martillando")

func _physics_process(delta: float) -> void:
	if !canMove:
		return
	if Input.is_action_pressed(diccionarioInputs[Enums.Arriba]):
		if position.y > 50:
			position.y -= speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Abajo]):
		if position.y < 620:
			position.y += speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]):
		if position.x > 100:
			position.x -= speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Derecha]):
		if position.x < 1200:
			position.x += speed * delta
	
	if platoAqui and golpeando:
		get_parent().perderVidaPlato()
	

func _on_area_entered(_area: Area2D) -> void:
	platoAqui = true

func _on_area_exited(_area: Area2D) -> void:
	platoAqui = false
