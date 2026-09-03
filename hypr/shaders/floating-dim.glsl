#version 320 es
precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform vec2 surface_size;

// floating windows: OBVIOUS test - biar keliatan jelas beda dari tiled
void main() {
    vec4 col = texture(tex, v_texcoord);
    // strong warm tint + boost biar floating langsung keliatan
    vec3 rgb = col.rgb;
    rgb = mix(rgb, vec3(1.15, 0.95, 0.75), 0.28); // warm
    rgb *= 1.08;
    rgb = clamp(rgb, 0.0, 1.0);
    // vignette lebih keliatan
    float vign = 1.0 - length((v_texcoord - 0.5) * 1.1) * 0.35;
    vign = clamp(vign, 0.82, 1.0);
    rgb *= vign;
    fragColor = vec4(rgb * col.a, col.a);
}
