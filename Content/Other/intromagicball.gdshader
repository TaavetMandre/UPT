shader_type spatial;
render_mode shadows_disabled, wireframe, cull_disabled;

group_uniforms Pulsating;
uniform float amplitude = 0.2;
uniform float scale = 4.0;
uniform float speed = 0.5;
uniform sampler2D noise;
group_uniforms;

group_uniforms Material;
uniform float red: hint_range(0.0, 1.0);
uniform float green: hint_range(0.0, 1.0);
uniform float blue: hint_range(0.0, 1.0);
uniform bool glow = true;
uniform float glow_intensity: hint_range(0.0, 100.0);


void vertex() {
	vec2 noise_uv = UV * scale + vec2(TIME * speed, 0.0);
	float height = texture(noise, noise_uv).r;
	
	VERTEX += NORMAL * (height - 0.5) * amplitude;
}

void fragment() {
	ALBEDO = vec3(red, green, blue);
	if (glow == true) {
		EMISSION = vec3(red, green, blue) * glow_intensity;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
