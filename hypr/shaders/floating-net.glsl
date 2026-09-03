#version 320 es
precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

// floating jaring animasi: grid + wave biar keren pas floating
void main() {
    vec4 col = texture(tex, v_texcoord);
    vec2 uv = v_texcoord;

    // grid lebih tipis + renggang biar tulisan kebaca
    float gridX = step(0.992, fract(uv.x * 14.0));
    float gridY = step(0.992, fract(uv.y * 14.0 * (surface_size.x / surface_size.y)));
    float grid = max(gridX, gridY);

    // wave lebih halus
    float wave = sin(uv.x * 10.0 + time * 1.6) * sin(uv.y * 10.0 + time * 1.4);
    wave = smoothstep(0.3, 0.8, wave * 0.5 + 0.5) * 0.18;

    // pulse lebih kalem (gak terlalu blink)
    float pulse = 0.65 + 0.25 * sin(time * 1.1);
    float net = grid * (0.45 + wave) * pulse;

    // warna jaring lebih soft, gak cyan terang
    vec3 netColor = vec3(0.55, 0.78, 0.88);

    // warp lebih tipis
    float warp = sin(uv.y * 6.0 + time * 0.9) * 0.0015 * pulse;
    vec4 colWarp = texture(tex, uv + vec2(warp, 0.0));
    vec3 rgb = mix(col.rgb, colWarp.rgb, 0.06);

    // apply net - DITURUNIN biar baca tetap nyaman
    rgb += net * netColor * 0.28;
    // glow jauh lebih tipis
    float glow = grid * 0.06 * pulse;
    rgb += glow * netColor * 0.12;

    // vignette lebih soft
    float vign = 1.0 - length((uv - 0.5) * 0.9) * 0.12;
    rgb *= clamp(vign, 0.92, 1.0);

    fragColor = vec4(rgb * col.a, col.a);
}
