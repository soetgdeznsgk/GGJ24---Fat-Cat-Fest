extends Node

enum {
	Arriba,
	Abajo,
	Izquierda,
	Derecha
}

enum MiniJuegos {
	RomperPlatos,
	Pepino,
	DarseDuro
}

func vector_to_value(vector : Vector2) -> int: # aproximar un vector a una dirección de input para el juego de romper platos
	var a = vector.dot(Vector2.UP)	# TIENEN QUE ESTAR EN EL MISMO ORDEN QUE EL ENUM DE DIRECCIONES
	var b = vector.dot(Vector2.DOWN)
	var c = vector.dot(Vector2.LEFT)
	var d = vector.dot(Vector2.RIGHT)
	var m = max(a, b, c, d)
	match m:
		a: return 0
		b: return 1
		c: return 2
	return 3
	
