extends ClassBiomon

enum GenesPreSets {RANDOM, RANDOM_LOW, RANDOM_HIGH, ZERO, 
					FAST_PHYSICAL, FAST_SPECIAL, BULK_PHYSICAL, BULK_SPECIAL, 
					DEFENSIVE_BALANCE, DEFENSIVE_PHYSICAL, DEFENSIVE_SPECIAL }

export (String) var biomon = ''
export (GenesPreSets) var genes_set = GenesPreSets.RANDOM


func _ready():
	pass
