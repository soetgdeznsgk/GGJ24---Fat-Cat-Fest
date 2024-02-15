extends Node

var cpuDiff : int = 1 #Default
var singleplayer : bool

var isThereAnEvent : bool = false
var tutorialSingleplayerHecho: bool
var tutorialMultiplayerHecho: bool
var ganador = 0

var multiOnline : bool = false

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
signal nuevoInputRegistrado(input, jugador)
signal enviarInput(input, jugador)
signal nuevoVectorRegistrado(vector, jugador)
signal enviarVector(vector, jugador)
