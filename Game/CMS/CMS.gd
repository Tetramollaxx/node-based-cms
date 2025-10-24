extends Node
class_name CMS

## Load a resource or null
static func load_resource(path: String):
	if ResourceLoader.exists(path):
		return ResourceLoader.load(path)
	return null

## save res
static func save_resource(res: Resource, to_path: String):
	return ResourceSaver.save(res, to_path)


## get all .tres files in directory (for example all card.tres in Game/Entities/Cards/)
static func get_resources_in_directory(path: String) -> Array[String]:
	var file_paths: Array[String] = []
	var loaded: PackedStringArray = ResourceLoader.list_directory(path)
	for i in loaded:
		if i.ends_with(".tres"):
			file_paths.append(path + i)
	return file_paths

## get all .tscn files in directory (for example all card.tscn in Game/Entities/Cards/)
static func get_scenes_in_directory(path : String) -> Array[String]:
	var file_paths: Array[String] = []
	var loaded: PackedStringArray = ResourceLoader.list_directory(path)
	for i in loaded:
		if i.ends_with(".tscn"):
			file_paths.append(path + i)
	return file_paths