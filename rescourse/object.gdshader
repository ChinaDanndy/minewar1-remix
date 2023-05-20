shader_type canvas_item;
uniform vec4 change_color : source_color;
uniform float threshold : hint_range(0.0, 1.0, 0.01) = 0.1;

void fragment() {
//	vec3 c = COLOR.rgb;
	COLOR.rgb = change_color.rgb;
	if (COLOR.a > 0.0){
		COLOR.a = change_color.a;
	}
//	COLOR.a = change_color.a;
//	float m = (c.r + c.g + c.b) / 3.0;
//	if (m < threshold){
//		COLOR.rgb = change_color;
//	}
}
