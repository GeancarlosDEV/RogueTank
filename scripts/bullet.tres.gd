extends Area2D

var max_dist = 250
var vel = 400
var dir = Vector2 ( 0 , -1) setget set_dir
onready var init_pos = global_position
var damage = 10
var live = true

var shooter

func _ready():
	pass
func _process(delta):
	if live:
		if global_position.distance_to(init_pos) >= max_dist:
			autodestroy()
		translate(dir * vel * delta)
		pass
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free() #apagar o objeto da memória
	pass # Replace with function body.

func set_dir( val):
	dir = val
	rotation = dir.angle()
	pass

func _on_bullet_body_entered(body):
	if body.collision_layer == 4: #colisão com o muro
		autodestroy()
		#autodestroy
		pass # Replace with function body.

func autodestroy():
	$smoke.emitting = false
	live = false
	$sprite.visible = false
	$anim_self_destruction.play("explode")
	call_deferred("set_monitoring" , false)
	#monitoring = false
	call_deferred("set_monitorable" , false)
	#monitorable = false
	yield ($anim_self_destruction , "animation_finished") #dar preferencia
	queue_free()
	pass


func _on_bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage , self)
		autodestroy()
	pass # Replace with function body.
