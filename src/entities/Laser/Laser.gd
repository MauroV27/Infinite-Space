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
		if area.asteroid_has_destroyed(laser_damage):
			emit_signal("laser_has_collide", area.scores_values)
		queue_free()

