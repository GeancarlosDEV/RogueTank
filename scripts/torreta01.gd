tool
extends StaticBody2D

var bodys  = []

export(float , 0 , 360) var start_rot = 0.0 setget set_start_rot

export(float , 100 , 1000) var sensor_radius = 100 setget set_sensor_radius

export(int , "HMG" , "HOME") var type = 0 setget set_type

var first_draw = true
export var life = 100

onready var init_life = life
onready var game = get_node("/root/GAME")

signal player_entered(n)
signal player_exited(n)

var dead = false

onready var cannon = $HMG

func _ready():
	pass
	
func _process(delta):	
	if Engine.editor_hint:
		return
		
	if bodys.size():
		var target = cannon.get_target()
		var angle = cannon.get_angle_to(bodys[0].global_position)
		if abs(angle) > .01:
			cannon.rotation += cannon.rot_vel * delta * sign(angle)
		if target != null && target != bodys [0]:
			var oldbody = bodys[0]
			var newBodyIndex = bodys.find(target)
			bodys[0] = target
			bodys[newBodyIndex] = oldbody

func _draw():
	if dead:
		return
		
	if Engine.editor_hint:
		$HMG.visible = type == 0
		$HOME.visible = type == 1
		
	if type == 0:
		cannon = $HMG
	elif type == 1:
		cannon = $HOME
	
	if first_draw:
		$HMG.visible = type == 0
		$HOME.visible = type == 1
		cannon.rotation = deg2rad(start_rot)
		var new_shape = CircleShape2D.new()
		new_shape.radius = sensor_radius
		$sensor/shape.shape = new_shape
		if !Engine.editor_hint:
			first_draw = false
			
			if type == 0:
				$HOME.queue_free()
			elif type == 1:
				$HMG.queue_free()
				
	if bodys.size():
		draw_circle(Vector2()  ,  $sensor/shape.shape.radius , Color(1 , 0 , 0 , .1))
	draw_arc(Vector2(), $sensor/shape.shape.radius, 0.0, PI * 2, 32, Color(1, 0, 0, 0.2), .1)
	
	
func _on_sensor_body_entered(body):
	bodys.append(body)	
	emit_signal("player_entered" , bodys.size())	
	update()	

func _on_sensor_body_exited(body):
	var index = bodys.find(body)
	if index >= 0:
		bodys.remove(index)
	emit_signal("player_exited" , bodys.size())
	update()		
	
func set_start_rot(val):
	start_rot = val
	if Engine.editor_hint:
		update()
		
func set_sensor_radius(val):
	sensor_radius = val
	if Engine.editor_hint:
		update()
		
	
#func _draw_circle_arc(center , radius , angle_from , angle_to , color): #Essa função não deu certo!
#	var nb_points = 32
#	var points_arc = PoolVector2Array()
#
#	for i in range(nb_points+1):
#		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points + 90)
#		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#	for index_point in range(nb_points):
#		draw_line(points_arc[index_point] , points_arc[index_point + 1], color)

# warning-ignore:unused_argument
func _on_spot_damage(damage, node):
	life -= damage
	$stream/stream_hit.play()
	$hp/hp_barra.scale = float(life) / float(init_life)
	if life <= 0:
		set_process(false)
		cannon.queue_free()
		$sensor.disconnect("body_exited" , self , "_on_sensor_body_exited")
		$sensor.queue_free()
		$spot.queue_free()
		$hp/hp_barra.queue_free()
		dead = true
		update()
		$explosion/anim.play("explode")
		$stream/stream_explode.play()
		get_tree().call_group("camera" , "shake" , 5 , 1)
		game.add_score(250)
		remove_from_group("radar_entity")


func set_type(val):
	type = val
	if Engine.editor_hint:
		update()
	
