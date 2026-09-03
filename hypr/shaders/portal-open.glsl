#version 320 es
precision highp float;
// @duration 0.52
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec2 center = vec2(0.5);
    vec2 pos = (uv - center) * vec2(surface_size.x/surface_size.y,1.0);
    float dist = length(pos);
    float angle = atan(pos.y, pos.x);
    // portal expand dari titik
    float portal = smoothstep(0.02, 0.04, 0.35 * p - dist + 0.12*sin(angle*6.0 + p*12.0)*0.015);
    // distortion di edge portal
    float edge = 1.0 - smoothstep(0.0, 0.05, abs(dist - 0.35*p));
    vec2 warp = normalize(pos+vec2(0.001)) * edge * 0.02 * (1.0-p);
    vec4 c = texture(tex, uv + warp);
    float alpha = portal;
    vec3 rgb = c.rgb * alpha;
    // glow keliling border portal
    rgb += edge * vec3(0.45,0.85,1.0) * 0.55 * alpha;
    rgb += edge * vec3(0.95,0.55,1.0) * 0.25 * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
