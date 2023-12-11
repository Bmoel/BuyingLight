extends Node

#region variables
var _currentGold: int = 0;
#end region variables

#region helper functions
func setupGame() -> void:
	_currentGold = 10;
#end region helper functions

#region getter/setter functions
func getCurrentGold() -> int:
	return _currentGold;

func setCurrentGold(goldValue: int) -> void:
	_currentGold = goldValue;
#end region getter/setter functions
