#version 320 es
precision highp float;
// @duration 0.42
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec4 c = texture(tex, uv);
    float alpha = 1.0 - p;
    vec3 rgb = c.rgb * alpha;
    float edgeDist = min(min(uv.x,1.0-uv.x), min(uv.y,1.0-uv.y));
    float onEdge = 1.0 - smoothstep(0.0,0.025, edgeDist);
    // energy tersedot ke satu titik (kanan bawah)
    vec2 sink = vec2(0.85, 0.85);
    float distSink = length(uv - sink);
    float energy = exp(-distSink*5.0) * p * 1.2 * onEdge;
    vec3 energyCol = vec3(0.15,0.95,1.0);
    rgb += energy * energyCol * 2.0 * alpha;
    rgb += onEdge * energyCol * 0.06 * (1.0-p) * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
