#version 320 es
precision highp float;
// @duration 0.50
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

float hash(vec2 p){ return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    // pixel block size mulai besar -> kecil
    float block = mix(0.08, 0.004, p);
    vec2 grid = floor(uv / block) * block;
    float h = hash(grid * 12.0);
    float threshold = p + h*0.18 - 0.08;
    float mask = step(0.0, threshold);
    float soft = smoothstep(0.0, 0.06, threshold);
    // block fill: kalau belum muncul, transparan
    vec4 c = texture(tex, uv);
    // pixel pop: block yang baru muncul ada scale tipis
    float pop = 1.0 - smoothstep(0.0, 0.12, threshold);
    vec2 blockUv = (uv - grid)/block - 0.5;
    float scale = 1.0 + pop * 0.35;
    vec2 warped = grid + (blockUv*scale + 0.5)*block;
    vec4 cp = texture(tex, warped);
    vec3 rgb = mix(c.rgb, cp.rgb, pop*0.5) * mask * soft;
    float alpha = mask * soft;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
