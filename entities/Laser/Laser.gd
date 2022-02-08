extends Area2D

export var laser_damage : int = 1
var speed : int = 200

signal laser_has_collide(scores_values)

func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_Laser_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroid"):
		var asteroid_new_life = area.asteroid_life_pos_laser(laser_damage)
		
		if asteroid_new_life == 0:
			emit_signal("laser_has_collide", area.scores_values)
			queue_free()
		elif asteroid_new_life < 0:
			emit_signal("laser_has_collide", area.scores_values)
			laser_damage = asteroid_new_life * (-1)
		else:
			queue_free()

