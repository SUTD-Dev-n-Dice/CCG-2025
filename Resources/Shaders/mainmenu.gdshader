shader_type canvas_item;

uniform float speed = 1;

void fragment() {
	COLOR = texture(TEXTURE, vec2(UV.x, UV.y + speed*TIME));
}
