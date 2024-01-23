extends Button
@onready var anim:AnimationPlayer = $AnimationPlayer
var seeker = 0
var backwards = false
var forward = false
# TODO corregir que la S parpadea con la animación
func _on_mouse_entered():
	if anim.is_playing():
		seeker = anim.current_animation_position
	else:
		seeker = 0
	if !forward:
		anim.play("slide")
		forward = true
		backwards = false
		anim.seek(seeker)

func _on_mouse_exited():
	if anim.is_playing():
		seeker = anim.current_animation_position
	else:
		seeker = 0
	if !backwards:
		anim.seek(seeker)
		anim.play_backwards("slide")
		forward = false
		backwards = true

func _on_focus_entered() -> void:
	_on_mouse_entered()

func _on_focus_exited() -> void:
	_on_mouse_exited()
