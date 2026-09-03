#version 320 es
precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

// smooth min polynomial - buat metaballs menyatu halus
float smin(float a, float b, float k) {
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * k * 0.25;
}

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

void main() {
    vec4 col = texture(tex, v_texcoord);
    vec2 uv = v_texcoord;
    // aspect correct biar bulat gak lonjong
    float aspect = surface_size.x / surface_size.y;
    vec2 p = uv - 0.5;
    p.x *= aspect;

    float t = time * 0.6;

    // 4 metaballs bergerak orbit beda kecepatan + radius beda
    vec2 c1 = vec2( 0.18 * cos(t * 0.9), 0.14 * sin(t * 1.1)) ;
    vec2 c2 = vec2( 0.20 * cos(t * 0.7 + 1.3), 0.16 * sin(t * 0.9 + 2.1));
    vec2 c3 = vec2( 0.15 * cos(t * 1.1 + 2.7), 0.18 * sin(t * 0.8 + 0.9));
    vec2 c4 = vec2( 0.12 * cos(t * 1.3 + 4.2), 0.12 * sin(t * 1.0 + 3.5));

    float r1 = 0.18;
    float r2 = 0.16;
    float r3 = 0.14;
    float r4 = 0.11;

    float d1 = sdCircle(p - c1, r1);
    float d2 = sdCircle(p - c2, r2);
    float d3 = sdCircle(p - c3, r3);
    float d4 = sdCircle(p - c4, r4);

    // gabung dengan smoothMin - biar nyatu kayak cairan
    float k = 0.18; // smoothness, makin besar makin liquid
    float d = d1;
    d = smin(d, d2, k);
    d = smin(d, d3, k);
    d = smin(d, d4, k);

    // metaball shape: 1 di dalam, smooth di tepi
    float blob = 1.0 - smoothstep(0.0, 0.025, d);
    // glow di luar tepi
    float glow = 1.0 - smoothstep(0.0, 0.18, d);
    glow *= 0.35;

    // warna liquid: gradient cyan -> purple
    vec3 colA = vec3(0.45, 0.78, 0.98);
    vec3 colB = vec3(0.78, 0.55, 0.98);
    float mixT = 0.5 + 0.5 * sin(t * 0.5 + length(p) * 3.0);
    vec3 liquid = mix(colA, colB, mixT);

    // biar tetap baca tulisan: liquid cuma overlay tipis, jangan nutup tex
    // inner blob lebih solid, glow lebih soft
    vec3 rgb = col.rgb;
    rgb = mix(rgb, liquid, blob * 0.22);
    rgb += glow * liquid * 0.45;

    // sedikit vignette biar floating pop tapi gak terang
    float vign = 1.0 - length((uv - 0.5) * 0.9) * 0.10;
    rgb *= clamp(vign, 0.94, 1.0);

    fragColor = vec4(rgb * col.a, col.a);
}
