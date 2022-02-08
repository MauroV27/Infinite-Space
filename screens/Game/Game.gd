extends Node2D

""" Game controller """

const LASER = preload("res://entities/Laser/Laser.tscn")

export(Curve) var curve_progress 

const MAX_DISTANCE_INCREASE : float = 4.2
const DISTANCE_LIMIT_TO_INCREASE : int = 500

var distance : float = 0.0
var distance_increase : float = 0.08

func _ready() -> void:
	randomize()
	$BaseScreen/SpaceStoreScreen.visible = false
	$BaseScreen/GameOver.visible = false
	
	curve_progress.set_point_value(0, distance_increase)
	$asteroids.distance_limit_to_increase = DISTANCE_LIMIT_TO_INCREASE
	
	$Timer.start()
	$AnimationPlayer.play("Game Start")
#	show_space_store_screen(true) ## DEBUG

func change_background_speed(new_speed:float) -> void:
	var texture_shader = $SpaceStars.get_material();
	texture_shader.set("shader_param/Speed", clamp(new_speed, 0.02, 0.25))

func _physics_process(delta: float) -> void:
	distance += ( delta * distance_increase)
	$Player/HUD.distance = distance
	
	if distance_increase < MAX_DISTANCE_INCREASE:
		var clamp_dist = clamp(distance, 0, DISTANCE_LIMIT_TO_INCREASE)
		distance_increase = curve_progress.interpolate(clamp_dist/DISTANCE_LIMIT_TO_INCREASE) * MAX_DISTANCE_INCREASE
		change_background_speed(distance_increase/20.0)
	

func _on_Player_create_bullet(pos:Vector2) -> void:
	var laser = LASER.instance()
	laser.connect("laser_has_collide", $Player, "laser_has_collide")

	laser.laser_damage = $Player.player_status.laser_damage
	laser.position = pos 
	$lasers.add_child(laser)

func spawn_asteroid() -> void:
	var bonus_speed = (distance_increase * 30) + (min(distance, DISTANCE_LIMIT_TO_INCREASE)/4)
	$asteroids.create_asteroid(bonus_speed)

func _on_Timer_timeout() -> void:
	var time : float = 1.0 - (distance_increase/MAX_DISTANCE_INCREASE)
	$Timer.wait_time = clamp(time, 0.3, 1.0)
	$Timer.start()
	spawn_asteroid()

func _on_UpdateAsteroidsProb_timeout() -> void:
	$asteroids.update_asteroids_probability(distance)
	
	if distance >= DISTANCE_LIMIT_TO_INCREASE:
		$UpdateAsteroidsProb.stop()


func show_space_store_screen(show) -> void:
	stop_game(show)
	$BaseScreen/SpaceStoreScreen.visible = show
	if show:
		$Player.enter_in_SpaceStore()
		$BaseScreen/SpaceStoreScreen.set_player($Player)
		$BaseScreen/SpaceStoreScreen.load_elements_in_store()
		# Destroy all asteroids when player enter in space store
		$asteroids.destroy_all_asteroids()
		
		for laser in $lasers.get_children():
			laser.queue_free()
	else:
		$Player.position = Vector2(640, 432)
		$SpaceStore.position = Vector2(640, 640)

func Player_dead() -> void:
	stop_game(true)
	$BaseScreen/GameOver.visible = true
	$BaseScreen/GameOver.count_distance(distance)

func stop_game(pause:bool) -> void:
	# Activated when the SpaceStore or GameOver screen appear
	get_tree().paused = pause


