extends Node

var singleplayer : bool
var tutorialSingleplayerHecho: bool = false
var tutorialMultiplayerHecho: bool = false
var ganador = 0

signal nuevoEvento(evento)
signal bajarTelon
signal finalPopUp
signal finalEvento(ganador)
signal nuevaComida(jugador, comida:Array )
signal comandosAcabados(jugador)
signal mediaComida(jugador)
signal comidaAPuntoDeTerminar(jugador)
signal catCheer(prob)
signal ganadorFestival(ganador)
