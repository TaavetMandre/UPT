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

// Transparency gradient
uniform float gradient_start = 1.0; // Where the gradient starts (in UV.y)
uniform float gradient_end = 1.0;   // Where the gradient fully fades (in UV.y)

// Color reduction (for spell bar)
uniform float color_reduction = 1.0;

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
	
	// Gradient
	if (gradient_start != gradient_end) {
		// Apply adjustable gradient fade
		float fade_x = smoothstep(gradient_start, gradient_end, UV.x) * smoothstep(gradient_start, gradient_end, 1.0 - UV.x);
		float fade_y = smoothstep(gradient_start, gradient_end, 1.0 - UV.y);
		float fade_factor = 1.0 - fade_x * fade_y;
		blend.a *= (1.0 - fade_factor);  // Invert to fade out as UV.y increases
	}
	
	COLOR.rgb = color_burn(base, blend).rgb * color_reduction;
	COLOR.a *= blend.a;
}