// scrolling from https://godotshaders.com/shader/panning/
// noise overlay https://godotshaders.com/shader/simple-noise-overlay/

shader_type canvas_item;
render_mode blend_mix;

// Scrolling
uniform vec2 scroll_speed = vec2(0.05, 0.0);

// Noise
uniform vec2 direction = vec2(1, 0);
uniform float noise_speed = 0.1;
uniform sampler2D noise;

vec4 color_burn(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) / blend;
}

void fragment() {
	// Alpha
	COLOR.a = 0.8;
	
	// Image texture
	vec4 base = texture(TEXTURE, mod(UV + TIME * scroll_speed, 1.0));
	// Noise texture
	vec4 blend = texture(noise, mod(UV + TIME * noise_speed, 1.0));
	
	COLOR.rgb = color_burn(base, blend).rgb;
}