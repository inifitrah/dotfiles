#version 320 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

// Neon plasma - noise + sine + chromatic glow (cyberpunk)

float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1,311.7)))*43758.5453); }
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    float a = hash(i);
    float b = hash(i+vec2(1.0,0.0));
    float c = hash(i+vec2(0.0,1.0));
    float d = hash(i+vec2(1.0,1.0));
    return mix(mix(a,b,f.x), mix(c,d,f.x), f.y);
}

void main() {
    vec4 col = texture(tex, v_texcoord);
    vec2 uv = v_texcoord;

    float t = time * 0.9;
    vec2 p = uv * 3.5 + t*0.35;

    // plasma waves
    float n1 = noise(p*1.2 + t*0.6);
    float n2 = noise(p*2.0 - t*0.4);
    float plasma = sin(n1*6.28 + n2*4.0 + t*1.2);
    plasma = plasma*0.5+0.5;
    plasma = smoothstep(0.35, 0.85, plasma);

    // chromatic shift (glow warna beda per channel)
    vec2 shift = vec2(0.0025, 0.0);
    vec3 rgb = col.rgb;
    // subtle chromatic on plasma area
    float edge = plasma * 0.18;
    vec3 plasmaCol = vec3(0.15, 0.95, 0.95) * plasma + vec3(0.95,0.25,0.95) * (1.0-plasma)*0.5;
    rgb += plasmaCol * plasma * 0.22;
    // chromatic aberration tipis
    float r = texture(tex, uv + shift).r;
    float b = texture(tex, uv - shift).b;
    rgb.r = mix(rgb.r, r, edge*0.35);
    rgb.b = mix(rgb.b, b, edge*0.35);

    // glow pinggir plasma
    float glow = exp(-abs(plasma-0.5)*6.0) * 0.18;
    rgb += plasmaCol * glow;

    // biar baca kebaca: jangan full, cuma 25% overlay
    rgb = mix(col.rgb, rgb, 0.42);

    fragColor = vec4(rgb * col.a, col.a);
}
