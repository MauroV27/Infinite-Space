extends CanvasLayer

onready var energyBar = $Control/ProgressBar

var life_value : int = 0
var max_life : int = 3
var scores_value : int = 0
var energy_per_shoot : float 
var distance : float = 0.0

const RECT_SIZE = 72

func _process(delta: float) -> void:
	$Control/dist.text = str(int(distance))

func update_progress_bar(energy:float) -> void:
	energyBar.value = energy
	
	if energy < energy_per_shoot:
		energyBar.modulate = Color(0.8, 0.8, 0.8)
	else:
		energyBar.modulate = Color(1, 1, 1)

func _on_Player_life_change(_life:int, _max_life: int) -> void:
	life_value = _life
	max_life = _max_life
	
	$Control/MaxLifeBar.rect_size.x = RECT_SIZE * max_life
	$Control/LifeBar.rect_size.x = RECT_SIZE * life_value

func _on_Player_scores_change(scores:int) -> void:
	scores_value = scores
	$Control/scores.text = "scores: " + str(scores_value)

func update_energy_per_shoot(new_value:int) -> void:
	energy_per_shoot = new_value
