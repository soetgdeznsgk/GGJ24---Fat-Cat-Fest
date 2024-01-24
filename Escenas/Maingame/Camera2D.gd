extends Camera2D
@export var zoomFinal : Vector2

func _ready() -> void:
	Eventos.finalPopUp.connect(zoomCamara)
	Eventos.finalEvento.connect(quitarZoom)

func zoomCamara():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self,"zoom", zoomFinal, 0.3)

func quitarZoom(_ganador):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"zoom", Vector2(1,1), 0.3)
