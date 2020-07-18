extends Light2D

export(NoiseTexture) var flickerNoise:NoiseTexture


const time_max = 4
var time_now = rand_range(0, time_max)

func _process(delta):
	time_now += delta
	if time_now > time_max:
		time_now -= time_max
	
	var flicker_image = flickerNoise.get_data()
	
	flicker_image.lock()
	var px = flicker_image.get_pixel(int(round(
		flicker_image.get_width() * time_now / time_max
	)), 0)
	flicker_image.unlock()
	
	energy = px.r
