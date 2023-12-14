extends Node2D

const REVEAL_COST = 4;
const ROLL_COST = 2;

signal boughtReveal();

func canBuy(cost: int) -> bool:
	return cost <= Global.getCurrentGold();

func _on_Reveal_pressed():
	if canBuy(REVEAL_COST):
		Global.subtractFromCurrentGold(REVEAL_COST);
		emit_signal("boughtReveal");
	$ShopContainer/buttonHolder/Reveal.release_focus();

func _on_Roll_pressed():
	if canBuy(ROLL_COST):
		Global.subtractFromCurrentGold(ROLL_COST);
	$ShopContainer/buttonHolder/Roll.release_focus();

func _on_upgrade1_pressed():
	$ShopContainer/rollButtons/upgrade1.release_focus();

func _on_upgrade2_pressed():
	$ShopContainer/rollButtons/upgrade2.release_focus();

func _on_upgrade3_pressed():
	$ShopContainer/rollButtons/upgrade3.release_focus();

func _on_upgrade4_pressed():
	$ShopContainer/rollButtons/upgrade4.release_focus();
