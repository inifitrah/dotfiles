#version 320 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

float hash(vec2 p){ return fract(sin(dot(p, vec2(127.1,311.7)))*43758.5453); }
float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    float a = hash(i);
    float b = hash(i+vec2(1.0,0.0));
    float c = hash(i+vec2(0.0,1.0));
    float d = hash(i+vec2(1.0,1.0));
    return mix(mix(a,b,f.x), mix(c,d,f.x), f.y);
}
float fbm(vec2 p){
    float v = 0.0;
    v += noise(p*1.0) * 0.5;
    v += noise(p*2.0) * 0.25;
    v += noise(p*4.0) * 0.125;
    v += noise(p*8.0) * 0.0625;
    return v;
}

// Flowing smoke - FBM mengalir pelan (4 octave, ringan)
void main() {
    vec4 col = texture(tex, v_texcoord);
    vec2 uv = v_texcoord;

    float t = time * 0.22;
    // smoke mengalir dari bawah ke atas + sedikit horizontal
    vec2 p = uv * 2.2 + vec2(t*0.35, t*0.55);
    float smoke = fbm(p);
    smoke = smoothstep(0.35, 0.75, smoke);
    // animate opacity
    float flow = 0.5 + 0.5 * sin(t*0.7 + uv.y*3.0);
    smoke *= 0.35 + flow*0.18;

    vec3 smokeCol = vec3(0.85, 0.86, 0.88);
    // dark smoke lebih cocok biar teks kebaca (overlay tipis)
    vec3 rgb = col.rgb;
    rgb = mix(rgb, rgb*0.88 + smokeCol*smoke*0.35, smoke*0.42);
    // glow pinggir smoke
    float edge = smoothstep(0.2, 0.9, smoke) * (1.0-smoke)*1.2;
    rgb += edge * smokeCol * 0.12;

    // vignette soft
    float vign = 1.0 - length((uv-0.5)*0.9)*0.10;
    rgb *= clamp(vign, 0.93, 1.0);

    fragColor = vec4(rgb * col.a, col.a);
}
