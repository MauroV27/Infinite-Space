extends Area2D

var moving : bool = true
var speed : int = 120

signal enter_in_Space_Store(show)

func _ready() -> void:
	reset_position()
	change_state(false)

func _physics_process(delta: float) -> void:
	position.y += speed * delta

func reset_position() -> void:
	position.x = 1200 - ( randf() * 1120)
	position.y = -200 - ( randf() * 60 )

func change_state(state:bool) -> void:
	moving = state
	
#	set_physics_process(moving) ## DEBUG

func _on_VisibilityNotifier2D_screen_exited() -> void:
	change_state(false) 
	reset_position() 

func _on_SpaceStore_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("enter_in_Space_Store", true)
