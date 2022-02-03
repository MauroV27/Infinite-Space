extends Control

onready var text = $RichTextLabel

var text_init_pos := Vector2(260, 550)
var text_end_pos := Vector2(260, 60)
var text_speed : int = 45
var char_size_total : int
var char_size : float = 0.0

func _ready() -> void:
	text.rect_position = text_init_pos
	char_size_total = text.get_total_character_count()
	
	set_process(false)

func force_see_cutscene(_record:int) -> void:
	$Continue.disabled = _record <= 0 ## Se o maior recorde for superior a zero

func _process(delta: float) -> void:
	text.visible_characters = int(char_size)
	char_size += text_speed * delta * 0.8
	
	if text.rect_position <= text_end_pos:
		$Continue.disabled = false
		set_process(false)
	else:
		text.rect_position.y -= text_speed * delta

func _on_Continue_pressed() -> void:
	var ok = get_tree().change_scene("res://screens/Game/Game.tscn")
	if ok != OK:
		print("A erro in transition ( menu/story -> game ) has been detect!")
