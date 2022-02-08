extends Area2D

var life : int = 1
var scores_values : int = 10
var speed : int = 40
var rotate_speed : float = 0.0
var max_life : int = life

func create_asteroid(asteroid:Resource, min_x:int, max_x:int, bonus_speed:int) -> void:
	position.x = min_x + randf() * max_x
	position.y = -80 - ( randf() * 60 )
	
	rotation_degrees = randi() % 90
	rotate_speed = rand_range(-15, 15)
	
	speed += (bonus_speed * asteroid.speed_increase )
	
	life = asteroid.life
	scores_values = asteroid.scores
	$Sprite.modulate = asteroid.color
	var ast_size : Vector2 = Vector2(asteroid.size, asteroid.size)
	$Sprite.scale = ast_size * 2
	$CollisionShape2D.scale = ast_size
	
	max_life = life
	$Particles2D.modulate = asteroid.color
	$Particles2D.scale = Vector2(1, 1) + (ast_size * 0.5)


func asteroid_life_pos_laser(laser_damage:int) -> int:
	# This functions will be called when laser collide with asteroid
	life = life - laser_damage
	play_impact_sound()
	
	return life

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
	
	draw_particles()
	
	if life <= 0:
		$Sprite.visible = false
		$CollisionShape2D.set_deferred("disabled", true) 

func _on_SoundImpact_finished() -> void:
	if life <= 0:
		queue_free()

func draw_particles() -> void:
	var particles_amount : int = max(max_life - life, 0) 
	$Particles2D.set_amount(8 * (particles_amount + 1) )
	$Particles2D.set_one_shot(true)
	$Particles2D.set_emitting(true)
