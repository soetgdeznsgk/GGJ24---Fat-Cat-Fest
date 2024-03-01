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

func playRandomSound(audioPlayer : AudioStreamPlayer , soundChoices: Array):
	audioPlayer.stream = soundChoices.pick_random()
	audioPlayer.play()

func loadResources(route: String) -> Array:
	var resourcesArray = []
	var dir = DirAccess.open(route)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Check if the file is an audio file
			if file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
				# Load the audio file and add it to the resourcesArray
				resourcesArray.append(load(route + "/" + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()

	return resourcesArray
