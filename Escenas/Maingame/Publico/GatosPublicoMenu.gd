extends Node2D

# An array of different cat X positions
var catXPositions: Array = [ -10, 140, 290, 440, 590, 740, 890, 1040, 1190 ]

# Array to store references to the instantiated cat instances
var catInstances: Array = []
@export var yippies : Array[AudioStream] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func instantiateRandomCats(number) -> void:
	var numberOfCats = number

	# Shuffle the array of cat X positions to randomize their order
	catXPositions.shuffle()

	# Limit the number of cats to the size of the array
	numberOfCats = min(numberOfCats, catXPositions.size())

	for i in range(numberOfCats):
		# Instantiate the cat scene
		var catInstance = load("res://Escenas/Maingame/Publico/GatoPublico.tscn").instantiate()

		# Set the X position of the cat from the shuffled array
		catInstance.position.x = catXPositions[i]

		# Generate a random Y position within the range of -5 to 5 from a base Y position
		catInstance.position.y = randi_range(770, 780)
		var yipee = yippies.pick_random()
		catInstance.yipee = yipee
		# Add the cat to the scene
		add_child(catInstance)
		
		# Add the cat instance to the array
		catInstances.append(catInstance)

func _on_special_btn_pressed():
	for cat in catInstances:
		# Generate a random number to determine if the cat cheers (50% chance)
		if randf() < 0.6:
			# Access the AnimationPlayer in each cat and play the cheer animation
			var animPlayer = cat.get_node("AnimationPlayer")
			if animPlayer != null:
				animPlayer.play("cheer")

func _on_info_btn_pressed():
	instantiateRandomCats(randi_range(6,10))

func _on_credits_path_back_pressed():
	for cat in catInstances:
		var animPlayer: AnimationPlayer = cat.get_node("AnimationPlayer")
		if animPlayer != null: animPlayer.play("idle_dissappear")
