extends Node

#VALORES DEFAULT
#TODO: CAMBIAR ESTAS GLOBALES DESDE LA PJ SELECTION SCREEN
var catSelectionP1 : String = "Timmy" 
var catSelectionP2 : String = "Timmy"

@onready var recursos = {
	"Timmy" : {
			"versusScreen" : {
								"anims" : preload("res://RecursosGatos/Versus_Timmy.tres"),
								"posLeft": Vector2(358, 580),
								"posRight": Vector2(1050, 580),
								"scale": Vector2(0.6, 0.6),
			},
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
			"pepino" : { "anims" : preload("res://RecursosGatos/Pepino_Timmy.tres"),
						 "posIzq" : Vector2(453, 330),
						 "posDer" : Vector2(917, 330),
						 "scale" : Vector2(0.65, 0.65),
						 "sounds" : Globals.loadResources("res://SFX/Gatos/Timmy/Eventos/Pepino/"),
			},
			"plateBreaker" : {
				"hammer0" : preload("res://Sprites/Gatos/Timmy/plateBreaker/hammer_down.png"),
				"hammer1" : preload("res://Sprites/Gatos/Timmy/plateBreaker/hammer_up.png"),
				"plate0" : preload("res://Sprites/Gatos/Timmy/plateBreaker/plate_0.png"),
				"plate1" : preload("res://Sprites/Gatos/Timmy/plateBreaker/plate_1.png"),
				"plate2" : preload("res://Sprites/Gatos/Timmy/plateBreaker/plate_2.png"),
				"plate3" : preload("res://Sprites/Gatos/Timmy/plateBreaker/plate_3.png"),
			},
			"winnerScreen" : { 	"anims" : preload("res://RecursosGatos/Maingame_Timmy.tres"),
								"posWinner" : Vector2(686, 381),
								"scaleWinner" : Vector2(0.6, 0.6),
								"posLoser" : Vector2(1039, 414),
								"scaleLoser" : Vector2(0.5, 0.5),
								"soundsWinner" : Globals.loadResources("res://SFX/Gatos/Timmy/Winner/"),
								"soundsLoser" : Globals.loadResources("res://SFX/Gatos/Timmy/Loser/"),
						},
		},
	"Miguel" : {
			"versusScreen" : {
								"anims" : preload("res://RecursosGatos/Versus_Miguel.tres"),
								"posLeft": Vector2(358, 580),
								"posRight": Vector2(1000, 580),
								"scale": Vector2(1.2, 1.2),
			},
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
						"pepino" : { "anims" : preload("res://RecursosGatos/Pepino_Miguel.tres"),
						 "posIzq" : Vector2(462, 271),
						 "posDer" : Vector2(930, 271),
						 "scale" : Vector2(0.65, 0.65),
						 "sounds" : Globals.loadResources("res://SFX/Gatos/Miguel/Eventos/Pepino/"),
			},
			"plateBreaker" : {
				"hammer0" : preload("res://Sprites/Gatos/Miguel/plateBreaker/hammer_down.png"),
				"hammer1" : preload("res://Sprites/Gatos/Miguel/plateBreaker/hammer_up.png"),
				"plate0" : preload("res://Sprites/Gatos/Miguel/plateBreaker/plate_0.png"),
				"plate1" : preload("res://Sprites/Gatos/Miguel/plateBreaker/plate_1.png"),
				"plate2" : preload("res://Sprites/Gatos/Miguel/plateBreaker/plate_2.png"),
				"plate3" : preload("res://Sprites/Gatos/Miguel/plateBreaker/plate_3.png"),
			},
			"winnerScreen" : { 	"anims" : preload("res://RecursosGatos/Maingame_Miguel.tres"),
								"posWinner" : Vector2(689, 340),
								"scaleWinner" : Vector2(0.7, 0.7),
								"posLoser" : Vector2(1004, 375),
								"scaleLoser" : Vector2(0.55, 0.55),
								"soundsWinner" : Globals.loadResources("res://SFX/Gatos/Miguel/Winner/"),
								"soundsLoser" : Globals.loadResources("res://SFX/Gatos/Miguel/Loser/"),
						},
		},
}
