extends Node

const ASTEROID = preload("res://entities/Asteroid/Asteroid.tscn")

const AST_T1 = preload("res://entities/Asteroid/AsteroidsTypes/AsteroidType_1.tres")
const AST_T2 = preload("res://entities/Asteroid/AsteroidsTypes/AsteroidType_2.tres")
const AST_T3 = preload("res://entities/Asteroid/AsteroidsTypes/AsteroidType_3.tres")
const AST_T4 = preload("res://entities/Asteroid/AsteroidsTypes/AsteroidType_4.tres")
const AST_T5 = preload("res://entities/Asteroid/AsteroidsTypes/AsteroidType_5.tres")
const AST_T6 = preload("res://entities/Asteroid/AsteroidsTypes/AsteroidType_6.tres")

var distance_limit_to_increase : int = 500 # Receive the data from Game parent script.
var total_probability_asteroids : float = 1.0

var asteroids : Array =[
	{"type": AST_T1, "prob": 0.2},
	{"type": AST_T2, "prob": 0.2},
	{"type": AST_T3, "prob": 0.2},
	{"type": AST_T4, "prob": 0.2},
	{"type": AST_T5, "prob": 0.2},
	{"type": AST_T6, "prob": 0.2}
	]

# Class to reorder asteroids based in prob value
class SorterAsteroidsByProb:
	static func sort_ascending(a, b):
		if a.prob < b.prob:
			return true
		return false

func _ready() -> void:
	update_asteroids_probability(0)

func create_asteroid(bonus_speed) -> void:
	var asteroid_instance = ASTEROID.instance()
	var asteroid_type : Resource
	var probabilty : float = randf() * total_probability_asteroids
	var acumulator : float = 0.0
	
	for ast in asteroids:
		acumulator += ast.prob
		if acumulator >= probabilty:
			asteroid_type = ast.type
			break
	
	asteroid_instance.create_asteroid(asteroid_type, 80, 1120, bonus_speed)
	add_child(asteroid_instance)

func update_asteroids_probability(_dist:float) -> void:
	total_probability_asteroids = 0.0
	for ast in asteroids:
		var clamp_dist = clamp(_dist, 0, distance_limit_to_increase)
		var ast_type : Resource = ast.type
		ast.prob = ast_type.probability.interpolate(clamp_dist/distance_limit_to_increase)
		
		total_probability_asteroids += ast.prob
	
	# Reorder asteroids based in prob
	asteroids.sort_custom(SorterAsteroidsByProb, "sort_ascending")

func destroy_all_asteroids() -> void:
	for ast in get_children():
		if ast.is_in_group("asteroid"):
			ast.queue_free()



