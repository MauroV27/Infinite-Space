extends Node2D

""" Game controller """

const LASER = preload("res://src/entities/Laser/Laser.tscn")

export(Curve) var curve_progress 

const MAX_DISTANCE_INCREASE : float = 5.0
const DISTANCE_LIMIT_TO_INCREASE : int = 500

var distance : float = 0.0
var distance_increase : float = 0.08

func _ready() -> void:
	randomize()
	$BaseScreen/SpaceStoreScreen.visible = false
	$BaseScreen/GameOver.visible = false
	
	curve_progress.set_point_value(0, distance_increase)
	
	$AnimationPlayer.play("Game Start")
#	show_space_store_screen(true) ## DEBUG

func change_background_speed(new_speed:float) -> void:
	var texture_shader = $SpaceStars.get_material();
	texture_shader.set("shader_param/Speed", clamp(new_speed, 0.05, 0.5))

func _physics_process(delta: float) -> void:
	distance += ( delta * distance_increase)
	$Player/HUD.distance = distance
	$Player/HUD.dist_incrment = distance_increase ## REMOVE THIS
	
	if distance_increase < MAX_DISTANCE_INCREASE:
		var clamp_dist = clamp(distance, 0, DISTANCE_LIMIT_TO_INCREASE)
		distance_increase = curve_progress.interpolate(clamp_dist/DISTANCE_LIMIT_TO_INCREASE) * MAX_DISTANCE_INCREASE
		change_background_speed(distance_increase/10.0)
	

func _on_Player_create_bullet(pos:Vector2) -> void:
	## DEBUG --
	var clamp_dist = clamp(distance, 0, DISTANCE_LIMIT_TO_INCREASE)
	print("POW: ", curve_progress.interpolate(clamp_dist/DISTANCE_LIMIT_TO_INCREASE) * MAX_DISTANCE_INCREASE)
	## --------
	var laser = LASER.instance()
	laser.connect("laser_has_collide", $Player, "laser_has_collide")

	laser.laser_damage = $Player.player_status.laser_damage
	laser.position = pos 
	$lasers.add_child(laser)

func spawn_asteroid() -> void:
	var bonus_speed = (distance_increase * 30) + (min(distance, 500)/2) ## bonus max = 150 + 250 = 400
	$asteroids.create_asteroid(bonus_speed)

func _on_Timer_timeout() -> void:
	spawn_asteroid()

func show_space_store_screen(show) -> void:
	stop_game(show)
	$BaseScreen/SpaceStoreScreen.visible = show
	if show:
		$BaseScreen/SpaceStoreScreen.set_player($Player)
		$BaseScreen/SpaceStoreScreen.load_elements_in_store()
		# Destroy all asteroids when player enter in space store
		for ast in $asteroids.get_children():
			ast.queue_free()
		
		for laser in $lasers.get_children():
			laser.queue_free()
	else:
		$Player.position = Vector2(640, 432)
		$SpaceStore.position = Vector2(640, 576)

func Player_dead() -> void:
	stop_game(true)
	$BaseScreen/GameOver.visible = true
	$BaseScreen/GameOver.count_distance(distance)

func stop_game(pause:bool) -> void:
	# Activated when the SpaceStore or GameOver screen appear
	get_tree().paused = pause

