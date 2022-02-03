extends KinematicBody2D

var player_status = {
	"life" : 3,
	"max_life" : 3, # 3, (4, 100), (5, 200), (6, 320), (7, 500)
	"player_vulnerable" : true,
	"speed" : 55, # 80, (100, 25), (120, 80), (150, 120), (180, 200), (240, 300), (300, 500)
	"scores" : 0,
	"energy" : 55.0,
	"energy_cost" : 60.0,	# 60, (55, 80), (50, 120), (45, 180), (40, 250), (35. 320), (30, 450)
	"energy_speed" : 12.0,  # 12, (15, 50), (18, 80), (25, 150), (30, 200), (45, 300), (50, 500)
	"laser_damage" : 1	# 1, (2, 150), (3, 250), (4, 350)
}

const ACELERATION : int = 50
const FRICTION : int = 150

var motion : Vector2 = Vector2.ZERO

signal life_change
signal scores_change
signal energy_per_shoot_change
signal create_bullet
signal player_dead

func _ready() -> void:
	update_scores(0)
	update_life(0)
	update_energy_per_shoot(player_status.energy_cost)

func _physics_process(delta: float) -> void:
	shoot_energy(delta)
	shoot()
	
	var move : Vector2 = move()
	
	if move == Vector2.ZERO:
		move = move.move_toward(Vector2.ZERO, FRICTION)
	else:
		move = move.move_toward(move * player_status.speed, ACELERATION)
		
	motion = move_and_slide(move)


func move() -> Vector2:
	var dir = Vector2(
		int(Input.get_action_strength("right")) - int(Input.get_action_strength("left")),
		int(Input.get_action_strength("down")) - int(Input.get_action_strength("up"))
	)
	return dir.normalized()


func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		if player_status.energy >= player_status.energy_cost:
			player_status.energy -= player_status.energy_cost
			
			$LaserSound.play()
			emit_signal("create_bullet", global_position)
		else:
			$ShootFailed.play()


func shoot_energy(delta: float) -> void:
	player_status.energy += player_status.energy_speed * delta
	player_status.energy = min(player_status.energy, 100.0)
	
	$HUD.update_progress_bar(player_status.energy)


func update_life(new_life:int) -> void:
	player_status.life += new_life
	emit_signal("life_change", player_status.life, player_status.max_life)
	
	if player_status.life <= 0:
		emit_signal('player_dead')


func update_scores(new_scores) -> void:
	player_status.scores += new_scores
	emit_signal("scores_change", player_status.scores)

func update_energy_per_shoot(new_value:int) -> void:
	emit_signal("energy_per_shoot_change", new_value)

func increase_status(status_param:String, increase_value:int) -> void:
	player_status[status_param] = increase_value
	
	if status_param == "energy_cost":
		update_energy_per_shoot(increase_value)


func laser_has_collide(scores_values:int) -> void:
	update_scores(scores_values)


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroid") and player_status.player_vulnerable:
		update_life(-1)
		$DamageSound.play()
		
		player_status.player_vulnerable = false
		$AnimationPlayer.play("damage")
		
		area.impact_with_player()


func player_invulnerable_finished() -> void:
	player_status.player_vulnerable = true

func _on_SpaceStoreScreen_buy_item(new_p_status:Dictionary) -> void:
	player_status = new_p_status
	player_status.player_vulnerable = true
	player_status.energy = 100.0
	
	update_life(0)
	update_scores(0)
	$HUD.update_progress_bar(player_status.energy)
