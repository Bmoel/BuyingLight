extends Node2D

onready var buttons = $WholeShop/ShopContainer/rollButtons;
onready var rarities = $WholeShop/Rarities;
onready var revealButton = $WholeShop/ShopContainer/buttonHolder/Reveal;
onready var rollButton = $WholeShop/ShopContainer/buttonHolder/Roll;
onready var upgrade1Button = $WholeShop/ShopContainer/rollButtons/upgrade1;
onready var upgrade2Button = $WholeShop/ShopContainer/rollButtons/upgrade2;
onready var upgrade3Button = $WholeShop/ShopContainer/rollButtons/upgrade3;
onready var upgrade4Button = $WholeShop/ShopContainer/rollButtons/upgrade4;

const REVEAL_COST = 4;
const ROLL_COST = 2;
const NUM_UPGRADES = 4;
const NUM_ODDS = 5;

var upgradeCosts: Array = [];

var Traits = null;

signal boughtReveal(cost);

func _ready():
	randomize();
	var traitsPreload = preload("res://scripts/traits.gd");
	Traits = traitsPreload.new();
	setUpgrades();

func canBuy(cost: int) -> bool:
	return cost <= Global.getCurrentGold();

func enableAllButtons() -> void:
	for button in buttons.get_children():
		button.disabled = false;
		button.mouse_filter = Button.MOUSE_FILTER_STOP;
		var backsplash = button.get_child(2);
		backsplash.hide();

func setUIRarities() -> void:
	var currentFloor: int = Global.getCurrentFloor();
	var shopOdds: Dictionary = Traits.getShopOdds(currentFloor - 1);
	var oddsValues = shopOdds.values();
	var idx: int = 0;
	for rarityRichText in rarities.get_children():
		rarityRichText.text = str(oddsValues[idx]) + "%";
		idx += 1;

func setUpgrades() -> void:
	var currentFloor: int = Global.getCurrentFloor();
	var shopOdds: Dictionary = Traits.getShopOdds(currentFloor - 1);
	var upgradeRarities: Array = [];
	#################################################
	for _i in range(NUM_UPGRADES):
		var randNum: float = rand_range(0.0, 100.0);
		var place: float = 0.0;
		var j: int = 0;
		for odd in shopOdds.values():
			if isValidShopOdd(place, place + odd, randNum):
				upgradeRarities.append(j);
				break;
			j += 1;
			place += odd;
	#################################################
	var upgradeData: Array = [];
	for rarity in upgradeRarities:
		var potentialUpgrades: Dictionary = Traits.getTraits(rarity);
		var upgradesValues: Array = potentialUpgrades.values();
		var upgradesTitles: Array = potentialUpgrades.keys();
		var idx: int = randi() % len(potentialUpgrades);
		var values = upgradesValues[idx];
		var title = upgradesTitles[idx];
		upgradeData.append([rarity, title, values]);
	#################################################
	var buttonIdx: int = 0;
	upgradeCosts.clear();
	for button in buttons.get_children():
		var buttonData = upgradeData[buttonIdx];
		var rarity = buttonData[0];
		var goldBox: RichTextLabel = button.get_child(1);
		goldBox.bbcode_text = str(rarity+1) + "[color=#e6c829]G[/color]";
		upgradeCosts.append(rarity+1);
		var descBox: RichTextLabel = button.get_child(0);
		descBox.bbcode_text = getButtonText(rarity, buttonData[1], buttonData[2]);
		buttonIdx += 1;

func getButtonText(rarity: int, title: String, _values: Array) -> String:
	var rarityColor = Traits.getRarityColor(rarity);
	var rarityTitle = Traits.getRarityText(rarity);
	var finalText: String = "[color=" + rarityColor + "]";
	finalText += rarityTitle + "[/color]\n";
	finalText += title;
	return finalText;

func isValidShopOdd(startRange: float, endRange:float, randNum: float) -> bool:
	return randNum >= startRange and randNum <= endRange;

func _on_Reveal_pressed():
	revealButton.release_focus();
	if !canBuy(REVEAL_COST): return;
	emit_signal("boughtReveal", REVEAL_COST);

func _on_Roll_pressed():
	rollButton.release_focus();
	if !canBuy(ROLL_COST): return;
	Global.subtractFromCurrentGold(ROLL_COST);
	enableAllButtons();
	setUpgrades();

func _on_upgrade1_pressed():
	upgrade1Button.release_focus();
	var cost = getUpgradeCost(0);
	if !canBuy(cost): return;
	upgrade1Button.disabled = true;
	upgrade1Button.mouse_filter = Button.MOUSE_FILTER_IGNORE;
	var backsplash = upgrade1Button.get_child(2);
	backsplash.show();

func _on_upgrade2_pressed():
	upgrade2Button.release_focus();
	var cost = getUpgradeCost(1);
	if !canBuy(cost): return;
	upgrade2Button.disabled = true;
	upgrade2Button.mouse_filter = Button.MOUSE_FILTER_IGNORE;
	var backsplash = upgrade2Button.get_child(2);
	backsplash.show();

func _on_upgrade3_pressed():
	upgrade3Button.release_focus();
	var cost = getUpgradeCost(2);
	if !canBuy(cost): return;
	upgrade3Button.disabled = true;
	upgrade3Button.mouse_filter = Button.MOUSE_FILTER_IGNORE;
	var backsplash = upgrade3Button.get_child(2);
	backsplash.show();

func _on_upgrade4_pressed():
	upgrade4Button.release_focus();
	var cost = getUpgradeCost(3);
	if !canBuy(cost): return;
	upgrade4Button.disabled = true;
	upgrade4Button.mouse_filter = Button.MOUSE_FILTER_IGNORE;
	var backsplash = upgrade4Button.get_child(2);
	backsplash.show();

func getUpgradeCost(buttonIdx: int) -> int:
	if buttonIdx >= len(upgradeCosts) || buttonIdx < 0:
		return 1;
	return upgradeCosts[buttonIdx];
