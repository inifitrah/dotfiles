#version 320 es
precision highp float;
// @duration 0.55
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform float seed;
uniform vec2 surface_size;

float easeOutCubic(float x){ return 1.0 - pow(1.0-x,3.0); }
float sdRoundedRect(vec2 p, vec2 size, float r){
    vec2 q = abs(p) - size + r;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0) - r;
}

void main(){
    float p = easeOutCubic(progress);
    vec2 uv = v_texcoord;
    vec2 center = vec2(0.5);
    vec2 pos = uv - center;
    pos.x *= surface_size.x / surface_size.y;

    // blob dari titik -> rounded rect full
    vec2 fullSize = vec2(0.5 * surface_size.x / surface_size.y, 0.5);
    vec2 curSize = mix(vec2(0.02), fullSize, p);
    float curR = mix(0.02, 0.04, p);
    float d = sdRoundedRect(pos, curSize, curR);
    float mask = 1.0 - smoothstep(0.0, 0.015, d);
    // sedikit wobble biar liquid
    float wobble = sin(length(pos)*12.0 + progress*6.28) * 0.015 * (1.0-p);
    float maskW = 1.0 - smoothstep(0.0, 0.015, d + wobble);

    vec4 texCol = texture(tex, uv);
    float alpha = maskW * p;
    // fade in dari tengah + blur tipis
    vec3 rgb = texCol.rgb * alpha;
    // gloss di tengah blob
    float gloss = exp(-length(pos)*4.0) * (1.0-p) * 0.35;
    rgb += vec3(0.7,0.9,1.0) * gloss * alpha;

    float a = texCol.a * alpha;
    fragColor = vec4(rgb * a, a);
}
