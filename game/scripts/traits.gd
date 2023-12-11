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

var traitChancesPerRoom: Array = [
	[80, 15, 5, 0, 0],
	[60, 30, 10, 0, 0],
	[50, 35, 10, 4, 1],
	[]
]

var commonTraits: Dictionary = {
	"Attack Up": [1, 5],
	"Defense Up": [2, 5],
	"Regen Health": [3,5],
	"Speed Up": [4,5],
}

var uncommonTraits: Dictionary = {
	"Attack Up": [1, 10],
	"Defense Up": [2, 10],
	"Regen Health": [3, 10],
	"Speed Up": [4, 10],
}

var rareTraits: Dictionary = {
	"Attack Up": [1, 15],
	"Defense Up": [2, 15],
	"Regen Health": [3, 15],
	"Speed Up": [4, 15],
	"One Hit Invulnerability": [5, 1],
	"Unlock Archer Hero": [6, 1],
}

var epicTraits: Dictionary = {
	"Attack Up": [1, 20],
	"Defense Up": [2, 20],
	"Regen Health": [3, 20],
	"Speed Up": [4, 20],
	"Unlock Shotgunner Hero": [7, 1]
}

var legendaryTraits: Dictionary = {
	"Attack Up": [1, 25],
	"Defense Up": [2, 25],
	"Regen Health": [3, 25],
	"Speed Up": [4, 25],
	"Wipe Out All Enemies": [8, 1]
}
