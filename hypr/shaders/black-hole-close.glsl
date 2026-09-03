#version 320 es
precision highp float;
// @duration 0.55
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
    // radial distortion menuju titik
    float pull = p * 0.65;
    float warp = pull * exp(-dist*2.5);
    vec2 warped = uv - normalize(pos+vec2(0.001)) * warp * 0.18;
    vec4 c = texture(tex, warped);
    // collapse: mask mengecil ke titik
    float hole = 1.0 - smoothstep(0.0, 0.04, dist - (0.55 - p*0.55));
    // di tengah black hole glow
    float core = exp(-dist*12.0) * p * 0.9;
    vec3 rgb = c.rgb * hole * (1.0-p);
    rgb += core * vec3(0.25,0.55,1.0) * 1.2 * (1.0 - smoothstep(0.5,1.0,p));
    // vignette collapse
    float alpha = (1.0 - p) * hole;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
