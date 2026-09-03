#version 320 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

// Aurora / fluid gradient - dark bg + blobs bergerak pelan + blur glow
void main() {
    vec4 col = texture(tex, v_texcoord);
    vec2 uv = v_texcoord;
    float aspect = surface_size.x / surface_size.y;
    vec2 p = uv - 0.5;
    p.x *= aspect;

    float t = time * 0.28;

    // 3 blobs aurora
    vec2 b1 = vec2( 0.18*cos(t*0.7), 0.12*sin(t*0.9));
    vec2 b2 = vec2( 0.22*cos(t*0.5+1.8), 0.15*sin(t*0.6+2.3));
    vec2 b3 = vec2( 0.16*cos(t*0.8+3.1), 0.10*sin(t*1.0+1.1));

    float d1 = length(p - b1);
    float d2 = length(p - b2);
    float d3 = length(p - b3);

    // soft blobs
    float blob1 = exp(-d1*3.2) * 0.9;
    float blob2 = exp(-d2*3.0) * 0.85;
    float blob3 = exp(-d3*3.5) * 0.8;

    vec3 c1 = vec3(0.25, 0.75, 0.95);
    vec3 c2 = vec3(0.55, 0.45, 0.95);
    vec3 c3 = vec3(0.95, 0.45, 0.65);

    vec3 aurora = blob1*c1 + blob2*c2 + blob3*c3;
    // blur pinggir: falloff
    float edge = smoothstep(0.6, 0.0, length(p)*1.1);
    aurora *= edge * 0.55;

    // biar baca tetap enak: overlay tipis + sedikit dark
    vec3 rgb = col.rgb;
    rgb = mix(rgb, rgb*0.92 + aurora, 0.30);
    // rim soft
    rgb += aurora * 0.12;

    float vign = 1.0 - length((uv-0.5)*0.9)*0.14;
    rgb *= clamp(vign, 0.92, 1.0);

    fragColor = vec4(rgb * col.a, col.a);
}
