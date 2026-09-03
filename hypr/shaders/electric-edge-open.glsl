#version 320 es
precision highp float;
// @duration 0.50
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec4 c = texture(tex, uv);
    float alpha = p;
    vec3 rgb = c.rgb * alpha;
    // energy berjalan keliling border sekali
    float perim = 0.0;
    // hitung posisi di perimeter 0-1
    vec2 pos = uv;
    float edgeDist = min(min(pos.x, 1.0-pos.x), min(pos.y, 1.0-pos.y));
    float onEdge = 1.0 - smoothstep(0.0, 0.025, edgeDist);
    // posisi sepanjang border
    float t = p * 4.0;
    float borderPos = 0.0;
    if(pos.y < 0.02) borderPos = pos.x;
    else if(pos.x > 0.98) borderPos = 1.0 + pos.y;
    else if(pos.y > 0.98) borderPos = 2.0 + (1.0-pos.x);
    else if(pos.x < 0.02) borderPos = 3.0 + (1.0-pos.y);
    borderPos /= 4.0;
    float energyPos = fract(t);
    float energy = 1.0 - smoothstep(0.0, 0.12, abs(borderPos - energyPos));
    energy *= exp(-abs(borderPos-energyPos)*12.0);
    energy *= onEdge;
    vec3 energyCol = vec3(0.15, 0.95, 1.0) + vec3(0.95,0.85,0.25)*0.3;
    rgb += energy * energyCol * 2.2 * alpha;
    // glow tipis di edge
    rgb += onEdge * energyCol * 0.08 * p * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
