extends Node2D

onready var player = $PlayerAndUI/Character;
onready var enemySpawner = $EnemySpawner;
onready var ui = $PlayerAndUI;

const ROOM_LENGTH = 40000;
const TOO_CLOSE_LENGTH = 400;
const RANDOMIZER_ATTEMPS = 10;

var _exitPosition: Vector2 = Vector2.ZERO;
var _roomLightArray: Array = [];
var _roomLightTrackerArray: Array = [];

var lightTexture = preload("res://assets/light.webp");

signal playerMovedRoom(newPosition);

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	## CONNECTIONS ##
	# warning-ignore:return_value_discarded
	enemySpawner.connect("spawnEnemy", self, "_spawnEnemy");
	# warning-ignore:return_value_discarded
	ui.connect("boughtRevealUI", self, "_boughtReveal");
	# warning-ignore:return_value_discarded
	$PlayerAndUI.connect("playerMovedUI", self, "_playerMoved");
	## END CONNECTIONS ##
	player.position = generateRandomPosition();
	var roomExit = getRoomExit();
	setExitPosition(roomExit);
	setRoomLightArrays();
	enemySpawner.initiate();

func setRoomLightArrays() -> void:
	var partition = getRoomPartitions();
	ui.setMinimapPartitions(partition);
	var partFloat = float(partition);
	var rmLen = float(ROOM_LENGTH);
	var multiplier = rmLen/partFloat;
	var padding = multiplier/2.0;
	var resultArr: Array = [];
	var trackerArr: Array = [];
	var textureScaleVal: float = getTextureScaleVal(partFloat);
	var idx: int = 0;
	for i in range(partition):
		for j in range(partition):
			var light: Light2D = Light2D.new();
			light.texture = lightTexture;
			light.texture_scale = textureScaleVal;
			light.energy = 2.5;
			light.position = Vector2(
				(multiplier*i) + padding, 
				(multiplier*j) + padding
			);
			resultArr.append(light);
			trackerArr.append(idx);
			idx += 1;
	## Set Global variables
	_roomLightArray = resultArr;
	_roomLightTrackerArray = trackerArr;

func getRoomExit() -> Vector2:
	var exitPosition: Vector2 = generateRandomPosition();
	var attempts: int = 1;
	while exitIsTooCloseToPlayerStart(exitPosition, player.position):
		exitPosition = generateRandomPosition();
		attempts += 1;
		if attempts > RANDOMIZER_ATTEMPS:
			break;
	return exitPosition;
	

func exitIsTooCloseToPlayerStart(
	exitPosition: Vector2, 
	playerPosition: Vector2
) -> bool:
	var xTooClose: bool = abs(exitPosition.x - playerPosition.x) < TOO_CLOSE_LENGTH;
	var yTooClose: bool = abs(exitPosition.y - playerPosition.y) < TOO_CLOSE_LENGTH;
	return (xTooClose or yTooClose);

func generateRandomPosition() -> Vector2:
	return Vector2(randi() % ROOM_LENGTH, randi() % ROOM_LENGTH);

func getRoomPartitions() -> int:
	var currentFloor: int = Global.getCurrentFloor();
	match(currentFloor):
		1: return 4;
		2: return 4;
		3: return 6;
		4: return 6;
		5: return 8;
		6: return 8;
		_: return 10;

func getTextureScaleVal(partition: float) -> float:
	var rmLen = float(ROOM_LENGTH);
	return (rmLen/partition)/256.0;

func turnLightOn(idx: int) -> void:
	if idx > len(_roomLightArray):
		return;
	var lightObj = _roomLightArray[idx];
	$LightHolder.add_child(lightObj);
	ui.revealMinimapPartition(idx);

func setExitPosition(newPosition: Vector2) -> void:
	_exitPosition = newPosition;

func _spawnEnemy(newEnemy):
	newEnemy.position = generateRandomPosition();
	newEnemy.setRoom(self);
	add_child(newEnemy);

func _playerMoved(newPosition) -> void:
	emit_signal("playerMovedRoom", newPosition);

func _boughtReveal() -> void:
	var numLightsLeft = len(_roomLightTrackerArray);
	if numLightsLeft <= 0:
		return;
	var randNum: int = randi() % numLightsLeft;
	var lightIdx: int = _roomLightTrackerArray[randNum];
	turnLightOn(lightIdx);
	_roomLightTrackerArray.remove(randNum);
