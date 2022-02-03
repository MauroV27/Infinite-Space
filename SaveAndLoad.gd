extends Node2D

const SAVE_DIR = "user://saves/"
const ENCRYPT_KEY = "5up3r53cr3t"

var save_path = SAVE_DIR + "save.dat"

func save_data(_data:Dictionary) -> void:
	var data = _data
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, ENCRYPT_KEY)
	if error == OK:
		file.store_var(data)
		file.close()


func load_data():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, ENCRYPT_KEY)
		if error == OK:
			var record_data = file.get_var()
			file.close()
			return record_data
	else:
		return {"record":0}
