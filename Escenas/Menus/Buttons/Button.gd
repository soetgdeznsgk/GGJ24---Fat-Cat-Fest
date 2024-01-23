extends Button
var isHighlighted := false
@onready var tween : Tween
@onready var basePosition = $TextureRect.position
var dist := 100.0
var tiempo := 0.2

func _on_mouse_entered():
	if !isHighlighted:
		tween = get_tree().create_tween()
		tween.tween_property($TextureRect, "position", basePosition + Vector2(dist, 0), tiempo)
		await tween.finished
		isHighlighted = true


func _on_mouse_exited():
	if $TextureRect.position != basePosition: 
		var invtween = get_tree().create_tween()
		invtween.tween_property($TextureRect, "position", basePosition, tween.get_total_elapsed_time())
		isHighlighted = false
		
func _process(_delta): # ésto es para verificar que no se entró y salió del botón en el mismo frame
	if isHighlighted:
		_on_mouse_exited()
