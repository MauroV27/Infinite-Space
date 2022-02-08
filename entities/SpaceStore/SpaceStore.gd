extends Area2D

const SPEED : int = 100
var moving : bool = true
var speed : int = 0

signal enter_in_Space_Store(show)

func _ready() -> void:
	randomize()
	reset_position()

func _physics_process(delta: float) -> void:
	position.y += speed * delta

func reset_position() -> void:
	position.x = 1200 - ( randf() * 1120)
	position.y = -600 - ( randf() * 200 )

func _on_VisibilityNotifier2D_screen_exited() -> void:
	reset_position() 
	$StoreWait.autostart = true
	speed = 0

func _on_SpaceStore_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		emit_signal("enter_in_Space_Store", true)

func _on_StoreWait_timeout() -> void:
	speed = SPEED
