extends Area2D

const rot_vel = PI * .2
const PRE_BULLET = preload("res://scenes/turret_01_bullet.tscn")


func _ready():
	get_parent().connect("player_entered" , self , "on_player_entered")
	get_parent().connect("player_exited" , self , "on_player_exited")
	
	$sight.cast_to = Vector2(get_parent().sensor_radius , 0)
	pass # Replace with function body.


func get_target():
	if $sight.is_colliding():
		return $sight.get_collider()
	return null
	
func on_player_entered(n):
	if n:
		$shoot_time.start()
	$sight.enabled = true
	
	
func on_player_exited(n):
	if !n:
		$sight.enabled = false
		$shoot_time.stop()
		$smoke.emitting = false
	pass

func _on_shoot_time_timeout():
	if $sight.is_colliding():
		shoot()
	else:
		$smoke.emitting = false


func shoot():
	$smoke.emitting= true
	$cannon_anim.play("shoot")
	$stream_shoot.play()
	var bullet = PRE_BULLET.instance()
	bullet.global_position = global_position
	bullet.dir = Vector2(cos(rotation) , sin(rotation))
	bullet.max_dist = get_parent().sensor_radius
	get_parent().get_parent().add_child(bullet)
