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
    vec2 pos = (uv - 0.5) * vec2(surface_size.x/surface_size.y,1.0);
    float dist = length(pos);
    float pull = (1.0-p)*0.65;
    float warp = pull * exp(-dist*2.5);
    vec2 warped = uv + normalize(pos+vec2(0.001)) * warp * 0.18;
    vec4 c = texture(tex, warped);
    float hole = smoothstep(0.0, 0.04, 0.55 * p - dist + 0.04);
    float core = exp(-dist*12.0) * (1.0-p) * 0.7;
    vec3 rgb = c.rgb * hole + core * vec3(0.25,0.55,1.0) * hole;
    float alpha = hole * p;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
