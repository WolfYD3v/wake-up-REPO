shader_type canvas_item;

uniform float amount = 10.0; // Diminué de 40.0 à 10.0
uniform float time_speed = 0.5; // Ajout d'une variable pour contrôler la vitesse

void fragment() {
	vec2 uv = UV*0.05; 
	float noise_base = dot(UV, vec2(12.9898, 78.233));
	float a = fract(sin(noise_base * TIME * time_speed) * 438.5453) * 1.9;
	vec4 col = texture(TEXTURE, UV);
	col.a *= pow(a, amount);
	COLOR.a = col.a;
}