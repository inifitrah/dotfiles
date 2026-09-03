#version 320 es
precision highp float;
// @duration 0.55
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec2 center = vec2(0.5);
    float dist = length((uv - center) * vec2(surface_size.x/surface_size.y,1.0));
    // ripple dari tengah
    float wave = sin(dist*22.0 - p*18.0) * 0.015 * (1.0-p);
    vec2 warped = uv + normalize(uv-center+vec2(0.001))*wave;
    vec4 c = texture(tex, warped);
    // reveal dari tengah
    float reveal = 1.0 - smoothstep(0.0, 0.025, dist - p*0.9);
    float rippleRing = 1.0 - smoothstep(0.0, 0.08, abs(dist - p*0.7));
    float alpha = reveal;
    vec3 rgb = c.rgb * alpha;
    rgb += rippleRing * vec3(0.55,0.85,1.0) * 0.25 * (1.0-p) * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
