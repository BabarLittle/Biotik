extends Node2D

enum GenesPreSets {
	BALANCED, FAST_PHYSICAL, FAST_SPECIAL, BULK_PHYSICAL,
	BULK_SPECIAL, DEFENSIVE_BALANCE, DEFENSIVE_PHYSICAL, 
	DEFENSIVE_SPECIAL, SUPPORT, RANDOM 
	}
	
enum GenesTypes {LOW, MID, HIGH}

# Set up constants
const GENE_SAVAGE_MAX = 30
const GENE_MAX = 60
const GENE_QUOTA_MAX = 270


export(String) var species = ""
export (int, 1, 100) var level:int = 5
export (GenesPreSets) var genes_set = GenesPreSets.RANDOM
export (GenesTypes) var genes_type = GenesTypes.MID

var biomon_dict = {}


func get_biomon_dictionary():
	var dict = {}
	
	if species in DataRead.database.biodex.keys():
		dict.species_key = species
	elif DataRead.get_id_from_name(species) == null:
		return null
	else:
		dict.species = species
		dict.species_key = DataRead.get_id_from_name(species)
	
	
	dict.level = level
	dict.genes = generate_genes()
	
	return dict


func generate_genes():
	var genes_base = 0
	var genes_increment = GENE_SAVAGE_MAX % 2
	var current_genes_total = 0
	var genes = {
		"hp": 0,
		"att": 0,
		"def": 0,
		"spa": 0,
		"spd": 0,
		"vit": 0
		}
	
	match genes_type:
		GenesTypes.LOW:
			genes_base = GENE_SAVAGE_MAX % 2
		GenesTypes.MID:
			genes_base = 1 * GENE_SAVAGE_MAX
		GenesTypes.HIGH:
			genes_base = 2 * GENE_SAVAGE_MAX
		
	match genes_set:
		GenesPreSets.RANDOM:
			var rand_gene = RandomNumberGenerator.new()
			rand_gene.randomize()
			current_genes_total = 0
			for key in genes.keys():
				genes[key] = rand_gene.randi_range(0, GENE_SAVAGE_MAX)
				current_genes_total += genes[key]
		GenesPreSets.BALANCED:
			for key in genes.keys():
				genes.key = genes_base
		GenesPreSets.BULK_PHYSICAL:
			genes.hp = genes_base + genes_increment                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
			genes.att = genes_base + genes_increment
			genes.def = genes_base
			genes.spa = genes_base - genes_increment
			genes.spd = genes_base
			genes.vit = genes_base - genes_increment
		GenesPreSets.BULK_SPECIAL:
			genes.hp = genes_base + genes_increment
			genes.att = genes_base - genes_increment
			genes.def = genes_base
			genes.spa = genes_base + genes_increment
			genes.spd = genes_base
			genes.vit = genes_base - genes_increment
		GenesPreSets.DEFENSIVE_BALANCE:
			genes.hp = genes_base
			genes.att = genes_base - genes_increment
			genes.def = genes_base + genes_increment
			genes.spa = genes_base - genes_increment
			genes.spd = genes_base + genes_increment
			genes.vit = genes_base
		GenesPreSets.DEFENSIVE_PHYSICAL:
			genes.hp = genes_base + genes_increment
			genes.att = genes_base - genes_increment
			genes.def = genes_base + genes_increment
			genes.spa = genes_base - genes_increment
			genes.spd = genes_base
			genes.vit = genes_base
		GenesPreSets.DEFENSIVE_SPECIAL:
			genes.hp = genes_base + genes_increment
			genes.att = genes_base - genes_increment
			genes.def = genes_base
			genes.spa = genes_base - genes_increment
			genes.spd = genes_base + genes_increment
			genes.vit = genes_base
		GenesPreSets.FAST_PHYSICAL:
			genes.hp = genes_base
			genes.att = genes_base + genes_increment
			genes.def = genes_base 
			genes.spa = genes_base - genes_increment
			genes.spd = genes_base - genes_increment
			genes.vit = genes_base + genes_increment
		GenesPreSets.FAST_SPECIAL:
			genes.hp = genes_base
			genes.att = genes_base - genes_increment
			genes.def = genes_base - genes_increment 
			genes.spa = genes_base + genes_increment
			genes.spd = genes_base
			genes.vit = genes_base + genes_increment
		GenesPreSets.SUPPORT:
			genes.hp = genes_base + genes_increment
			genes.att = genes_base - genes_increment
			genes.def = genes_base
			genes.spa = genes_base - genes_increment
			genes.spd = genes_base
			genes.vit = genes_base + genes_increment
			
	return genes
