// https://godotshaders.com/shader/2d-wavy-effect/
shader_type canvas_item;

//Get the screen texture
uniform sampler2D screenTexture : hint_screen_texture;

//Set the scroll amount - default = 0.05, 0.05
uniform vec2 scrollAmount = vec2(0.05, 0.05);

//How much distortion is desired? - default = 0.01
uniform float multiplierAmount : hint_range(0.0, 0.1) = 0.01;

void fragment() {
	// Called for every pixel the material is visible on.
	
	//Get the the screen, then add the noise to it based on the red channel. 
	//Scroll that noise multiplied by the time, multiply all of that by given amount
	vec2 distortionUV = SCREEN_UV + texture(TEXTURE, UV + scrollAmount * TIME).r * multiplierAmount;
	
	//Now, get what's underneath the noise texture (the screen) and apply the distorted noise UV to that
	vec4 screen = texture(screenTexture, distortionUV);
	
	//Set the COLOR to apply the effect
	COLOR = screen;
}