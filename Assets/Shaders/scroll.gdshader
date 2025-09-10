// source: https://godotshaders.com/shader/panning/

shader_type canvas_item;

// --- Uniforms --- //
uniform vec2 speed = vec2(0.0, -1.0);

// --- Functions --- //
void fragment() {
	COLOR = texture(TEXTURE, mod(UV + TIME * speed, 1.0));
}