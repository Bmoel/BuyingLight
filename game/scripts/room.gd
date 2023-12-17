extends Node2D

onready var player = $PlayerAndUI/Character;
onready var enemySpawner = $EnemySpawner;
onready var ui = $PlayerAndUI;
onready var shop = $PlayerAndUI/CanvasLayer/shop;
onready var firstFloorInstr = $firstFloorHandle;

const ROOM_LENGTH = 40000;
const TOO_CLOSE_LENGTH = 400;
const RANDOMIZER_ATTEMPS = 10;
const MUSIC_OPTIONS = [
	"res://assets/roomSongs/Fantasy-Forest-Battle.mp3",
	"res://assets/roomSongs/Tower-Defense_Looping.mp3",
	"res://assets/roomSongs/Arcade-Adventures-2.mp3",
	"res://assets/roomSongs/Into-Battle_v001.mp3",
];

var _exitPosition: Vector2 = Vector2.ZERO;
var _roomLightArray: Array = [];
var _roomLightTrackerArray: Array = [];
var _exitIndexInLightArray: int = -1;

var firstFloorOptions = [
	Vector2(8000,8000),
	Vector2(32000,8000),
	Vector2(8000,32000),
	Vector2(32000,32000),
];

var lightTexture = preload("res://assets/whiteBlock.png");

signal playerMovedRoom(newPosition);
signal roomLightTrackerChanged(lightArr);

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	var currentFloor = Global.getCurrentFloor();
	var songPath = MUSIC_OPTIONS[(currentFloor-1) % 4];
	$bgMusic.stream = load(songPath);
	$bgMusic.play();
	## CONNECTIONS ##
	# warning-ignore:return_value_discarded
	enemySpawner.connect("spawnEnemy", self, "_spawnEnemy");
	# warning-ignore:return_value_discarded
	ui.connect("boughtRevealUI", self, "_boughtReveal");
	# warning-ignore:return_value_discarded
	$PlayerAndUI.connect("playerMovedUI", self, "_playerMoved");
	# warning-ignore:return_value_discarded
	$Exit.connect("playerExited", self, "_handleExit");
	# warning-ignore:return_value_discarded
	CharacterUpgrades.connect("wipeEnemies", self, "_wipeAllEnemies");
	# warning-ignore:return_value_discarded
	firstFloorInstr.connect("showInstructions", ui, "_handleInstructions");
	# warning-ignore:return_value_discarded
	firstFloorInstr.connect("startGame", self, "_onGameStartFrom1st");
	## END CONNECTIONS ##
	player.position = generateRandomPosition();
	var roomExit;
	if currentFloor != 1:
		roomExit = getRoomExit();
	else:
		roomExit = firstFloorOptions[randi() % 4];
	setExitPosition(roomExit);
	setRoomLightArrays();
	shop.setUIRarities();
	if currentFloor == 1:
		firstFloorInstr.show();
		return;
	var spawnTimes = Global.getEnemySpawnTimes();
	enemySpawner.initiate(spawnTimes[0], spawnTimes[1]);

func setRoomLightArrays() -> void:
	var partition = Global.getRoomPartitions();
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
			if exitIsInZone(
				(multiplier*i),
				(multiplier*(i+1)),
				(multiplier*j),
				(multiplier*(j+1))
			):
				_exitIndexInLightArray = idx;
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
	if Global.getCurrentFloor() == 1:
		return Vector2(18110,18300);
	return Vector2(randi() % ROOM_LENGTH, randi() % ROOM_LENGTH);

func getTextureScaleVal(partition: float) -> float:
	var rmLen = float(ROOM_LENGTH);
	return (rmLen/partition)/256.0;

func turnLightOn(idx: int) -> void:
	if idx > len(_roomLightArray):
		return;
	var lightObj = _roomLightArray[idx];
	$LightHolder.add_child(lightObj);
	ui.revealMinimapPartition(idx);

func exitIsInZone(minX: float, maxX: float, minY: float, maxY: float) -> bool:
	var xValid: bool = false;
	var yValid: bool = false;
	if _exitPosition.x >= minX and _exitPosition.x <= maxX:
		xValid = true;
	if _exitPosition.y >= minY and _exitPosition.y <= maxY:
		yValid = true;
	return xValid and yValid;

func setExitPosition(newPosition: Vector2) -> void:
	_exitPosition = newPosition;
	$Exit.position = _exitPosition;

func getPositionClosishToPlayer() -> Vector2:
	var currentPlayerPos = $PlayerAndUI/Character.position;
	var xMargin: int = (randi() % 500) + 500;
	var xPos = getOKPos(currentPlayerPos.x, xMargin);
	var yMargin: int = (randi() % 500) + 500;
	var yPos = getOKPos(currentPlayerPos.y, yMargin);
	return Vector2(xPos,yPos);

func getOKPos(pos: int, margin: int) -> int:
	var marginMultiplier = -1 if (rand_range(0,1) < 0.5) else 1;
	margin *= marginMultiplier;
	var newPos = pos + margin;
	if validCoordinateNumber(newPos):
		return newPos;
	margin *= -1;
	newPos = pos + margin;
	if validCoordinateNumber(newPos):
		return newPos;
	return 20000;

func validCoordinateNumber(value: int) -> bool:
	return value > 0 and value < 40000;

func _spawnEnemy(newEnemy):
	newEnemy.position = getPositionClosishToPlayer();
	newEnemy.setRoom(self);
	$EnemyHolder.add_child(newEnemy);
	if newEnemy.has_method("setLightTrackerArray"):
		newEnemy.setLightTrackerArray(_roomLightTrackerArray);

func _playerMoved(newPosition) -> void:
	emit_signal("playerMovedRoom", newPosition);

func _boughtReveal(cost) -> void:
	var numLightsLeft = len(_roomLightTrackerArray);
	if numLightsLeft <= 0:
		return;
	var randNum: int = randi() % numLightsLeft;
	var lightIdx: int = _roomLightTrackerArray[randNum];
	turnLightOn(lightIdx);
	_roomLightTrackerArray.remove(randNum);
	emit_signal("roomLightTrackerChanged", _roomLightTrackerArray);
	Global.subtractFromCurrentGold(cost);
	if lightIdx == _exitIndexInLightArray:
		$Exit.show();
		$PlayerAndUI/CanvasLayer/minimap.exitFound(_exitPosition);

func _wipeAllEnemies() -> void:
	for enemy in $EnemyHolder.get_children():
		enemy.queue_free();

func _handleExit() -> void:
	Global.incrementCurrentFloor();
	get_tree().change_scene(Global.ROOM_PATH);

func _onGameStartFrom1st() -> void:
	firstFloorInstr.hide();
	$firstFloorHandle/isntr/CollisionShape2D.disabled = true;
	$firstFloorHandle/start/CollisionShape2D.disabled = true;
	var spawnTimes = Global.getEnemySpawnTimes();
	enemySpawner.initiate(spawnTimes[0], spawnTimes[1]);
