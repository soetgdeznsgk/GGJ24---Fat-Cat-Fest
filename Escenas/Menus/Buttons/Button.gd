extends Button
@onready var anim:AnimationPlayer = $AnimationPlayer
var seeker = 0
var backwards = false
var forward = false

@onready var margin_size = get_tree().root.size.x / 5

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

func _on_pressed() -> void: # intentar moverlo con el margen y no con el size
	hide()
	$"../SPButton".show()
	$"../MPButton".show()
	
	#$"..".position = $"..".position + Vector2($"..".size.x / 2, 0)
	#var original_lenght = $"..".size.x
	#$"..".size.x = 0
	#var tween_pos = get_tree().create_tween()
	#tween_pos.tween_property($"..", "position", Vector2.ZERO, 1)
	#var tween_size = get_tree().create_tween()
	#tween_size.tween_property($"..", "size", Vector2(original_lenght, $"..".size.y), 1)
	$"../..".add_theme_constant_override("margin_left", margin_size)
	$"../..".add_theme_constant_override("margin_right", margin_size)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "margin_size", 0, 0.5)
	tween_margins_forcefully(tween)
	
func tween_margins_forcefully(tween : Tween):
	if tween.is_running():
		$"../..".add_theme_constant_override("margin_left", margin_size)
		$"../..".add_theme_constant_override("margin_right", margin_size)
		await get_tree().create_timer(0.01).timeout
		tween_margins_forcefully(tween)
