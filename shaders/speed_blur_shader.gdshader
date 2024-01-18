shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float blur_iterations = 5.0;
uniform float blur_mul = 1;
uniform float  blur_start_speed = 1;
uniform float blur_max_speed = 2;
uniform float speed = 20;

void fragment()
{
	vec2 motion_vec2 = SCREEN_UV - vec2(0.5, 0.5);
	vec4 screen_col = texture(screen_texture, SCREEN_UV);
	float speed_mul = (min(speed, blur_max_speed) - blur_start_speed) / (blur_max_speed - blur_start_speed);
	if (speed_mul > 0.01)
	{
		vec4 mix_col = screen_col;
		float loop_count = blur_iterations;
		float step_length = 1.0 / loop_count;
		vec2 motion_dir = normalize(motion_vec2);
		for(float i = 1.0; i < loop_count; i++)
		{
			vec2 blur_uv = SCREEN_UV - motion_dir * ((loop_count - i) * step_length * blur_mul);
			mix_col = mix(mix_col, textureLod(screen_texture, blur_uv, i * step_length * 5.0), step_length);
		}
		COLOR = mix(screen_col, mix_col, clamp((length(motion_vec2) - 0.2) * 4.0 * speed_mul, 0.0, 1.0));
	}
	else
	{
		COLOR = screen_col;
	}
}