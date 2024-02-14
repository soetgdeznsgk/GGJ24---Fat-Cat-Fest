extends Node

var mouseToggle = false
var mouseInNode = false
var focusedNode = null

func mouseGrabFocus(node : Control):
	mouseInNode = true 
	focusedNode = node
	focusedNode.grab_focus()

func mouseReleaseFocus():
	mouseInNode = false 
	focusedNode.release_focus()
	focusedNode = null
