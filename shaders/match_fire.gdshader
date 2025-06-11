shader_type canvas_item;

uniform vec4 color_flame : source_color = vec4(255, 255, 255, 255);

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);

	if(	current_color.r == 1.0 &&
		current_color.g == 1.0 &&
		current_color.b == 1.0 &&
		current_color.a == 1.0
		) {
		COLOR = color_flame;
	}
}
