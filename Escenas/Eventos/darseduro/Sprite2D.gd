extends Sprite2D
var diccionarioInputs := {}
@export var jugador = 1
var canMove = true
@export var golpeando = false
@onready var anim = $AnimationPlayer
@export var puedeGolpear = true


func _ready() -> void:
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

func _physics_process(delta: float) -> void:
	if !canMove:
		return
	if !puedeGolpear:
		return
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
		golpeando = true
		anim.play("golpeando")
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
		golpeando = true
		anim.play("golpeando")
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Izquierda]):
		golpeando = true
		anim.play("golpeando")
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Derecha]):
		golpeando = true
		anim.seek(0)
		anim.play("golpeando")
		
