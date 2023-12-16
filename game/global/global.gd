extends Node

### region global constants ###
const ROOM_PATH: String = "res://scenes/room.tscn";
### end region global constants ###

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
	_currentGold = 10 if (!_hasKonamiCheats) else 5000;
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
	match(_currentFloor):
		1: return 4;
		2: return 4;
		3: return 6;
		4: return 6;
		5: return 8;
		6: return 8;
		_: return 10;
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
