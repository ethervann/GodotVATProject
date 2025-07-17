shader_type spatial;
render_mode cull_disabled;

uniform sampler2D tex;

void fragment(){
	ALBEDO = texture(tex, UV).rgb;
}