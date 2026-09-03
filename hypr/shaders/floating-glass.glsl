#version 320 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

// Warped glass / heat haze - distorsi halus + rim light (premium)
void main() {
    vec2 uv = v_texcoord;
    float t = time * 0.85;

    // heat haze warp: gelombang halus di background
    vec2 warp = vec2(0.0);
    warp.x = sin(uv.y * 14.0 + t*1.2) * 0.004;
    warp.y = cos(uv.x * 12.0 + t*1.0) * 0.003;
    warp += vec2(sin(uv.y*28.0 - t*1.5)*0.0015, cos(uv.x*26.0 + t*1.3)*0.0015);

    vec4 col = texture(tex, uv + warp);
    vec3 rgb = col.rgb;

    // rim light di pinggir floating (biar kayak kaca tebal)
    float dist = length((uv - 0.5) * vec2(surface_size.x/surface_size.y, 1.0) * 2.0);
    float rim = 1.0 - smoothstep(0.65, 0.98, dist);
    rim = pow(rim, 1.6);
    // gerak rim tipis
    float rimPulse = 0.85 + 0.15 * sin(t*0.9);
    vec3 rimCol = vec3(0.75, 0.88, 1.0);
    rgb += rim * rimCol * 0.18 * rimPulse;

    // sedikit chromatic di pinggir
    vec2 ca = vec2(0.0012, 0.0) * rim;
    float r = texture(tex, uv + warp + ca).r;
    float b = texture(tex, uv + warp - ca).b;
    rgb.r = mix(rgb.r, r, rim*0.25);
    rgb.b = mix(rgb.b, b, rim*0.25);

    // biar baca tetap enak: warp cuma 0.4% jadi teks gak goyang parah
    rgb = clamp(rgb, 0.0, 1.0);

    fragColor = vec4(rgb * col.a, col.a);
}
