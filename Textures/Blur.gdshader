// Source:
// https://godotshaders.com/shader/simple-blur/

shader_type canvas_item;

uniform float Lod: hint_range(0.0, 5) = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, Lod);
	COLOR = color;
}