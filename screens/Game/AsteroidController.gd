extends Node

const ASTEROID = preload("res://src/entities/Asteroid/Asteroid.tscn")

const AST_T1 = preload("res://src/entities/Asteroid/AsteroidsTypes/AsteroidType_1.tres")
const AST_T2 = preload("res://src/entities/Asteroid/AsteroidsTypes/AsteroidType_2.tres")
const AST_T3 = preload("res://src/entities/Asteroid/AsteroidsTypes/AsteroidType_3.tres")
const AST_T4 = preload("res://src/entities/Asteroid/AsteroidsTypes/AsteroidType_4.tres")

var asteroids : Array = [AST_T1, AST_T2, AST_T3, AST_T4]

func create_asteroid(bonus_speed) -> void:
	var asteroid_instance = ASTEROID.instance()
	var asteroid_type : Resource = asteroids[ randi() % len(asteroids) ]
	
	asteroid_instance.create_asteroid(asteroid_type, 80, 1120, bonus_speed)
	add_child(asteroid_instance)
