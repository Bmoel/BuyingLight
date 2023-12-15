extends Node

###Trait Array Meaning###
#[type, value]
#########################

###Trait Types###
#1: Atk up
#2: Def up
#3: Regen health
#4: Speed up
#5: Invulnerability
#6: Unlock Archer
#7: Unlock Shotgunner
#8: Wipe Out All Enemies 
#################

enum Odds {
	UNCOMMON,
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

var traitChancesPerRoom: Array = [
	{
		Odds.UNCOMMON: 80,
		Odds.COMMON: 15,
		Odds.RARE: 5,
		Odds.EPIC: 0,
		Odds.LEGENDARY: 0
	},
	{
		Odds.UNCOMMON: 60,
		Odds.COMMON: 30,
		Odds.RARE: 10,
		Odds.EPIC: 0,
		Odds.LEGENDARY: 0
	},
	{
		Odds.UNCOMMON: 50,
		Odds.COMMON: 35,
		Odds.RARE: 10,
		Odds.EPIC: 5,
		Odds.LEGENDARY: 0
	},
	{
		Odds.UNCOMMON: 40,
		Odds.COMMON: 35,
		Odds.RARE: 15,
		Odds.EPIC: 8,
		Odds.LEGENDARY: 2
	},
]

const commonTraits: Dictionary = {
	"Attack Up": [1, 5],
	"Defense Up": [2, 5],
	"Regen Health": [3,5],
	"Speed Up": [4,5],
}

const uncommonTraits: Dictionary = {
	"Attack Up": [1, 10],
	"Defense Up": [2, 10],
	"Regen Health": [3, 10],
	"Speed Up": [4, 10],
}

const rareTraits: Dictionary = {
	"Attack Up": [1, 15],
	"Defense Up": [2, 15],
	"Regen Health": [3, 15],
	"Speed Up": [4, 15],
	"One Hit Invulnerability": [5, 1],
	"Unlock Archer Hero": [6, 1],
}

const epicTraits: Dictionary = {
	"Attack Up": [1, 20],
	"Defense Up": [2, 20],
	"Regen Health": [3, 20],
	"Speed Up": [4, 20],
	"Unlock Shotgunner Hero": [7, 1]
}

const legendaryTraits: Dictionary = {
	"Attack Up": [1, 25],
	"Defense Up": [2, 25],
	"Regen Health": [3, 25],
	"Speed Up": [4, 25],
	"Wipe Out All Enemies": [8, 1]
}

func getShopOdds(roomNum: int) -> Dictionary:
	var traitChancesLen: int = len(traitChancesPerRoom);
	if roomNum > traitChancesLen || roomNum < 0:
		roomNum = traitChancesLen - 1;
	return traitChancesPerRoom[roomNum];

func getTraits(rarity: int) -> Dictionary:
	match rarity:
		Odds.UNCOMMON: return uncommonTraits;
		Odds.COMMON: return commonTraits;
		Odds.RARE: return rareTraits;
		Odds.EPIC: return epicTraits;
		Odds.LEGENDARY: return legendaryTraits;
		_: return uncommonTraits;

func getRarityText(rarity: int) -> String:
	match rarity:
		Odds.UNCOMMON: return "Uncommon";
		Odds.COMMON: return "Common";
		Odds.RARE: return "Rare";
		Odds.EPIC: return "Epic";
		Odds.LEGENDARY: return "Epic";
		_: return "";

func getRarityColor(rarity: int) -> String:
	match rarity:
		Odds.UNCOMMON: return "#c1c1c1";
		Odds.COMMON: return "#6abe30";
		Odds.RARE: return "#639bff";
		Odds.EPIC: return "#924bae";
		Odds.LEGENDARY: return "#ece54b";
		_: return "#ffffff";
