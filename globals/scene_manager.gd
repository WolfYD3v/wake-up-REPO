extends Node


var _scenes: Dictionary[String, Node] = {
	"actual": null,
	"global_game": null,
	"main_menu": null
}

func add_scene_to_scenes(scene_id_name: String, scene_node: Node) -> void:
	if not _scenes.has(scene_id_name):
		_scenes.set(scene_id_name, scene_node)
		_scenes.set("actual", scene_node)
		get_scene("global_game").add_child(scene_node)
		get_scene("global_game").move_child(get_scene("actual"), 0)
		#var nodes_nb_in_global_game: int = get_scene("global_game").get_child_count()
		#get_scene("global_game").move_child(get_scene("transitions"), nodes_nb_in_global_game - 1)

func set_scene(scene_id_name: String, scene_node: Node) -> void:
	if _scenes.has(scene_id_name):
		_scenes.set(scene_id_name, scene_node)
		_scenes.set("actual", scene_node)

func get_scene(scene_id_name: String) -> Node:
	if _scenes.has(scene_id_name):
		return _scenes.get(scene_id_name)
	return null

func show_scene(scene_id_name: String) -> void:
	if _scenes.has(scene_id_name):
		_scenes.get(scene_id_name).show()

func hide_scene(scene_id_name: String) -> void:
	if _scenes.has(scene_id_name):
		_scenes.get(scene_id_name).hide()

func change_scene(scene_id_name: String) -> void:
	if _scenes.has("actual"):
		hide_scene("actual")
		show_scene(scene_id_name)
