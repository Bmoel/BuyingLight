extends Node2D

onready var playerLocationSprite = $playerLocation;
onready var exitLocationSprite = $exit;

const MAP_LENGTH: int = 40000;
const MINIMAP_LENGTH: int = 200;

func playerMoved(newLocation: Vector2):
	var xPos = abs((newLocation.x / MAP_LENGTH) * MINIMAP_LENGTH);
	var yPos = abs((newLocation.y / MAP_LENGTH) * MINIMAP_LENGTH);
	playerLocationSprite.position = Vector2(xPos, yPos);

func exitFound(location: Vector2):
	exitLocationSprite.show();
	var xPos = abs((location.x / MAP_LENGTH) * MINIMAP_LENGTH);
	var yPos = abs((location.y / MAP_LENGTH) * MINIMAP_LENGTH);
	exitLocationSprite.position = Vector2(xPos, yPos);

func _on_PlayerBlink_timeout():
	playerLocationSprite.visible = !playerLocationSprite.visible;
