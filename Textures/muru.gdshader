shader_type spatial;
render_mode cull_disabled, diffuse_toon, shadows_disabled, specular_disabled, world_vertex_coords;
uniform float offset = 0.0;
void vertex() {
	if(VERTEX.y - NODE_POSITION_WORLD.y > 1.0) {
		VERTEX += vec3(0.0, 0.0, sin((TIME + offset) * 0.8) * 0.28);
	}
	if(VERTEX.y - NODE_POSITION_WORLD.y > 0.2) {
		VERTEX += vec3(0.0, 0.0, sin((TIME + offset) * 0.8) * 0.15);
	}
}

void fragment() {
	ALBEDO = vec3(0.08, 0.1, 0.03);
}

