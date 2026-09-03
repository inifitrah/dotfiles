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
    float stretch = p * 0.18 * (1.0 - uv.y);
    vec2 warped = uv + vec2(0.0, stretch);
    float scale = mix(1.0, 0.92, p);
    vec2 scaled = (warped - 0.5)/scale + 0.5;
    vec4 c = texture(tex, scaled);
    float outside = step(scaled.x,0.0)+step(1.0,scaled.x)+step(scaled.y,0.0)+step(1.0,scaled.y);
    float alpha = (1.0-p) * (1.0 - clamp(outside,0.0,1.0));
    vec3 rgb = c.rgb * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
