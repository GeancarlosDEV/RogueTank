extends StaticBody2D

const PRE_OIL = preload("res://scenes/oilSpill_large.tscn")

var last_hit_node

func _ready():
	$area_hit.connect("hitted", self, "on_area_hitted")
	$area_hit.connect("destroid", self, "on_area_destroid")

func on_area_hitted(damage, health, node):
	last_hit_node = node
	if health > 0:
		if damage > 5:
			$big_hit.play()
		else:
			var hit_sound = "smal_hit_0" + str( randi() % 5 + 1)
			get_node(hit_sound).play()
	else:
		$explosion.play()
	pass
	
func on_area_destroid():
	
	var oil_count = rand_range(3, 8)
	
	for o in range(oil_count):
		var oil = PRE_OIL.instance()
		var angle = randf() * (PI *2)
		oil.global_position = global_position + Vector2(cos(angle) , sin(angle)).normalized() * rand_range(30 , 60)
		oil.z_index = z_index -1
		$"../".add_child(oil)
		
	$area_hit.queue_free()
	$shape.queue_free()
	$anim.play("explode")
	if last_hit_node and "shooter" in "last_hit_node":
		if last_hit_node.shooter.get_filename() == "res://scenes/Tank.tscn":
			GAME.add_score(80)
	yield($anim, "animation_finished")
	queue_free()

