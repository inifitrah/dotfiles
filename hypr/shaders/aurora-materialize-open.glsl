#version 320 es
precision highp float;
// @duration 0.60
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform float seed;
uniform vec2 surface_size;

float easeOutCubic(float x){ return 1.0 - pow(1.0-x,3.0); }

void main(){
    float p = progress;
    vec2 uv = v_texcoord;
    float aspect = surface_size.x / surface_size.y;
    vec2 pm = uv - 0.5; pm.x *= aspect;

    float t = p;
    // aurora muncul dulu 0.0-0.4
    float glowPhase = smoothstep(0.0, 0.15, t) * (1.0 - smoothstep(0.4, 0.75, t));
    // panel muncul 0.15-0.75
    float panel = smoothstep(0.15, 0.75, t);
    panel = easeOutCubic(panel);
    // overshoot settle 0.75-1.0
    float settle = smoothstep(0.75, 1.0, t);

    vec2 b1 = vec2(0.18*cos(t*2.0), 0.12*sin(t*2.2));
    vec2 b2 = vec2(0.22*cos(t*1.8+1.8), 0.15*sin(t*1.6+2.3));
    float d1 = length(pm - b1);
    float d2 = length(pm - b2);
    float aurora1 = exp(-d1*3.2) * glowPhase;
    float aurora2 = exp(-d2*3.0) * glowPhase;
    vec3 aurora = aurora1*vec3(0.25,0.75,0.95) + aurora2*vec3(0.55,0.45,0.95);
    aurora *= 0.9;

    vec4 texCol = texture(tex, uv);
    float alphaTex = texCol.a;
    // panel opacity 0->1, dengan aurora di belakang
    float alpha = panel;
    // glow overshoot: panel 70% di 0.40 sudah keliatan
    vec3 rgb = texCol.rgb * alpha + aurora * (0.35 + 0.25*settle);
    // sedikit brighten pas settle
    rgb *= 1.0 + settle*0.04;

    float a = alphaTex * alpha;
    fragColor = vec4(rgb * a, a);
}
