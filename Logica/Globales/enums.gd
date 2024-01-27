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

func nearest_octo_vector(vector : Vector2): # aproximar un vector a una dirección de input para el juego de romper platos
	var a = vector.dot(Vector2.UP)	# TIENEN QUE ESTAR EN EL MISMO ORDEN QUE EL ENUM DE DIRECCIONES
	var b = vector.dot(Vector2.DOWN)
	var c = vector.dot(Vector2.LEFT)
	var d = vector.dot(Vector2.RIGHT)
	var e = vector.dot(Vector2(1, 1))
	var f = vector.dot(Vector2(1, -1))
	var g = vector.dot(Vector2(-1, 1))
	var h = vector.dot(Vector2(-1, -1))
	var m = max(a, b, c, d, e, f, g, h)
	match m:
		a: return 0
		b: return 1
		c: return 2
		d: return 3
		e: return Vector2(1, 1)
		f: return Vector2(1, -1)
		g: return Vector2(-1, 1)
	return Vector2(-1, -1)
	
