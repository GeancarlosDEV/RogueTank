tool
extends KinematicBody2D

onready var BULLET_TANK_GROUP = "bullet-" + str(self)

const ROT_VEL = PI / 2 #PI é igual a 180º
const dead_zone = 0.02
const MAX_SPEED = 100
var pre_bullet = preload("res://scenes/bullet.tscn")
var pre_track = preload("res://scenes/track.tscn")
var pre_mg_bullet = preload ("res://scenes/mg_bullet.tscn")
var acell = 0
var can_mouse_look = false
var travel = 0
var loaded = true

signal cannon_shooted
signal hmg_shooted

export(int , "bigRed", "bigBlue" , "dark" , "darkLarge" , "green" , "huge" , "red" , "sand") var bodie = 0 setget set_bodie
export (int , "specialBarrel1", "specialBarrel2", "specialBarrel3" , "specialBarrel4" , " specialBarrel5" , 
 "specialBarrel6" , "specialBarrel7" , "tankBlue_barrel1" , "tankBlue_barrel2" , "tankBlue_barrel3" , 
 "tankDark_barrel1" , "tankDark_barrel2" , "tankDark_barrel3" , "tankGreen_barrel1" , "tankGreen_barrel2" , 
 "tankGreen_barrel3" , "tankRed_barrel1" , "tankRed_barrel2" , "tankRed_barrel3" , "tankSand_barrel1" , 
"tankSand_barrel2" , "tankSand_barrel3") var barrel = 0 setget set_barrel

var boddies = [
	"res://5.1 sprites/sprites/tankBody_bigRed.png",     # 0
	"res://5.1 sprites/sprites/tankBody_blue.png",       # 1
	"res://5.1 sprites/sprites/tankBody_dark.png",       # 2
	"res://5.1 sprites/sprites/tankBody_darkLarge.png",  # 4
	"res://5.1 sprites/sprites/tankBody_green.png",      # 5
	"res://5.1 sprites/sprites/tankBody_huge.png",       # 6
	"res://5.1 sprites/sprites/tankBody_red.png",        # 7
	"res://5.1 sprites/sprites/tankBody_sand.png"        # 8
	
]

var barrels = [
	"res://5.1 sprites/sprites/specialBarrel1.png",
	"res://5.1 sprites/sprites/specialBarrel2.png",
	"res://5.1 sprites/sprites/specialBarrel3.png",
	"res://5.1 sprites/sprites/specialBarrel4.png",
	"res://5.1 sprites/sprites/specialBarrel5.png",
	"res://5.1 sprites/sprites/specialBarrel6.png",
	"res://5.1 sprites/sprites/specialBarrel7.png",
	"res://5.1 sprites/sprites/tankBlue_barrel1.png",
	"res://5.1 sprites/sprites/tankBlue_barrel2.png",
	"res://5.1 sprites/sprites/tankBlue_barrel3.png",
	"res://5.1 sprites/sprites/tankDark_barrel1.png",
	"res://5.1 sprites/sprites/tankDark_barrel2.png",
	"res://5.1 sprites/sprites/tankDark_barrel3.png",
	"res://5.1 sprites/sprites/tankGreen_barrel1.png",
	"res://5.1 sprites/sprites/tankGreen_barrel2.png",
	"res://5.1 sprites/sprites/tankGreen_barrel3.png",
	"res://5.1 sprites/sprites/tankRed_barrel1.png",
	"res://5.1 sprites/sprites/tankRed_barrel2.png",
	"res://5.1 sprites/sprites/tankRed_barrel3.png",
	"res://5.1 sprites/sprites/tankSand_barrel1.png",
	"res://5.1 sprites/sprites/tankSand_barrel2.png",
	"res://5.1 sprites/sprites/tankSand_barrel3.png"
]
func _ready():

	pass
	
func _draw():
	#print(boddies[1])
	$sprite.texture = load(boddies[bodie])
	$barrel/sprite.texture = load(barrels[barrel])
	pass 
	
func _input(event):
	if event is InputEventMouseMotion:
		can_mouse_look = true
		pass
func _physics_process(delta):
	
	if Engine.editor_hint:
		return
		
	var vel_mod = 1
	if get_tree().get_nodes_in_group(str(self) + "oil").size() > 0:
		vel_mod = .3
