#version 320 es
precision highp float;
// @duration 0.42
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

float hash(vec2 p){ return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    float block = mix(0.004, 0.08, p);
    vec2 grid = floor(uv / block) * block;
    float h = hash(grid*12.0);
    float threshold = (1.0 - p) + h*0.18 - 0.08;
    float mask = step(0.0, threshold);
    float soft = smoothstep(0.0,0.06, threshold);
    vec4 c = texture(tex, uv);
    float pop = 1.0 - smoothstep(0.0,0.12, threshold);
    vec2 blockUv = (uv-grid)/block -0.5;
    float scale = 1.0 + pop*0.35;
    vec2 warped = grid + (blockUv*scale+0.5)*block;
    vec4 cp = texture(tex, warped);
    vec3 rgb = mix(cp.rgb, c.rgb, pop*0.5) * mask * soft * (1.0-p);
    float alpha = mask * soft * (1.0-p);
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
