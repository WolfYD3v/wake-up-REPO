extends Node3D

@onready var all_simulations: Node3D = $AllSimulations

var simulation_pos: Vector3 = Vector3.ZERO
var simulations_folder_path: String = "res://scenes/simulations/all_simulations/"

func _ready() -> void:
	#_list_simulations()
	pass

func _list_simulations() -> void:
	for simulation_name: String in DirAccess.get_files_at(simulations_folder_path):
		var simulation_loaded = load(simulations_folder_path + simulation_name)
		#var simulation = simulation_loaded
		all_simulations.add_child(simulation_loaded.get_local_scene())
		simulation_pos.y += 20
