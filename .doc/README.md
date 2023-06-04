# -- BIOTIK --
Welcome to the Biotik project ! 
An alcoolic adaptation of pokemon.
This is a project launched by members and former members of the student association of biology in Geneva
It is mainly a fun project that we're doing together on our free time.
*insert text here*

LD, Babar, Dada, Ska, Ramen, Pierodactyl, Vasavi Shakti,

## About

## Documentation

### Game Structure

#### Classes

##### WIP

#### Special Nodes 

##### SceneManager

##### DialoguesManager

##### PartyManager

##### Player


#### Autoloads
Autoloads can be accessed from any scripts in the game.
##### Utils
Points toward important nodes using *"Utils.get_node()"* where *"node"* has to be replaced with the name of the node you're looking for.

```python
Utils.get_player() # Get the current active player node

Utils.get_scene_manager() # Basically get the root of the tree.

Utils.get_current_scene() # Return the child of the node "current_scene" which happens to be the... Current scene.

Utils.get_next_scene() # Return the scene that is being loaded if it exists. Otherwise returns null object.

Utils.get_party_manager() # Return the node that manages all the biomon the player has.

Utils.get_dialogue_manager() # Return the node that controls dialogues

Utils.get_game_timer() # Returns a pointer to the main Timer of the game. 

```
##### DataRead
Load all the game content related to biomons. In charges of the biodex, the type chart and the natures. The script in itself is a bit messy right now. It is one big dictionary of dictionaries. 
- database
  - biodex
  - type_chart
  - natures
The scripts also proposes a bunch of functions to manipulates and transform the data.

**NOTE** : *Maybe replace this by ingame integrated data to avoid users to have an easy access to the datas. Probably we could recycle this script to encrypt our json files*

###### Biodex
Holds generic informations about biomon species. Loaded from *"data/biodex.json"*. 

```python
DataRead.database.biodex # Direct reference to the biodex

DataRead.get_biodex(biomon_id) # returns informations about the specified biomon. If no information it returns the whole biodex.
## WARNING: this copy the data. It is not a reference ##
```

The data/biodex structure is the following: 
-biodex (dictionary)
  - key (STR of the biodex number of the biomon)
    - name: name of the species
	- ... WIP

##### BiodexManager

##### SaveManager

##### StoryManager

##### SettingsManager

##### EncounterManager

### Data Structures

#### JSon files

##### Biodex

##### Natures

##### Type_chart

##### Encounters

##### Dialogues

#### BSV files

