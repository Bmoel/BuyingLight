extends Node2D

onready var player = $PlayerAndUI/Character;
onready var enemySpawner = $EnemySpawner;

const ROOM_LENGTH = 40000;
const TOO_CLOSE_LENGTH = 400;
const RANDOMIZER_ATTEMPS = 10;

var _exitPosition: Vector2 = Vector2.ZERO;

signal playerMovedRoom(newPosition);

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	enemySpawner.connect("spawnEnemy", self, "_spawnEnemy");
	$PlayerAndUI.connect("playerMovedUI", self, "_playerMoved");
	player.position = generateRandomPosition();
	var exitPosition: Vector2 = generateRandomPosition();
	var attempts: int = 1;
	while exitIsTooCloseToPlayerStart(exitPosition, player.position):
		exitPosition = generateRandomPosition();
		attempts += 1;
		if attempts > RANDOMIZER_ATTEMPS:
			break;
	setExitPosition(exitPosition);
	enemySpawner.initiate();

func exitIsTooCloseToPlayerStart(
	exitPosition: Vector2, 
	playerPosition: Vector2
) -> bool:
	var xTooClose: bool = abs(exitPosition.x - playerPosition.x) < TOO_CLOSE_LENGTH;
	var yTooClose: bool = abs(exitPosition.y - playerPosition.y) < TOO_CLOSE_LENGTH;
	return (xTooClose or yTooClose);

func generateRandomPosition() -> Vector2:
	return Vector2(randi() % ROOM_LENGTH, randi() % ROOM_LENGTH);

func setExitPosition(newPosition: Vector2) -> void:
	_exitPosition = newPosition;

func _spawnEnemy(newEnemy):
	newEnemy.position = generateRandomPosition();
	newEnemy.setRoom(self);
	add_child(newEnemy);

func _playerMoved(newPosition) -> void:
	emit_signal("playerMovedRoom", newPosition);
