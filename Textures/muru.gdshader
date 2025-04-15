shader_type spatial;
render_mode cull_disabled, diffuse_toon, shadows_disabled, specular_disabled, world_vertex_coords;
uniform float offset = 0.0;
void vertex() {
	if(VERTEX.y - NODE_POSITION_WORLD.y > 1.0) {
		VERTEX += vec3(0.0, 0.0, sin((TIME + offset) * 0.8) * 0.28);
		
		
	//luhta läinud katsed, sest unustasin arvestada global space parameetriga võrdluses
	//	VERTEX += (MODEL_MATRIX * vec4(vec3(sin((TIME + offset) * 1.0) * 0.1, 0.0, 0.0), 0.0)).xyz;
	//	VERTEX += (MODEL_MATRIX * vec4(0.0 , 0.0, 0.0, 1.0)).xyz * vec3(1.0, 1.0, sin((TIME + offset) * 1.0) * 0.1);
	}
	if(VERTEX.y - NODE_POSITION_WORLD.y > 0.2) {
		VERTEX += vec3(0.0, 0.0, sin((TIME + offset) * 0.8) * 0.15);
	}
}

void fragment() {
	ALBEDO = vec3(0.08, 0.1, 0.03);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