#	var dirx = 0
#	var diry = 0
#
#	if Input.is_action_pressed("ui_right"):
#		dirx += 1		
#	if Input.is_action_pressed("ui_left"):
#		dirx -= 1
#
#	if Input.is_action_pressed("ui_up"):
#		diry -= 1
#	if Input.is_action_pressed("ui_down"):
#		diry += 1
#
	if Input.is_action_just_pressed("ui_tiro") and loaded:
		#if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < 6:
		var bullet = pre_bullet.instance()
		bullet.global_position = $barrel/muzzle.global_position
		bullet.dir = Vector2( cos($barrel.global_rotation) , sin($barrel.global_rotation) ).normalized()
		bullet.add_to_group(BULLET_TANK_GROUP)
		bullet.max_dist = $barrel/mira.position.x - $barrel/muzzle.position.x - 60		
		bullet.shooter = self
		$"../".add_child(bullet) #coloca a bala na ponta do canhão
		$barrel/anim.play("fire")
		loaded = false
		$barrel/mira.update()
		$time_reload.start()
		$barrel/barrel_anim.play("shoot")
		#get_parent().add_child(bullet)
		emit_signal("cannon_shooted")
		#print(get_tree().get_nodes_in_group("grupo 01").size())
		
	if Input.is_action_just_pressed("machinegun"):
		shoot_mg()
		$time_mg.start()
		
	if Input.is_action_just_released("machinegun"):
		$time_mg.stop()
		
#	look_at(get_global_mouse_position())
#	move_and_slide(Vector2(dirx , diry) * speed )
	var rot = 0
	var dir = 0
	
	if Input.is_action_pressed("ui_right"):
		rot += 1
	if Input.is_action_pressed("ui_left"):
		rot -= 1
	if rot == 0:
		rot = Input.get_joy_axis(0 , JOY_AXIS_0)
	
	if Input.is_action_pressed("ui_up"):
		dir += 1
	if Input.is_action_pressed("ui_down"):
		dir -= 1
	if dir == 0:
		dir = -Input.get_joy_axis(0 , JOY_AXIS_1)
		
	rotate(ROT_VEL * rot * delta)
	#if dir != 0:
	acell = lerp(acell , MAX_SPEED * dir , .03) #ele vai aumentando a velocidade
	#else:
	#	acell = lerp(acell , 0, .05)

	var move = move_and_slide(Vector2( cos(rotation) , sin(rotation) )  * acell * vel_mod)
	
	travel += move.length() * delta
	
	if travel > $sprite.texture.get_size().y:
		travel = 0
		var track = pre_track.instance()
		track.global_position = global_position - Vector2( cos(rotation) , sin(rotation) ).normalized() * 5
		track.rotation = rotation
		track.z_index = z_index - 1
		$"../".add_child(track)
		
	var r_hor_axis = Input.get_joy_axis(0 , JOY_AXIS_2)
	if abs(r_hor_axis) < dead_zone:
		r_hor_axis = 0
		
	var r_ver_axis = Input.get_joy_axis(0 , JOY_AXIS_3)
	if abs(r_ver_axis) < dead_zone:
		r_ver_axis = 0
		
	if r_hor_axis != 0 or r_ver_axis != 0:
		
		var vector = Vector2(r_hor_axis, r_ver_axis)
		
		if vector.length() > .95:
			$barrel.global_rotation = vector.normalized().angle()
			can_mouse_look = false

#	else:
		
		
	if can_mouse_look:
		$barrel.look_at(get_global_mouse_position())
		
		
func set_bodie(val):
	bodie = val
	if Engine.editor_hint:
		update()
func set_barrel(val):
	barrel = val
	if Engine.editor_hint:
		update()
	pass


func _on_time_reload_timeout():
	loaded = true
	$barrel/mira.update()
	pass # Replace with function body.

func shoot_mg():
	var mg = pre_mg_bullet.instance()
	mg.global_position = $mg_muzzle.global_position
	mg.global_rotation = global_rotation
	mg.dir = Vector2(cos(global_rotation) , sin(global_rotation)).normalized()
	mg.shooter = self
	get_parent().add_child(mg)
	emit_signal("hmg_shooted")
		


func _on_time_mg_timeout():
	shoot_mg()
	pass # Replace with function body.


func _on_damage_area_destroid():
	queue_free()
