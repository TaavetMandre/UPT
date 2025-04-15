shader_type spatial;

uniform sampler2D water_texture;
uniform sampler2D normal_map;
uniform float flow_speed = 1.0;
uniform vec2 flow_direction;


void vertex() {
	NORMAL = texture(normal_map, UV).rgb;
}


void fragment() {
	float scroll_x = UV.x * TIME * flow_direction.x * flow_speed;
	float scroll_y = UV.y * TIME * flow_direction.y * flow_speed;
	vec4 water = texture(water_texture, UV * TIME / 50.0);
	
	ALBEDO = water.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
