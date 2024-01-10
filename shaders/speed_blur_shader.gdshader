shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float blur_mul = 1;
uniform float  blur_start_speed = 1;
uniform float blur_max_speed = 2;
uniform float speed = 20;

vec4 screen(vec2 screen_uv)
{
	return texture(screen_texture, screen_uv);
}

void fragment()
{
	vec2 motion_vec2 = SCREEN_UV - vec2(0.5, 0.5);
	vec4 screen_col = screen(SCREEN_UV);
	float speed_mul = (min(speed, blur_max_speed) - blur_start_speed) / (blur_max_speed - blur_start_speed);
	if (speed_mul > 0.01)
	{
		vec4 mix_col = screen_col;
		float loop_count = 20.0;
		float step_length = 1.0 / loop_count;
		vec2 motion_dir = normalize(motion_vec2);
		for(float i = 1.0; i < loop_count; i++)
		{
			mix_col = mix(mix_col, screen(SCREEN_UV - motion_dir * ((loop_count - i) * step_length * blur_mul)), step_length);
		}
		COLOR = mix(screen_col, mix_col, clamp((length(motion_vec2) - 0.2) * 4.0 * speed_mul, 0.0, 1.0));
	}
	else
	{
		COLOR = screen_col;
	}
}
	