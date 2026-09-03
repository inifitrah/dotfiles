#version 320 es
precision highp float;
// @duration 0.45
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform float seed;
uniform vec2 surface_size;

float easeOutCubic(float x){ return 1.0 - pow(1.0 - x, 3.0); }

void main(){
    float p = easeOutCubic(progress);
    vec2 uv = v_texcoord;
    // scale dari tengah 0.85 -> 1.0
    float scale = mix(0.88, 1.0, p);
    vec2 scaled = (uv - 0.5) / scale + 0.5;

    // blur simulasi: 3 taps horizontal
    float blur = (1.0 - p) * 8.0;
    vec2 px = 1.0 / surface_size * blur;
    vec4 c0 = texture(tex, scaled);
    vec4 c1 = texture(tex, scaled + vec2(px.x, 0.0));
    vec4 c2 = texture(tex, scaled - vec2(px.x, 0.0));
    vec3 col = (c0.rgb + c1.rgb + c2.rgb) / 3.0;
    float alphaTex = (c0.a + c1.a + c2.a) / 3.0;

    // glass glow di tengah
    float glow = 1.0 - smoothstep(0.0, 0.6, p);
    float dist = length(uv - 0.5);
    float bloom = exp(-dist*3.5) * glow * 0.45;
    vec3 bloomCol = vec3(0.7, 0.88, 1.0);
    col += bloom * bloomCol;

    // alpha reveal + outside scale alpha
    float alpha = p;
    // fade out luar scaled area biar gak kotak
    float outside = step(scaled.x, 0.0) + step(1.0, scaled.x) + step(scaled.y, 0.0) + step(1.0, scaled.y);
    alpha *= 1.0 - clamp(outside, 0.0, 1.0);
    alpha = clamp(alpha, 0.0, 1.0);

    col *= alpha;
    float a = alphaTex * alpha;
    fragColor = vec4(col * a, a);
}
