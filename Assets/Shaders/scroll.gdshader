// source: https://godotshaders.com/shader/panning/

shader_type canvas_item;

// Uniforms
uniform float speed = 0.025;

// Functions
void fragment () {
	COLOR = texture(TEXTURE, vec2(UV.x + TIME * speed, UV.y));
}