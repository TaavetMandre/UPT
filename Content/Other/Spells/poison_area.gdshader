shader_type spatial;

uniform sampler2D noise;
uniform float speed;

void fragment() {
	vec2 scrolling_uv = vec2(UV.x + TIME * speed / 4.0, UV.y + TIME * speed);
	
	ALBEDO = texture(noise, scrolling_uv).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
