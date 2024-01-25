extends Node2D

func is_sp(v : bool) -> void:
	if v:
		print("ejecutado sp")
		var bot = preload("res://Logica/cpu_jugador.tscn").instantiate()
		add_child(bot)
		# iniciar el bot
		# bloquear comandos del teclado asociados a P2
	else:
		print("ejecutado mp")
		# nada
