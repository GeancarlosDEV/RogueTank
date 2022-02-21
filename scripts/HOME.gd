extends Area2D

var rot_vel = PI * .1
const PRE_MISSEL = preload("res://scenes/home_missel.tscn")

func _ready():
	pass # Replace with function body.


func get_target():
	var tank = get_parent().bodys[0]
	var ht = (tank.global_position - global_position).normalized()
	var facing = Vector2(cos(rotation) , sin(rotation))
	
	if ht.dot(facing) > .5:
		if $fire_timer.is_stopped():
			fire()
			$fire_timer.start()
	else:
		$fire_timer.stop()
		
	return null

func fire():
	if get_parent().bodys.size():
		$fire.play()
		$anim.play("fire")
		$smoke.emitting = true
		var missel = PRE_MISSEL.instance()
		get_parent().add_child(missel)
		missel.rotation = rotation
		missel.target = get_parent().bodys[0]
		missel.global_position = $barrel.global_position
	else:
		$fire_timer.stop()
	

func _on_fire_timer_timeout():
	fire()
	
