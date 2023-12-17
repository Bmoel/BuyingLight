extends KinematicBody2D

var _playerPosition: Vector2 = Vector2.ZERO;
var _obfuscatedPosition: Vector2 = Vector2.ZERO;
var _isDead: bool = false;
var _goldAmount = 3;
var _isInPlayerLight: bool = false;
var _isInRoomLight: bool = false;
var _damageToDeal: int = 15;
var _roomLightTrackerArray = [];

var velocity: Vector2 = Vector2.ZERO;
var baseSpeed:int = 250;
var baseHealth:int = 20;

var room = null;

const NUM_BLINKS: int = 4;
const TIME_BTWN_BLINKS: float = 0.25;
const TIME_BTWN_OBFUSCATING: float = 1.5;
const ROOM_LENGTH = 40000;

var obfuscaterTimer: float = TIME_BTWN_OBFUSCATING;

func _ready():
	randomize();
	$AnimatedSprite.play("default");
	# warning-ignore:return_value_discarded
	Global.connect("blinkEnemyLightHandler", self, "_onEnemyHandleLight");
	var lightTimer = Timer.new();
	lightTimer.wait_time = 2.0;
	lightTimer.one_shot = false;
	lightTimer.connect("timeout", self, "_flickerLight");
	add_child(lightTimer);
	lightTimer.start();

func _process(delta):
	if room == null:
		return;
	obfuscaterTimer += delta;
	if obfuscaterTimer >= TIME_BTWN_OBFUSCATING:
		_obfuscatedPosition = _playerPosition + Vector2(
			_playerPosition.x + rand_range(-500.0, 500.0),
			_playerPosition.y + rand_range(-500.0, 500.0)
		);
		obfuscaterTimer = 0.0;
	var floorSpeed = baseSpeed + ((Global.getCurrentFloor()-1) * 50);
	velocity = position.direction_to(_playerPosition) * floorSpeed;
	velocity = move_and_slide(velocity);
	##########################################################
	if len(_roomLightTrackerArray) > 0:
		var partition = Global.getRoomPartitions();
		var partFloat = float(partition);
		var rmLen = float(ROOM_LENGTH);
		var multiplier = rmLen/partFloat;
		var idx = 0;
		for i in range(partition):
			for j in range(partition):
				if !(idx in _roomLightTrackerArray):
					var xRange = Vector2(multiplier*i, multiplier*(i+1));
					var validX = validRangeForCurrentPosition(xRange.x, xRange.y, self.position.x);
					var yRange = Vector2(multiplier*j, multiplier*(j+1));
					var validY = validRangeForCurrentPosition(yRange.x, yRange.y, self.position.y);
					_isInRoomLight = (validX and validY);
					if _isInRoomLight: break;
				idx += 1;
			if _isInRoomLight: break;
	else:
		_isInRoomLight = true;
	##############################################################
	if _isInRoomLight || _isInPlayerLight:
		$AnimatedSprite.visible = true;

func validRangeForCurrentPosition(
	minimum: float, 
	maximum:float, 
	current: float
) -> bool:
	return (current >= minimum) and (current <= maximum);

func setRoom(newRoom) -> void:
	room = newRoom;
	room.connect("playerMovedRoom", self, "_playerMoved");
	room.connect("roomLightTrackerChanged", self, "_lightArrChanged");

func setLightTrackerArray(newArr: Array) -> void:
	_roomLightTrackerArray = newArr;

func takeDamage(dmgAmount: int) -> void:
	baseHealth -= dmgAmount;
	$enemyHit.play();
	if baseHealth <= 0:
		_isDead = true;
		self.hide();
		Global.addToCurrentGold(_goldAmount);
		return;

func getDamageAmount() -> int:
	return _damageToDeal;

func death() -> void:
	queue_free();

func _playerMoved(newPosition) -> void:
	_playerPosition = newPosition;

func _on_enemyHit_finished():
	if _isDead:
		queue_free();

func _flickerLight() -> void:
	if _isInRoomLight and !$AnimatedSprite.visible:
		$AnimatedSprite.visible = true;
		return;
	if _isInPlayerLight || _isInRoomLight:
		return;
	$Light2D.visible = !$Light2D.visible;
	$AnimatedSprite.visible = !$AnimatedSprite.visible;

func _onEnemyHandleLight(id, isEnteringLight) -> void:
	if !self.has_method("get_instance_id"):
		return;
	if id != self.get_instance_id():
		return;
	if _isInRoomLight:
		return;
	_isInPlayerLight = isEnteringLight;
	$AnimatedSprite.visible = isEnteringLight;
	$Light2D.visible = isEnteringLight;

func _lightArrChanged(newArr: Array) -> void:
	_roomLightTrackerArray = newArr;
