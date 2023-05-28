extends Panel

onready var lb_name = get_node("%LbName")
onready var lb_lvl = get_node("%LbLvl2")
onready var lb_nature = get_node("%LbNature")
onready var lb_hp = get_node("%LbHp2")
onready var lb_att = get_node("%LbAtt2")
onready var lb_def = get_node("%LbDef2")
onready var lb_spa = get_node("%LbSpa2")
onready var lb_spd = get_node("%LbSpd2")
onready var lb_vit = get_node("%LbVit2")


func load_infos(biomon_obj):
	if biomon_obj == null:
		pass
	else:
		lb_name.text = biomon_obj.biomon_name
		lb_lvl.text = biomon_obj.level
		lb_nature.text = biomon_obj.nature
		lb_hp.text = biomon_obj.stats.hp
		lb_att.text = biomon_obj.stats.att
		lb_def.text = biomon_obj.stats.def
		lb_spa.text = biomon_obj.stats.spa
		lb_spd.text = biomon_obj.stats.spd
		lb_vit.text = biomon_obj.stats.vit
