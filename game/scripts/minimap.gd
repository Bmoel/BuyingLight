extends Node2D

onready var playerLocationSprite = $playerLocation;
onready var exitLocationSprite = $exit;

func playerMoved(newLocation: Vector2):
	playerLocationSprite.show();
	var x = newLocation.x / 40;
	var y = newLocation.y / 40;
	playerLocationSprite.position = Vector2(x,y);

func exitFound(location: Vector2):
	exitLocationSprite.show();
	var x = location.x / 40;
	var y = location.y / 40;
	exitLocationSprite.position = Vector2(x,y);
