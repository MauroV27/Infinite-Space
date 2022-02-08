extends Control

onready var block_panel = $BlockPanel

export var item : Resource = ShopItemData
export var data : Resource = BaseData
export var item_icon : Texture = null

var level_value : int = 0
var price : int = 500
var updateValue: int = 1

signal button_pressed(name, price, value)

const STATE_BLOCK_PANEL : Dictionary = {
	"cant_buy" : Color(1,0,0, 0.25),
	"is_max" : Color(0,0,1, 0.25)
}

func _ready() -> void:
	update_shop_state()
	$TextureRect.texture = item_icon

func get_level_data() -> void:
	if item.has_level:
		level_value = data.get_level()
		
		var level_data = data.get_level_data(level_value)
		price = level_data.price
		updateValue = level_data.value
		
		update_shop_state()

func reset_level() -> void:
	if item.has_level:
		data.reset_level()
		$BuyButton.disabled = false

func update_shop_state() -> void:
	$Name.text = item.item_name
	$BuyButton.text = "$" + str(price)
	$PopupPanel/Label.text = item.tool_tip_text
	
	$level.visible = item.has_level
	$level.text = "LEVEL:" + str(level_value)
	if item.has_level:
		if data.level_is_max():
			$level.text = str("LEVEL: MAX")
			$BuyButton.text = "MAX"
			$BuyButton.disabled = true

func _on_BuyButton_pressed() -> void:
	emit_signal("button_pressed", item.item_id, price, updateValue)

func _on_buy_response(response_shop_id:String, player_scores:int) -> void:
	if item.has_level and response_shop_id == item.item_id:
		data.update_level()
		get_level_data()
	
	player_can_buy(player_scores)

func player_can_buy(player_scores:int)->void:
	if player_scores < price:
		block_panel.visible = true#player_scores < price
		block_panel.modulate = STATE_BLOCK_PANEL.cant_buy
	else:
		block_panel.visible = false
		
	if item.has_level:
		if data.level_is_max():
			block_panel.visible = true
			block_panel.modulate = STATE_BLOCK_PANEL.is_max

func _on_Item_mouse_entered() -> void:
	$PopupPanel.rect_global_position = get_global_mouse_position()
	$PopupPanel.visible = true

func _on_Item_mouse_exited() -> void:
	$PopupPanel.visible = false

