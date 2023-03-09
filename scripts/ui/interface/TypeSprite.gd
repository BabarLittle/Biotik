extends Sprite

var type_frame = {
	"NORMAL": 0, 
	"DRAGON": 1, 
	"ICE": 2, 
	"GRASS": 3, 
	"BUG": 4,
	"ROCK": 5,
	"WATER": 6,
	"FIGHTING": 7,
	"GROUND": 8,
	"FIRE": 9,
	"STEEL": 10,
	"FLYING": 11,
	"PSYCHIC": 12,
	"ELECTRIC": 13,
	"DARK": 14,
	"GHOST": 15,
	"FAIRY": 16,
	"POISON": 17,
	"WORK": 17,
	"ALCOHOL": 19,
	"NULL": 20
	}

func _ready():
	frame = 0

func load_type(type=""):
	frame = type_frame[type]
