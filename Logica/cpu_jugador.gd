extends Node

func _enter_tree():
	print("cpu instanciada")
	Eventos.nuevoEvento.connect(minigame_entered)
	Eventos.finalEvento.connect(eat)
	
func minigame_entered(activity : int):
	match activity:
		1: # RomperPlatos minijuego
			pass
		2: # Pepino
			pass
		3: # DarseDuro
			pass

func eat(cache):
	pass
	
