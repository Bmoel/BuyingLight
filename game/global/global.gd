extends Node

### region global variables ###
var _currentGold: int = 0;
var _numberHeroesUnlocked: int = 1;
var _heroesUnlocked: Array = ["knight"];
var _currentFloor: int = 1;
#end region global variables

### region helper functions ###
func setupGame() -> void:
	_currentGold = 10;

func subtractFromCurrentGold(goldToSubtract: int) -> void:
	_currentGold -= goldToSubtract;

func addToCurrentGold(goldToAdd: int) -> void:
	_currentGold += goldToAdd;

func addHeroToUnlocked(newHero: String) -> void:
	if newHero in _heroesUnlocked:
		return;
	_heroesUnlocked.append(newHero);
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
### end region getter/setter functions ###
