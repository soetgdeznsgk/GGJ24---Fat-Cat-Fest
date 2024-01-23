extends Button
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var tween : Tween
@onready var leftMargin = $PlayButton.h_separation
func _on_mouse_entered():
	print(leftMargin)
		
func _on_mouse_exited():
	print(leftMargin)




