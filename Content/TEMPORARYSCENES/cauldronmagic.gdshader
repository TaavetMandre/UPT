shader_type spatial;

uniform float speed = 50.0;

void fragment() {
	// p
}

void vertex() {
  VERTEX.y += cos(VERTEX.x * TIME / speed) * sin(VERTEX.z * TIME / speed);
}