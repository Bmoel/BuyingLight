extends Node

const Types = Global.Types;

enum Odds {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

var traitChancesPerRoom: Array = [
	{
		Odds.COMMON: 80,
		Odds.UNCOMMON: 15,
		Odds.RARE: 5,
		Odds.EPIC: 0,
		Odds.LEGENDARY: 0
	},
	{
		Odds.COMMON: 60,
		Odds.UNCOMMON: 30,
		Odds.RARE: 10,
		Odds.EPIC: 0,
		Odds.LEGENDARY: 0
	},
	{
		Odds.COMMON: 50,
		Odds.UNCOMMON: 35,
		Odds.RARE: 10,
		Odds.EPIC: 5,
		Odds.LEGENDARY: 0
	},
	{
		Odds.COMMON: 40,
		Odds.UNCOMMON: 35,
		Odds.RARE: 15,
		Odds.EPIC: 8,
		Odds.LEGENDARY: 2
	},
]

#Trait Array Meanings: [type, value]

const commonTraits: Dictionary = {
	"Attack Up": [Types.ATK, 2],
	"Defense Up": [Types.DEF, 2],
	"Regen Health": [Types.REGEN, 2],
	"Speed Up": [Types.SPEED, 2],
}

const uncommonTraits: Dictionary = {
	"Attack Up": [Types.ATK, 5],
	"Defense Up": [Types.DEF, 5],
	"Regen Health": [Types.REGEN, 5],
	"Speed Up": [Types.SPEED, 5],
}

const rareTraits: Dictionary = {
	"Attack Up": [Types.ATK, 10],
	"Defense Up": [Types.DEF, 10],
	"Regen Health": [Types.REGEN, 10],
	"Speed Up": [Types.SPEED, 10],
}

const epicTraits: Dictionary = {
	"Attack Up": [Types.ATK, 15],
	"Defense Up": [Types.DEF, 15],
	"Regen Health": [Types.REGEN, 15],
	"Speed Up": [Types.SPEED, 15],
	"Dash Cooldown Down": [Types.DASH_CD, 1]
}

const legendaryTraits: Dictionary = {
	"Attack Up": [Types.ATK, 25],
	"Defense Up": [Types.DEF, 25],
	"Regen Health": [Types.REGEN, 25],
	"Speed Up": [Types.SPEED, 25],
	"Wipe Out All Enemies": [Types.WIPE, 1],
	"Unlimited Dashes": [Types.UNLIMITED_DASHES, 1]
}

func getShopOdds(roomNum: int) -> Dictionary:
	var traitChancesLen: int = len(traitChancesPerRoom);
	if roomNum > traitChancesLen || roomNum < 0:
		roomNum = traitChancesLen - 1;
	return traitChancesPerRoom[roomNum];

func getTraits(rarity: int) -> Dictionary:
	match rarity:
		Odds.COMMON: return commonTraits;
		Odds.UNCOMMON: return uncommonTraits;
		Odds.RARE: return rareTraits;
		Odds.EPIC: return epicTraits;
		Odds.LEGENDARY: return legendaryTraits;
		_: return uncommonTraits;

func getRarityText(rarity: int) -> String:
	match rarity:
		Odds.COMMON: return "Common";
		Odds.UNCOMMON: return "Uncommon";
		Odds.RARE: return "Rare";
		Odds.EPIC: return "Epic";
		Odds.LEGENDARY: return "Legendary";
		_: return "";

func getRarityColor(rarity: int) -> String:
	match rarity:
		Odds.COMMON: return "#c1c1c1";
		Odds.UNCOMMON: return "#6abe30";
		Odds.RARE: return "#639bff";
		Odds.EPIC: return "#924bae";
		Odds.LEGENDARY: return "#ece54b";
		_: return "#ffffff";
