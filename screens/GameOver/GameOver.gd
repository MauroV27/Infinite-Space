extends Control

func _on_Restart_pressed() -> void:
	var ok = get_tree().reload_current_scene()
	get_tree().paused = false
	if ok != OK:
		print("A erro in transition ( game over -> game ) has been detect!")

func _on_BackToMenu_pressed() -> void:
	var ok = get_tree().change_scene("res://screens/Menu/Menu.tscn")
	get_tree().paused = false
	if ok != OK:
		print("A erro in transition ( game over -> menu ) has been detect!")

func count_distance(distance:float) -> void:
	var max_dist = "%06d" % int(distance)
	$Distance.text = "Distance: " + str(max_dist)
	
	var record = SaveAndLoad.load_data().record
	
	if distance > record:
		var new_record = {"record": int(distance)}
		print("Novo recorde: ", new_record)
		SaveAndLoad.save_data(new_record)

