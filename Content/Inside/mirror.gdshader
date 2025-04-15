// slightly modified fog of war cloud shader
shader_type spatial;
render_mode blend_mix, cull_back, diffuse_toon, unshaded;

group_uniforms Texture;
uniform sampler2D noise;
uniform float speed = 0.01;

// Transparency gradient
uniform float gradient_start = 1.0; // Where the gradient starts (in UV.y)
uniform float gradient_end = 1.0;   // Where the gradient fully fades (in UV.y)
group_uniforms;

void fragment() {
	vec4 tex = texture(noise, vec2(UV.x ,UV.y + TIME * speed));
	
	// Gradient
	if (gradient_start != gradient_end) {
		// Apply adjustable gradient fade
		float fade_x = smoothstep(gradient_start, gradient_end, UV.x) * smoothstep(gradient_start, gradient_end, 1.0 - UV.x);
		float fade_y = smoothstep(gradient_start, gradient_end, UV.y) * smoothstep(gradient_start, gradient_end, 1.0 - UV.y);
		float fade_factor = fade_x * fade_y;
		
		tex.a *= (1.0 - fade_factor);  // Invert to fade out as UV.y increases
	}
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
}