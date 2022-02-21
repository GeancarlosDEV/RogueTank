extends StaticBody2D

const PRE_FRAGMENTOS = preload("res://scenes/fragmentos/box_fragmentos.tscn")
var last_hit_node

func _ready():
	$area_obstaculo.connect("hitted", self, "on_area_hitted")
	$area_obstaculo.connect("destroid", self, "on_area_destroid")


func on_area_hitted(damage, health, node):
	last_hit_node = node
	if damage > 5:
		$anim.play("big_hit")
		
	else:
		$anim.play("smal_hit")
		
		
func on_area_destroid():
	var fragmentos = PRE_FRAGMENTOS.instance()
	fragmentos.global_position = global_position
	fragmentos.scale = scale
	get_parent().call_deferred("add_child" , fragmentos)
	$explosion.play()
	if last_hit_node and "shooter" in "last_hit_node":
		if last_hit_node.shooter.get_filename() == "res://scenes/Tank.tscn":
			GAME.add_score(50)
	queue_free()
