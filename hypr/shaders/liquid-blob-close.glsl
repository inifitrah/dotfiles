#version 320 es
precision highp float;
// @duration 0.45
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform float seed;
uniform vec2 surface_size;

float easeInCubic(float x){ return x*x*x; }
float sdRoundedRect(vec2 p, vec2 size, float r){
    vec2 q = abs(p) - size + r;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0) - r;
}

void main(){
    float p = easeInCubic(progress);
    vec2 uv = v_texcoord;
    vec2 pos = uv - 0.5;
    pos.x *= surface_size.x / surface_size.y;
    vec2 fullSize = vec2(0.5 * surface_size.x / surface_size.y, 0.5);
    vec2 curSize = mix(fullSize, vec2(0.02), p);
    float curR = mix(0.04, 0.02, p);
    float d = sdRoundedRect(pos, curSize, curR);
    float wobble = sin(length(pos)*12.0 + progress*6.28) * 0.015 * p;
    float mask = 1.0 - smoothstep(0.0, 0.015, d + wobble);
    vec4 texCol = texture(tex, uv);
    float alpha = mask * (1.0 - p);
    vec3 rgb = texCol.rgb * alpha;
    float gloss = exp(-length(pos)*4.0) * p * 0.30;
    rgb += vec3(0.7,0.9,1.0) * gloss * alpha;
    float a = texCol.a * alpha;
    // WAJIB 0 di p=1
    fragColor = vec4(rgb * a, a);
}
