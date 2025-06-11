shader_type canvas_item;

uniform bool is_transparent = false;

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);

	if(current_color.a != 0.0) {
		vec4 v = current_color;
		if (is_transparent) {
			v.a = 0.4;
		}
		else {
			v.a = 1.0;
		}
		COLOR = v;
	}
}
