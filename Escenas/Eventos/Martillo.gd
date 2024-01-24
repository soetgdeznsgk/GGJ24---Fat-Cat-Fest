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
	if jugador == 1:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo] = "AbajoPj1"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj1"
		diccionarioInputs[Enums.Derecha] = "DerechaPj1"
		$Label.text = "Player 1"
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj2"
		diccionarioInputs[Enums.Izquierda] = "IzquierdaPj2"
		diccionarioInputs[Enums.Derecha] = "DerechaPj2"
		$Label.text = "Player 2"
	golpeando = false
	platoAqui = false
	anim.play("Martillando")

func _physics_process(delta: float) -> void:
	if !canMove:
		return
	if Input.is_action_pressed(diccionarioInputs[Enums.Arriba]):
		if position.y > 100:
			position.y -= speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Abajo]):
		if position.y < 700:
			position.y += speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Izquierda]):
		if position.x > 100:
			position.x -= speed * delta
	if Input.is_action_pressed(diccionarioInputs[Enums.Derecha]):
		if position.x < 1200:
			position.x += speed * delta
	
	if platoAqui and golpeando:
		get_parent().perderVidaPlato()
	

func _on_area_entered(area: Area2D) -> void:
	platoAqui = true

func _on_area_exited(area: Area2D) -> void:
	platoAqui = false
