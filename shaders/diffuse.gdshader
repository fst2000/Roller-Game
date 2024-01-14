shader_type spatial;

uniform sampler2D diffuse;
uniform vec2 tiling = vec2(1.0,1.0);

void fragment()
{
	ALBEDO = texture(diffuse, UV * tiling).rgb;
}