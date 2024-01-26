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
var enCooldown = false

func _ready() -> void:
	if jugador == 2:
		diccionarioInputs[Enums.Arriba] = "ArribaPj2"
		diccionarioInputs[Enums.Abajo] = "AbajoPj2"
		$Label.text = Names.name_player2
		$sprPadre.scale.x = -1
		$Label.modulate = Color("#F2DF6F")
	else:
		diccionarioInputs[Enums.Arriba] = "ArribaPj1"
		diccionarioInputs[Enums.Abajo]  = "AbajoPj1"
		$Label.text = Names.name_player1
		$Label.modulate = Color("#88D662")

func _physics_process(_delta: float) -> void:
	if !puedeGolpear:
		return
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Arriba]):
		if golpeando and !enCooldown:
			golpeando = false
			enCooldown = true
			var tween = create_tween()
			tween.tween_property(pata,"position",$sprPadre/MarkerMediaPAta.position,0.1)
			tween.tween_property(pata,"position",initialPos,0.05)
			$TimerCooldown.start(0.09)
			
	if Input.is_action_just_pressed(diccionarioInputs[Enums.Abajo]):
		if !golpeando and !enCooldown:
			golpeando = true
			enCooldown = true
			var tween = create_tween()
			tween.tween_property(pata,"position",$sprPadre/MarkerMediaPAta.position,0.1)
			tween.tween_property(pata,"position",$sprPadre/MarkerFinalPAta.position,0.05)
			$TimerCooldown.start(0.1)
			

func _on_cabeza_area_entered(_area: Area2D) -> void:
	#Recibe golpe
	conteoGolpesRecibidos += 1
	var tweenCabeza = get_tree().create_tween()
	tweenCabeza.set_ease(Tween.EASE_IN)
	tweenCabeza.tween_property(cabeza,"position", markerCabeza, 0.12)

func _on_cabeza_area_exited(_area: Area2D) -> void:
	var tweenCabeza = get_tree().create_tween()
	tweenCabeza.tween_property(cabeza,"position", cabezaPosInicial, 0.1)

func _on_timer_cooldown_timeout() -> void:
	enCooldown = false
