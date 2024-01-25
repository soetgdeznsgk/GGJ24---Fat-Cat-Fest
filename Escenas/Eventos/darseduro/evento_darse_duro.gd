extends Node2D

func _on_timer_finalizar_evento_timeout() -> void:
	if $Gato.conteoGolpesRecibidos == $Gato2.conteoGolpesRecibidos:
		Eventos.finalEvento.emit(0)
	elif $Gato.conteoGolpesRecibidos > $Gato2.conteoGolpesRecibidos:
		Eventos.finalEvento.emit(1)
	elif $Gato.conteoGolpesRecibidos < $Gato2.conteoGolpesRecibidos:
		Eventos.finalEvento.emit(2)
	queue_free()
