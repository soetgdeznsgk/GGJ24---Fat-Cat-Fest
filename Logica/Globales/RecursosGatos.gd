extends Node

#VALORES DEFAULT
#TODO: CAMBIAR ESTAS GLOBALES DESDE LA PJ SELECTION SCREEN
var catSelectionP1 : String = "Miguel" 
var catSelectionP2 : String = "Miguel"

@onready var recursos = {
	"Timmy" : {
			"versusScreen" : "",
			"mainGame" : { 	"anims" : preload("res://RecursosGatos/Maingame_Timmy.tres"),
							"positionLeft" : Vector2(136,-298),
							"positionRight" : Vector2(148,-298),
							"scale" : Vector2(0.6, 0.6),
							"sonidos" : {
								"stunned" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Stunned/"),
								"choke" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Choke/"),
								"eating" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Eating/"),
								"finished" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Finished/"),
							},
						},
			"darseDuro" : {	 "Cuerpo" : { "sprite" : preload("res://Sprites/Gatos/Timmy/Pelea/cuerpo.png"),
										 "pos" : Vector2(-22, 96),
										 "scale" : Vector2(0.4, 0.4),
										},
							"Cabeza" : {"CabezaNormal" : preload("res://Sprites/Gatos/Timmy/Pelea/cabeza.png"),
										"CabezaHit" : preload("res://Sprites/Gatos/Timmy/Pelea/cabeza golpe.png"),
										"pos" : Vector2(0, 0),
										"scale" : Vector2(0.4, 0.4),
										"markerDown" : Vector2(0, 40),
										},
							"Pata" : {	"sprite" : preload("res://Sprites/Gatos/Timmy/Pelea/mano.png"),
										 "scale" : Vector2(0.4, 0.4),},
						},
			"winnerScreen" : { 	"anims" : "",
							"scale" : 1.0,
						},
		},
	"Miguel" : {
			"versusScreen" : "",
			"mainGame" : { 	"anims" : preload("res://RecursosGatos/Maingame_Miguel.tres"),
							"positionLeft" : Vector2(40,-402),
							"positionRight" : Vector2(40,-402),
							"scale" : Vector2(0.7, 0.7),
							"sonidos" : {
								"stunned" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Stunned/"),
								"choke" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Choke/"),
								"eating" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Eating/"),
								"finished" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Finished/"),
							},
						},
			"darseDuro" : {	"Cuerpo" : { "sprite" : preload("res://Sprites/Gatos/Miguel/Pelea/Tordo.png"),
										 "pos" : Vector2(0, 96),
										 "scale" : Vector2(0.4, 0.4),
										},
							"Cabeza" : {"CabezaNormal" : preload("res://Sprites/Gatos/Miguel/Pelea/cabeza.png"),
										"CabezaHit" : preload("res://Sprites/Gatos/Miguel/Pelea/cabeza aplastada.png"),
										"pos" : Vector2(0, -10),
										"scale" : Vector2(0.4, 0.4),
										"markerDown" : Vector2(0, 50),
										},
							"Pata" : {	"sprite" : preload("res://Sprites/Gatos/Miguel/Pelea/Puño.png"),
										 "scale" : Vector2(0.3, 0.3),},
						},
			"winnerScreen" : { 	"anims" : "",
							"scale" : 1.0,
						},
		},
}

