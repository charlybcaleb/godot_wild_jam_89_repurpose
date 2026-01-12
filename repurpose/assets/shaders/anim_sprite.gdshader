shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool flash_enabled = false;


void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec3 final_rgb = flash_enabled ? flash_color.rgb : original_color.rgb;
	COLOR = vec4(final_rgb, original_color.a);
}
