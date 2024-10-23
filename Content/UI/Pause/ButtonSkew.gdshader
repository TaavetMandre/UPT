// Idea from https://godotshaders.com/shader/simple-sway/
// Kinda temporary until we get button textures

shader_type canvas_item;

void vertex() {
	float x = VERTEX.y / 3.75 - 15.0;
    VERTEX.x += x;
}