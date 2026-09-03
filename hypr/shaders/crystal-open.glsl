#version 320 es
precision highp float;
// @duration 0.48
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    // refraction: background distorted like glass
    float refr = (1.0 - p) * 0.008;
    vec2 offset = vec2(sin(uv.y*28.0)*refr, cos(uv.x*26.0)*refr);
    vec4 c = texture(tex, uv + offset);
    // chromatic aberration di edge
    float edge = length(uv - 0.5) * 1.8;
    edge = smoothstep(0.6, 1.0, edge) * (1.0-p) * 0.6;
    vec2 ca = vec2(0.0025,0.0) * edge * 8.0;
    float r = texture(tex, uv + offset + ca).r;
    float b = texture(tex, uv + offset - ca).b;
    vec3 rgb = c.rgb;
    rgb.r = mix(rgb.r, r, edge*0.5);
    rgb.b = mix(rgb.b, b, edge*0.5);
    // alpha fade in
    float alpha = p;
    // sedikit brighten bagian tengah biar glass pop
    float center = exp(-length(uv-0.5)*3.0) * (1.0-p) * 0.18;
    rgb += center * vec3(0.85,0.92,1.0);
    rgb *= alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
