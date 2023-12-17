extends Node

### region global constants ###
const ROOM_PATH: String = "res://scenes/room.tscn";
### end region global constants ###

enum Types {
	ATK,
	DEF,
	REGEN,
	SPEED,
	DASH_CD
	WIPE,
	UNLIMITED_DASHES
}

###PLAYER STATE THAT NEEDS TO BE KEPT###
var playerHealth = 100;
var dashCooldown = 6;
var hasUnlimitedDashes = false;
########################################

### region global variables ###
var _currentGold: int = 0;
var _numberHeroesUnlocked: int = 1;
var _heroesUnlocked: Array = ["knight"];
var _currentFloor: int = 1;
var _hasKonamiCheats: bool = false;
### end region global variables ###

# warning-ignore:unused_signal
signal blinkEnemyLightHandler(enemyId, didEnter);

### region helper functions ###
func setupGame() -> void:
	_currentGold = 0 if (!_hasKonamiCheats) else 5000;
	_numberHeroesUnlocked = 1;
	_heroesUnlocked = ["knight"];
	_currentFloor = 1;

func subtractFromCurrentGold(goldToSubtract: int) -> void:
	_currentGold -= goldToSubtract;

func addToCurrentGold(goldToAdd: int) -> void:
	_currentGold += goldToAdd;

func addHeroToUnlocked(newHero: String) -> void:
	if newHero in _heroesUnlocked:
		return;
	_heroesUnlocked.append(newHero);

func incrementCurrentFloor() -> void:
	_currentFloor += 1;

func getRoomPartitions() -> int:
	#TODO: Test more than 4 partition lol
	return 4;

func getEnemySpawnTimes() -> Array:
	if _currentFloor == 1:
		return [5.0,10.0];
	elif _currentFloor == 2:
		return [4.0,8.0];
	elif _currentFloor == 3:
		return [3.0,7.0];
	return [2.0, 6.0];

func getBasicEnemyHealth() -> int:
	if _currentFloor == 1:
		return 10;
	elif _currentFloor == 2:
		return 15;
	elif _currentFloor == 3:
		return 30;
	return 30 + ((_currentFloor - 3) * 20);

func getBlinkEnemyHealth() -> int:
	if _currentFloor == 1:
		return 20;
	elif _currentFloor == 2:
		return 30;
	elif _currentFloor == 3:
		return 50;
	return 50 + ((_currentFloor - 3) * 20);
### end region helper functions ###

### region getter/setter functions ###
func getCurrentGold() -> int:
	return _currentGold;

func setCurrentGold(goldValue: int) -> void:
	_currentGold = goldValue;

func getNumberHeroesUnlocked() -> int:
	return _numberHeroesUnlocked;

func setNumberHeroesUnlocked(newHeroCount: int) -> void:
	_numberHeroesUnlocked = newHeroCount;

func getHeroesUnlocked() -> Array:
	return _heroesUnlocked;

func setHeroesUnlocked(heroesArray: Array) -> void:
	_heroesUnlocked = heroesArray;

func getCurrentFloor() -> int:
	return _currentFloor;

func setCurrentFloor(newFloor: int):
	_currentFloor = newFloor;

func getKonamiValue() -> bool:
	return _hasKonamiCheats;

func setKonamiValue(value: bool):
	_hasKonamiCheats = value;
### end region getter/setter functions ###
