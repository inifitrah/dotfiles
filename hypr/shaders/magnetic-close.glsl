#version 320 es
precision highp float;
// @duration 0.42
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

float easeInBack(float x){
    float c1 = 1.70158;
    return c1*pow(x,3.0) - c1*pow(x,2.0) + pow(x,3.0);
}
void main(){
    float p = easeInBack(clamp(progress,0.0,1.0));
    vec2 uv = v_texcoord;
    vec2 origin = vec2(0.15, 0.85);
    vec2 dir = uv - origin;
    float scale = mix(1.0, 0.22, p);
    vec2 scaled = origin + dir * scale;
    vec4 c = texture(tex, scaled);
    float outside = step(scaled.x,0.0)+step(1.0,scaled.x)+step(scaled.y,0.0)+step(1.0,scaled.y);
    float alpha = (1.0-p) * (1.0 - clamp(outside,0.0,1.0));
    float trail = exp(-length(uv-origin)*4.0) * p * 0.30;
    vec3 rgb = c.rgb * alpha + trail * vec3(0.6,0.85,1.0) * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
