extends Area2D

var dir = Vector2() setget set_dir
var vel = 400
var max_dist = 300
onready var init_pos = global_position


# Called when the node enters the scene tree for the first time.
func _ready():
#	self.dir = Vector2(1 , -1)
	pass # Replace with function body.

func _physics_process(delta):
	translate(dir * vel * delta)
	if global_position.distance_to(init_pos) > max_dist:
		queue_free()
		
func set_dir(val):
	dir = val
	rotation = val.angle()


func _on_turret_01_bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(5 , self)
		queue_free()

