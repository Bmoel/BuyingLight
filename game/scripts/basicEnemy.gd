extends KinematicBody2D

var _playerPosition: Vector2 = Vector2.ZERO;
var _justHit: int = 4;
var _isDead: bool = false;
var _goldAmount = 1;

var velocity: Vector2 = Vector2.ZERO;
var baseSpeed:int = 2500;
var baseHealth:int = 10;

var room = null;

const NUM_BLINKS: int = 4;
const TIME_BTWN_BLINKS: float = 0.25;

var tmr: float = 0;
func _process(delta):
	if room == null:
		return;
	velocity = position.direction_to(_playerPosition) * baseSpeed;
	velocity = move_and_slide(velocity);
	tmr += delta;
	if _justHit < NUM_BLINKS and tmr > TIME_BTWN_BLINKS:
		tmr = 0;
		visible = !visible;
		_justHit += 1;
	elif _justHit >= NUM_BLINKS:
		tmr = 0;

func setRoom(newRoom) -> void:
	room = newRoom;
	room.connect("playerMovedRoom", self, "_playerMoved");

func takeDamage(dmgAmount: int) -> void:
	baseHealth -= dmgAmount;
	$enemyHit.play();
	if baseHealth <= 0:
		_isDead = true;
		self.hide();
		Global.addToCurrentGold(_goldAmount);
		return;
	_justHit = 0;

func _playerMoved(newPosition) -> void:
	_playerPosition = newPosition;

func _on_enemyHit_finished():
	if _isDead:
		queue_free();
