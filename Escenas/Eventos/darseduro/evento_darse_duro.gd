extends Node2D

signal p2_can_hit

func _ready():
	$Label.modulate = Color("#88D662")
	$Label.text = Names.name_player1
	$Label2.modulate = Color("#F2DF6F")
	$Label2.text = Names.name_player2

func _on_timer_finalizar_evento_timeout() -> void:
	if $Gato.conteoGolpesRecibidos == $Gato2.conteoGolpesRecibidos:
		Eventos.finalEvento.emit(0)
	elif $Gato.conteoGolpesRecibidos < $Gato2.conteoGolpesRecibidos:
		Eventos.finalEvento.emit(1)
	elif $Gato.conteoGolpesRecibidos > $Gato2.conteoGolpesRecibidos:
		Eventos.finalEvento.emit(2)
	queue_free()

func set_winner_by_life(winner):
	Eventos.finalEvento.emit(2 if winner == 1 else 1)
	queue_free()

func relay_p2_can_hit() -> void:
	p2_can_hit.emit()
