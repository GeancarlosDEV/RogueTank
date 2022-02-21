extends Area2D

var rot_vel = PI
var vel = 100
var target
var homming = false

func _ready():
	yield(get_tree().create_timer(.6) , "timeout")
	homming = true

func _process(delta):
	if target:
		if homming:
			var angle = get_angle_to(target.global_position)
			if abs(angle) > .01:
				rotation += rot_vel * delta * sign(angle)
	translate(Vector2(cos(rotation) , sin(rotation)).normalized()  * vel * delta)


func _on_home_missel_body_entered(body):
	destroy()


func _on_area_damage_destroid():
	destroy()

func destroy():
	$area_damage.queue_free()
	$sprite.hide()
	$shape.queue_free()
	set_process(false)
	$smoke.emitting = false
	$fire.emitting = false
	$explosion.play("boom")
	yield(get_tree().create_timer(2) , "timeout")
	queue_free()
	pass # Replace with function body.
