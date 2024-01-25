extends Button
class_name boton_simple

func _on_mouse_entered():
	grab_focus()

func _on_mouse_exited():
	release_focus()
	
func _on_focus_entered():
	pass
func _on_focus_exited():
	pass
