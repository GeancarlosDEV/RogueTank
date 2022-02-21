extends Node2D

export(NodePath) var tilemap


# Called when the node enters the scene tree for the first time.
func _ready():
	if tilemap:
		tilemap = get_node(tilemap)
		if tilemap is TileMap:
			var area_size = (tilemap.cell_size * tilemap.get_used_rect().size)
			get_parent().area_size = area_size
	queue_free()
