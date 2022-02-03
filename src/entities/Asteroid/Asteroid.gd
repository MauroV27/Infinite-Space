extends Area2D

var life : int = 1
var scores_values : int = 10
var speed : int = 40
var rotate_speed : float = 0.0

func create_asteroid(asteroid:Resource, min_x:int, max_x:int, bonus_speed:int) -> void:
	position.x = min_x + randf() * max_x
	position.y = -20 + ( randf() * -60 )
	
	rotation_degrees = randi() % 90
	rotate_speed = rand_range(-15, 15)
	
	speed += (bonus_speed * asteroid.speed_increase )
	
	life = asteroid.life
	scores_values = asteroid.scores
	$Sprite.modulate = asteroid.color
	scale = Vector2(asteroid.size, asteroid.size)


func asteroid_has_destroyed(laser_damage:int) -> bool:
	# This functions will be called when laser collide with asteroid
	life -= laser_damage
	play_impact_sound()
	return life <= 0

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	rotation_degrees += rotate_speed * delta

func impact_with_player() -> void:
	life = 0
	play_impact_sound()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func play_impact_sound() -> void:
	$SoundImpact.play()
	if life <= 0:
		visible = false
		$CollisionShape2D.set_deferred("disabled", true) 

func _on_SoundImpact_finished() -> void:
	if life <= 0:
		queue_free()
