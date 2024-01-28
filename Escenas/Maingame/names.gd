extends Node
# alerta de radiacion
var name_player1
var name_player2
var nameInitial1
var nameFinal1
var nameInitial2
var nameFinal2
var dirAudioInitial1
var dirAudioFinal1
var dirAudioInitial2
var dirAudioFinal2
var nameinitial : Array = ["Silly", "Tiny", "Huge", "The", "Cute", "Nonsensical", "Addictive", "Smol", "Sad", "Baby", "Eepy", "Anxious", "Crazy", "Golden", "Ex-convict","Skibidi"]
var namefinal : Array = ["Car", "Kitty", "WAR CRIMINAL", "Chonker", "Purrer", "Bingus", "Microplastic Enjoyer", "Mulch", "Yippie", "Nyan", "Hobo", "Karen Adopted", "Paw Sniffer"]

# Al iniciarse el singleton toma un nombre random, tambien al darle play al juego
# lo pongo aca para que no se rompa al probar escenas solitas
func _ready() -> void:
	# alerta de radiacion 
	Names.name_player1 = Names.nameinitial.pick_random() + " " + Names.namefinal.pick_random()
	Names.name_player2 = Names.nameinitial.pick_random() + " " + Names.namefinal.pick_random()
	Names.nameInitial1 = nameinitial[randi() % nameinitial.size()]
	Names.nameFinal1 = namefinal[randi() % namefinal.size()]
	Names.nameInitial2 = nameinitial[randi() % nameinitial.size()]
	Names.nameFinal2 = namefinal[randi() % namefinal.size()]
	#☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️
	Names.dirAudioInitial1 = lookupAudioFile(nameInitial1, 1)
	Names.dirAudioFinal1 = lookupAudioFile(nameFinal1, 2)
	Names.dirAudioInitial2 = lookupAudioFile(nameInitial2, 1)
	Names.dirAudioFinal2 = lookupAudioFile(nameFinal2, 2)
	Names.name_player1 = nameInitial1 + " " + nameFinal1
	Names.name_player2 = nameInitial2 + " " + nameFinal2
	pass

func lookupAudioFile(name: String, opcion: int) -> String:
	var dir
	var dirString
	match opcion:
		1:
			dir = DirAccess.open("res://SFX/Narrador/prefijos")
			dirString = "res://SFX/Narrador/prefijos/"
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.contains(name.to_lower().format(["-"], " ")):
					return dirString + file_name
				file_name = dir.get_next()
		2:
			dir = DirAccess.open("res://SFX/Narrador/posfijos")
			dirString = "res://SFX/Narrador/posfijos/"
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.contains(name.to_lower().format(["-"], " ")):
					return dirString + file_name
				file_name = dir.get_next()
				
	return "error"
