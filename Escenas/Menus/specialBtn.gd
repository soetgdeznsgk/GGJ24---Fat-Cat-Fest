extends TextureButton

func _on_mouse_entered():
	grab_focus()

func _on_mouse_exited():
	release_focus()
