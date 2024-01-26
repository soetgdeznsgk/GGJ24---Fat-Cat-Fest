extends Node2D

func is_sp(v : bool) -> void:
	await ready
	if v:
		var bot = preload("res://Logica/cpu_jugador.tscn").instantiate()
		add_child(bot)
		# bloquear comandos del teclado asociados a P2
	else:
		pass # nada
