extends Node2D

func _input(_event):
	if Input.is_action_just_pressed("buy_visibility"):
		$ShopContainer/buttonHolder/Reveal.pressed = true;
		_on_Reveal_pressed();
	elif Input.is_action_just_pressed("buy_roll"):
		_on_Roll_pressed();
	elif Input.is_action_just_pressed("buy_upgrade1"):
		_on_upgrade1_pressed();
	elif Input.is_action_just_pressed("buy_upgrade2"):
		_on_upgrade2_pressed();
	elif Input.is_action_just_pressed("buy_upgrade3"):
		_on_upgrade3_pressed();
	elif Input.is_action_just_pressed("buy_upgrade4"):
		_on_upgrade4_pressed();

func _on_Reveal_pressed():
	$ShopContainer/buttonHolder/Reveal.release_focus();

func _on_Roll_pressed():
	pass
	#$ShopContainer/buttonHolder/Roll.release_focus();

func _on_upgrade1_pressed():
	$ShopContainer/rollButtons/upgrade1.release_focus();

func _on_upgrade2_pressed():
	$ShopContainer/rollButtons/upgrade2.release_focus();

func _on_upgrade3_pressed():
	$ShopContainer/rollButtons/upgrade3.release_focus();

func _on_upgrade4_pressed():
	$ShopContainer/rollButtons/upgrade4.release_focus();
