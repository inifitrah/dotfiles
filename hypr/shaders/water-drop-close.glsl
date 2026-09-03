#version 320 es
precision highp float;
// @duration 0.45
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec2 center = vec2(0.5);
    float dist = length((uv-center)*vec2(surface_size.x/surface_size.y,1.0));
    float wave = sin(dist*22.0 + p*18.0) * 0.015 * p;
    vec2 warped = uv + normalize(uv-center+vec2(0.001))*wave;
    vec4 c = texture(tex, warped);
    float reveal = 1.0 - smoothstep(0.0, 0.025, dist - (1.0-p)*0.9);
    float alpha = reveal * (1.0-p);
    // collapse ke tengah
    vec3 rgb = c.rgb * alpha;
    float ring = 1.0 - smoothstep(0.0,0.08, abs(dist - (1.0-p)*0.7));
    rgb += ring * vec3(0.55,0.85,1.0) * 0.22 * p * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
