shader_type canvas_item;

uniform float flash_state:hint_range(0.0, 1.0, 0.1) = 0.0;
uniform vec4 color: source_color;
void fragment(){
	vec4 pixelcolor = texture(TEXTURE, UV);
	COLOR = mix(pixelcolor, color, flash_state);
	COLOR.a *= pixelcolor.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
