shader_type spatial;
render_mode depth_draw_always, cull_disabled;

uniform sampler2D position_atlas;
uniform sampler2D normal_atlas;
uniform sampler2D albedo;
uniform vec3 sheen_color;
uniform float sheen_color_strength;
uniform float scale = 2.73;
uniform float tex_width = 8;
uniform float tex_height = 10;
instance uniform float frame = 0.0;
instance uniform float y_start = 0.0;
instance uniform float y_length = 1.0;
instance uniform float tp;

void vertex(){
	float pixel = 1.0 / tex_width;
	float half_pixel = pixel * 0.5;
	float frame_pixel_size = 1.0 / tex_height;
	float anim_percent = mod(frame/tex_height, y_length/tex_height);

	vec3 pos = texture(position_atlas, UV2 + vec2(half_pixel, +(((y_start + mix(0.0, y_length, anim_percent)) * frame_pixel_size)))).xyz;
	vec3 nrm = texture(normal_atlas, UV2 + vec2(half_pixel, +(((y_start + mix(0.0, y_length, anim_percent)) * frame_pixel_size)))).xyz;

	float new_x = (pos.x * 2.0) - 1.0;
	float new_y = (pos.z * 2.0) - 1.0;
	float new_z = ((pos.y * 2.0) - 1.0) * -1.0;

	float nrm_x = (nrm.x * 2.0) - 1.0;
	float nrm_y = (nrm.z * 2.0) - 1.0;
	float nrm_z = ((nrm.y * 2.0) - 1.0) * -1.0;

	nrm = vec3(nrm_x, nrm_y, nrm_z);
	pos = vec3(new_x, new_y, new_z) * scale;

	VERTEX = pos;
	NORMAL = nrm;
}

void fragment(){
	ALBEDO = texture(albedo, UV).rgb * sheen_color.rgb * sheen_color_strength;
	ALPHA = texture(albedo, UV).a;
	ROUGHNESS = 0.85;
}
