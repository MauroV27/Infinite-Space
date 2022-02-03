extends Control

onready var shop_area = $ShopSpace

var player : KinematicBody2D = null
var last_shop_id : String = ''

const RECT_SIZE : int = 72

signal exit_space_store(show)
signal buy_response(response_shop_id, player_scores)

func _ready() -> void:
	for shop in shop_area.get_children():
		if shop.is_in_group("SHOP"):
			shop.connect("button_pressed", self, "shop_button_pressed")
			connect("buy_response", shop, "_on_buy_response")
			shop.reset_level()


func set_player(_player:KinematicBody2D)-> void:
	player = _player


func load_elements_in_store() -> void:
	update_store_hud()
	
	var _scores = player.player_status.scores
	
	for buy in shop_area.get_children():
		buy.get_level_data()
		buy.player_can_buy(_scores)


func update_store_hud() -> void:
	$Scores.text = "Scores: " + str(player.player_status.scores)
	
	$MaxLifeBar.rect_size.x = RECT_SIZE * player.player_status.max_life
	$LifeBar.rect_size.x = RECT_SIZE * player.player_status.life
	

func _on_ExitStore_pressed() -> void:
	emit_signal("exit_space_store", false)

func can_buy(value:int) -> bool:
	return player.player_status.scores >= value

func update_scores(price:int) -> void:
	player.update_scores(-price)
	update_store_hud()
	emit_signal("buy_response", last_shop_id, player.player_status.scores)
	last_shop_id = ''

func shop_button_pressed(shop_id:String, price:int, updateValue:int) -> void:
	last_shop_id = shop_id
	match shop_id:
		'life':
			buy_life(price)
		'laserDamage':
			increase_laser_damage(price, updateValue)
		'moveSpeed':
			increase_move_speed(price, updateValue)
		'maxLife':
			increase_max_life(price,updateValue)
		'laserEnergy':
			reduce_energy_per_laser(price, updateValue)
		'reloadLaser':
			increase_laser_reload_speed(price, updateValue)

func buy_life(price:int) -> void:
	if can_buy(price):
		if player.player_status.life < ( player.player_status.max_life ):
			player.update_life(1)
			update_scores(price)

func increase_laser_damage(price:int,updateValue:int) -> void:
	if can_buy(price):
		player.increase_status("laser_damage", updateValue)
		update_scores(price)
	
func increase_max_life(price:int, updateValue:int) -> void:
	if can_buy(price):
		player.increase_status("max_life", updateValue)
		player.update_life(0)
		update_scores(price)

func reduce_energy_per_laser(price:int, updateValue:int) -> void:
	if can_buy(price):
		player.increase_status("energy_cost", updateValue)
		update_scores(price)

func increase_laser_reload_speed(price:int, updateValue:int) -> void:
	if can_buy(price):
		player.increase_status("energy_speed", updateValue)
		update_scores(price)

func increase_move_speed(price:int, updateValue:int) -> void:
	if can_buy(price):
		player.increase_status("speed", updateValue)
		update_scores(price)
