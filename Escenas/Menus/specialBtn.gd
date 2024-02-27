extends TextureButton

func _on_mouse_entered(): Globals.mouseGrabFocus(self)
func _on_mouse_exited():  Globals.mouseReleaseFocus()
