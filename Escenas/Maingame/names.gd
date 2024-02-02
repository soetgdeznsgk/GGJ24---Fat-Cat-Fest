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
#func _ready() -> void:
	#generar_nombres()


func lookupAudioFile(in_name: String, opcion: int) -> String:
	var dir
	var dirString
	#☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️
	match opcion:
		1:
			dir = DirAccess.open("res://SFX/Narrador/prefijos")
			dirString = "res://SFX/Narrador/prefijos/"
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.contains(in_name.to_lower().format(["-"], " ")):
					file_name = file_name.trim_suffix(".import")
					return dirString + file_name
				file_name = dir.get_next()
		2:
			dir = DirAccess.open("res://SFX/Narrador/posfijos")
			dirString = "res://SFX/Narrador/posfijos/"
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.contains(in_name.to_lower().format(["-"], " ")):
					file_name = file_name.trim_suffix(".import")
					return dirString + file_name
				file_name = dir.get_next()
				
	return "error"

func generar_nombres():
	nameInitial1 = nameinitial.pick_random()
	nameFinal1 = namefinal.pick_random()
	nameInitial2 = nameinitial.pick_random()
	nameFinal2 = namefinal.pick_random()
	while nameFinal1 == nameFinal2:
		nameFinal1 = namefinal.pick_random()
	encontrar_audio_nombres()
	if Eventos.multiOnline and multiplayer.is_server():
		generar_nombres_rpc.rpc(nameInitial1, nameFinal1,\
		nameInitial2, nameFinal2)
		

@rpc("authority","call_local","reliable")
func generar_nombres_rpc(Initial1,Final1,Initial2,Final2):
	nameInitial1 = Initial1
	nameFinal1 = Final1
	nameInitial2 = Initial2
	nameFinal2 = Final2
	encontrar_audio_nombres()

func encontrar_audio_nombres():
	#☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️☢️
	dirAudioInitial1 = lookupAudioFile(nameInitial1, 1)
	dirAudioFinal1 = lookupAudioFile(nameFinal1, 2)
	dirAudioInitial2 = lookupAudioFile(nameInitial2, 1)
	dirAudioFinal2 = lookupAudioFile(nameFinal2, 2)
	name_player1 = nameInitial1 + " " + nameFinal1
	name_player2 = nameInitial2 + " " + nameFinal2
