"""=============================================
File: class_biomon.gd
"""

class_name ClassBiomon

# Set up signals

# Set up constants
const GENE_SAVAGE_MAX = 30
const GENE_MAX = 60
const GENE_QUOTA_MAX = 1500

# Set up variables
#var unique_key:String = "" # Unique key of the biomon in the save folder
var species_key:String = "1"
var species:String = "" #
var gender:String = ""
var datamon:Dictionary = {}
var name:String = ""
var shiny:bool = false # shiny or not

var affection:int = 0
var level:int = 1
var xp:int = 0

var stats:Dictionary = {
	"hp": 0,
	"att": 0,
	"def": 0,
	"spa": 0,
	"spd": 0,
	"vit": 0
	}
var genes:Dictionary = stats
var current_genes_total:int = 0
var nature:String = "Solitaire"
var learnset:Dictionary = {}

func _init(new_biomon_dict):
	assert("species_key" in new_biomon_dict.keys() == true, "No species provided !")
	
	assert(new_biomon_dict.species_keys in DataRead.database.biodex.keys() == true,  "Inexistant species '" + new_biomon_dict.species_keys + "' !")

	if !"level" in new_biomon_dict.keys():
		datamon.level = 1
	
	if "genes" in new_biomon_dict.keys():
		genes = new_biomon_dict.genes
	else:
		genes = generate_genes()
	
	if "nature" in new_biomon_dict.keys():
		nature = new_biomon_dict.nature
	else: 
		nature = DataRead.get_random_nature()
	
	calculate_stats()
	
	if !"species" in datamon.keys():
		datamon.species = DataRead.database.biodex[datamon.species_key].name
		
	if !"name" in datamon.keys():
		name = species
		
	if !"gender" in datamon.keys():
		set_gender()
	
	datamon.learnset = DataRead.database.biodex.learnset
	
	if !"moves_keys" in datamon.keys():
		generate_moveset()
	
	print("\n =====")
	print("Biomon '" + name + "' (" + species + ") created !")
	print("Level : " + str(level))
	print("Genes : " + str(genes))
	print("Nature : " + nature)
	print("Stats : " + str(stats))
	print("Gender : " + gender)


func change_name(new_name):
	name = new_name

func xp_gain(value):
	pass

func on_level_up():
	pass
	
func calculate_stats():
	for key in stats.keys():
		if key == "hp":
			stats.key = (
				floor(0.01 
				* (2 * DataRead.get_base_stats_dictionary(species_key)[key] + genes[key] * level)) 
				+ 10 + level
				)
		else:
			stats.key = (
				floor(0.01 
				* (2 * DataRead.get_base_stats_dictionary(species_key)[key] 
				+ genes[key] * level) + 5) 
				* DataRead.get_nature_dictionary(nature)[key])

func load_sprite(target_node, side, mini):
	target_node.select_sprite(species_key, false, shiny, side, mini)

func generate_genes():
	var rand_gene = RandomNumberGenerator.new()
	rand_gene.randomize
	current_genes_total = 0
	for key in genes.keys():
		genes[key] = rand_gene.randi_range(0, GENE_SAVAGE_MAX)
		current_genes_total += genes[key]
	
func update_gene(stat, value):
	if current_genes_total + value >= GENE_QUOTA_MAX:
		value = GENE_QUOTA_MAX - current_genes_total
	elif genes[stat] + value <= 0:
		value += abs(value) - genes[stat]
	
	genes[stat] += value
	current_genes_total += value

func set_gender():
	var random_rate = RandomNumberGenerator.new()
	random_rate.randomize
	if DataRead.database.biomon.gender_rate == -1:
		gender = "Genderless"
	elif random_rate.randf_range(0, 1) <= DataRead.database.biomon.gender_rate:
		gender = "Male"
	else:
		gender = "Female"

func generate_moveset():
	var temp = level
	datamon.moves_keys = []
	
	while (datamon.moves_keys.size() < 4) and (temp > 0):
		if temp in learnset.l.keys():
			datamon.moves_keys.append(learnset.l.temp)
		temp = temp - 1
