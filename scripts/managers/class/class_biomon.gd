tool
"""=============================================
File: class_biomon.gd
"""
extends Node2D

class_name ClassBiomon

# Set up constants
const GENE_SAVAGE_MAX = 30
const GENE_MAX = 60
const GENE_QUOTA_MAX = 270

# Set up variables
#var unique_key:String = "" # Unique key of the biomon in the save folder
var species_key:String = ""
var species:String = "" #
var gender:String = ""
#var datamon:Dictionary = {}
var biomon_name:String = name
var shiny:bool = false # shiny or not

export (String) var biomon = ''
var affection:int = 0
export (int, 1, 100) var level:int = 5
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
var nature:String = ""
var learnset:Dictionary = {}
var moves_keys: Array

func _init(new_biomon_dict={}):
	
	assert("species_key" in new_biomon_dict.keys(), "No species provided !")
	
	assert(new_biomon_dict.species_key in DataRead.database.biodex.keys(),  "Inexistant species '" + new_biomon_dict.species_key + "' !")

	species_key = new_biomon_dict.species_key 
	
	if !"level" in new_biomon_dict.keys():
		level = 1
	
	if "genes" in new_biomon_dict.keys():
		genes = new_biomon_dict.genes
	else:
		generate_genes()
	
	if "nature" in new_biomon_dict.keys():
		nature = new_biomon_dict.nature
	if nature == "": 
		nature = DataRead.get_random_nature()
	
	calculate_stats()
	
	if !"species" in new_biomon_dict.keys():
		species = DataRead.database.biodex[species_key].name
		
	if !"biomon_name" in new_biomon_dict.keys():
		biomon_name = species
		
	if !"gender" in new_biomon_dict.keys():
		set_gender()
	
	learnset = DataRead.load_learnset(species_key)
	
	if !"moves_keys" in new_biomon_dict.keys():
		generate_moveset()
	else:
		moves_keys = new_biomon_dict.moves_keys
	
	print("\n =====")
	print("Biomon '" + biomon_name + "' (" + species + ") created !")
	print("Level : " + str(level))
	print("Genes : " + str(genes))
	print("Nature : " + nature)
	print("Stats : " + str(stats))
	print("Gender : " + gender)


func change_biomon_name(new_name):
	biomon_name = new_name

func xp_gain(_value):
	pass

func on_level_up():
	pass
	
func calculate_stats():
	var base_stats = DataRead.get_base_stats_dictionary(species_key)
	var nature_dict = DataRead.get_nature_dictionary(nature)
	
	for key in stats.keys():
		if key == "hp":
			stats.key = (
				floor(0.01 
				* (2 * base_stats[key] + genes[key] * level)) 
				+ 10 + level
				)
		else:
			stats.key = (
				floor(0.01 
				* (2 * base_stats[key] 
				+ genes[key] * level) + 5) 
				* nature_dict[key])

func load_sprite(target_node, side, mini):
	target_node.select_sprite(species_key, false, shiny, side, mini)

func generate_genes():
	var genes_base = 0
	var genes_increment = GENE_SAVAGE_MAX % 2 
	var rand_gene = RandomNumberGenerator.new()
	
	rand_gene.randomize()
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
	random_rate.randomize()
	#if DataRead.database.biodex[species_key].gender_rate == -1:
	gender = "Genderless"
	#elif random_rate.randf_range(0, 1) <= DataRead.database.biodex.species_key.gender_rate:
	#	gender = "Male"
	#else:
	#	gender = "Female"

func generate_moveset():
	var temp = level
	moves_keys = []
	
	while (moves_keys.size() < 4) and (temp > 0):
		if temp in learnset.keys():
			moves_keys.append(learnset.l.temp)
		temp = temp - 1
