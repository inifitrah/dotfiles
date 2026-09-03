#version 320 es
precision highp float;
// @duration 0.45
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec2 pos = (uv - vec2(0.5)) * vec2(surface_size.x/surface_size.y,1.0);
    float dist = length(pos);
    float angle = atan(pos.y, pos.x);
    float portal = 1.0 - smoothstep(0.02, 0.04, 0.35 * p + dist - 0.35);
    float edge = 1.0 - smoothstep(0.0,0.05, abs(dist - (0.35 - 0.35*p)));
    vec2 warp = normalize(pos+vec2(0.001)) * edge * 0.02 * p;
    vec4 c = texture(tex, uv + warp);
    float alpha = portal * (1.0-p);
    vec3 rgb = c.rgb * alpha;
    rgb += edge * vec3(0.45,0.85,1.0) * 0.45 * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
