extends Node2D

onready var playerLocationSprite = $playerLocation;
onready var exitLocationSprite = $exit;

const MAP_LENGTH: int = 40000;
const MINIMAP_LENGTH: int = 200;

var _clrRectArr: Array = [];
var _boundaryArr: Array = [];
var _isLitArr: Array = [];

var lighterTexture = preload("res://assets/minimapPlayer.png");
var darkerTexture = preload("res://assets/minimapPlayerWhenLight.png");

func resetMinimapDeps() -> void:
	_clrRectArr = [];
	_boundaryArr = [];
	_isLitArr = [];

func playerMoved(newLocation: Vector2):
	var xPos = abs((newLocation.x / MAP_LENGTH) * MINIMAP_LENGTH);
	var yPos = abs((newLocation.y / MAP_LENGTH) * MINIMAP_LENGTH);
	playerLocationSprite.position = Vector2(xPos, yPos);
	playerLocationSprite.texture = darkerTexture if spriteInLight(xPos, yPos) else lighterTexture;

func exitFound(location: Vector2):
	exitLocationSprite.show();
	var xPos = abs((location.x / MAP_LENGTH) * MINIMAP_LENGTH);
	var yPos = abs((location.y / MAP_LENGTH) * MINIMAP_LENGTH);
	exitLocationSprite.position = Vector2(xPos, yPos);

func resetExit() -> void:
	exitLocationSprite.hide();
	exitLocationSprite.position = Vector2.ZERO;

func revealPartition(idx: int) -> void:
	if idx > len(_clrRectArr):
		return;
	_clrRectArr[idx].show();
	_isLitArr[idx] = true;
	

func setPartitions(partition: int) -> void:
	var rmLen = float(MINIMAP_LENGTH);
	var partFloat = float(partition);
	var multiplier = rmLen/partFloat;
	var clrArr = [];
	for i in range(partition):
		for j in range(partition):
			var clrRect = ColorRect.new();
			clrRect.rect_size = Vector2(multiplier, multiplier);
			clrRect.rect_position = Vector2(
				(multiplier*i), 
				(multiplier*j)
			);
			clrRect.color = Color(255,255,255,5);
			$clrRectHolder.add_child(clrRect);
			clrRect.hide();
			clrArr.append(clrRect);
			_boundaryArr.append([
				[multiplier*i,multiplier*(i+1)],
				[multiplier*j,multiplier*(j+1)]
			]);
			_isLitArr.append(false);
	_clrRectArr = clrArr;

func spriteInLight(x: int, y: int) -> bool:
	var idx: int = 0;
	for boundaries in _boundaryArr:
		var xBounds = boundaries[0];
		var yBounds = boundaries[1];
		if (x > xBounds[0] and x <= xBounds[1]) and (y > yBounds[0] and y <= yBounds[1]):
			return _isLitArr[idx];
		idx += 1;
	return false;

func _on_PlayerBlink_timeout():
	playerLocationSprite.visible = !playerLocationSprite.visible;
