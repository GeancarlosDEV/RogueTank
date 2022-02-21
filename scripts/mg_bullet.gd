extends Area2D

var vel = 400
var dir = Vector2()
var damage = 1
onready var initpos = self.global_position

var shooter

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	translate(dir * vel * delta)
	if global_position.distance_to(initpos) > 150:
		autodestroy()


func _on_mg_bullet_body_entered(body):
	queue_free()
	pass # Replace with function body.


func _on_mg_bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage , self)
		autodestroy()
	pass # Replace with function body.
	
func autodestroy():
	queue_free()
