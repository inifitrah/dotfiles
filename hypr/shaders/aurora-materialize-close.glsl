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

void main(){
    float p = easeInCubic(progress);
    vec2 uv = v_texcoord;
    vec2 pm = uv - 0.5; pm.x *= surface_size.x / surface_size.y;

    // close: panel hilang dulu, aurora ngikut hilang
    float panel = 1.0 - smoothstep(0.0, 0.6, p);
    float glow = (1.0 - p) * exp(-length(pm)*2.5) * 0.5;

    vec3 aurora = glow * vec3(0.45,0.65,0.95);
    vec4 texCol = texture(tex, uv);
    float alpha = panel;
    vec3 rgb = texCol.rgb * alpha + aurora * alpha;
    float a = texCol.a * alpha;
    // WAJIB 0 di p=1
    fragColor = vec4(rgb * a, a);
}
