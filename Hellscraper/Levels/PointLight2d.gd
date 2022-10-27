extends PointLight2D

var increment = .01
var big_size = texture_scale + .1
var small_size = texture_scale - .1
var speed = 6
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if texture_scale <= small_size:
		increment = .01
	if texture_scale >= big_size:
		increment = -.01
	texture_scale += increment * delta * speed
	energy += increment * delta * speed
