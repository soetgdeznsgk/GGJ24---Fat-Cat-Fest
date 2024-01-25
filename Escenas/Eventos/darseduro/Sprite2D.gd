extends Node2D
var diccionarioInputs := {}
@export var jugador = 1
@export var golpeando = false
@export var puedeGolpear = true
@onready var markerCabeza = $sprPadre/Marker2D2.position
@onready var cabeza = $sprPadre/Cabeza
@onready var cuerpo = $sprPadre/SprCuerpo
@onready var pata = $sprPadre/Pata
@onready var initialPos = pata.position
@onready var cabezaPosInicial = cabeza.position
var conteoGolpesRecibidos = 0

func _ready() -> void:
	if jugador == 1:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo] = "AbajoPj1"
		$Label.text = "Player 1"
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj2"
		$Label.text = "Player 2"
		$sprPadre.scale.x = -1

func _physics_process(delta: float) -> void:
	if !puedeGolpear:
		return
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
		if golpeando:
			golpeando = false
			var tween = create_tween()
			tween.tween_property(pata,"position",initialPos,0.1)
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
		if !golpeando:
			golpeando = true
			var tween = create_tween()
			tween.tween_property(pata,"position",$sprPadre/MarkerMediaPAta.position,0.07)
			tween.tween_property(pata,"position",$sprPadre/MarkerFinalPAta.position,0.07)
			
		


func _on_cabeza_area_entered(area: Area2D) -> void:
	#Recibe golpe
	conteoGolpesRecibidos += 1
	var tweenCabeza = get_tree().create_tween()
	tweenCabeza.tween_property(cabeza,"position", markerCabeza, 0.2)

func _on_cabeza_area_exited(area: Area2D) -> void:
	var tweenCabeza = get_tree().create_tween()
	tweenCabeza.tween_property(cabeza,"position", cabezaPosInicial, 0.2)
