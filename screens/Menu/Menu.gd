extends Control

onready var camera = $Camera2D

func _ready() -> void:
	show_record()

func show_record() -> void:
	var record = int(SaveAndLoad.load_data().record)
	var max_dist = "%06d" % record
	$Menu/RecordLabel.text = "Max Distance: " + str(max_dist)
	
	$Story.force_see_cutscene(record)

func _on_ButtonStart_pressed() -> void:
	set_camera_pos(Vector2(0, 720))
	button_click()
	$Story.set_process(true)

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_ButtonOptions_pressed() -> void:
	set_camera_pos(Vector2(1280, 0))
	button_click()

func _on_ButtonControls_pressed() -> void:
	set_camera_pos(Vector2(2560, 0))
	button_click()

func _on_ButtonCredits_pressed() -> void:
	set_camera_pos(Vector2(1280, 720))
	button_click()

func _on_ButtonBack_pressed() -> void:
	set_camera_pos(Vector2(0, 0))
	button_click()

func button_click() -> void:
	$ButtonClick.play()

func _on_BackToOptions_pressed() -> void:
	set_camera_pos(Vector2(1280, 0))
	button_click()

func set_camera_pos(_pos:Vector2) -> void:
	camera.position = _pos


func _on_RestartRecord_pressed() -> void:
	$OptionsScreen/ConfirmRestartRecord.visible = true

func _on_ConfirmRestartRecord_confirmed() -> void:
	print("recorde deletado")
	SaveAndLoad.save_data({"record":0})
	
	show_record()
