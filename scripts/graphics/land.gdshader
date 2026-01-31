shader_type canvas_item;

uniform vec4 high_color: source_color = vec4(0.4, 0.8, 0.3, 1.0);
uniform vec4 low_color: source_color = vec4(0.2, 0.5, 0.1, 1.0);
uniform float scale = 16.0;

float hash2(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)),
				dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

float perlin_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	// Four corners in 2D of a tile
	float a = hash2(i);
	float b = hash2(i + vec2(1.0, 0.0));
	float c = hash2(i + vec2(0.0, 1.0));
	float d = hash2(i + vec2(1.0, 1.0));

	// Smooth interpolation
	vec2 u = f * f * (3.0 - 2.0 * f);

	// Mix the four corners
	return mix(a, b, u.x) +
		   (c - a) * u.y * (1.0 - u.x) +
		   (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
	float gain = 0.7;

	float total = 0.0;
	float amplitude = 1.0;
	float frequency = 1.0;
	float maxAmplitude = 0.0;

	for(int i = 0; i < 7; i++) {
		total += perlin_noise(p * frequency) * amplitude;
		frequency *= 2.0;
		amplitude *= gain;
		maxAmplitude += amplitude;
	}
	return total / maxAmplitude;
}

void fragment() {
    vec2 uv = UV * scale;
    float n = fbm(uv) * 0.5 + 0.5;

    // Stylize: quantize noise for a painterly look
    n = smoothstep(0.0, 1.0, n);
    COLOR = mix(low_color, high_color, n);
}
