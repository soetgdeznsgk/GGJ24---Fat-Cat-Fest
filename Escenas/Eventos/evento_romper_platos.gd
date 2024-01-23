extends Node2D



func _on_timer_final_evento_timeout() -> void:
	Eventos.finalEvento.emit()
	queue_free()
