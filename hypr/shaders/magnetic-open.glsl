#version 320 es
precision highp float;
// @duration 0.50
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

float easeOutBack(float x){
    float c1 = 1.70158; float c3 = c1+1.0;
    return 1.0 + c3*pow(x-1.0,3.0) + c1*pow(x-1.0,2.0);
}
void main(){
    float p = easeOutBack(clamp(progress,0.0,1.0));
    vec2 uv = v_texcoord;
    // tarik dari titik launcher (kiri bawah) ke center
    vec2 origin = vec2(0.15, 0.85);
    float dist = length(uv - origin);
    // scale + translate: kecil di origin -> full
    float scale = mix(0.22, 1.0, p);
    vec2 dir = uv - origin;
    vec2 scaled = origin + dir * scale;
    // elastic deformation: stretch sesuai arah tarik
    float stretch = (1.0 - p) * 0.18 * (1.0 - dist);
    scaled += normalize(dir + vec2(0.001)) * stretch;
    vec4 c = texture(tex, scaled);
    float outside = step(scaled.x,0.0)+step(1.0,scaled.x)+step(scaled.y,0.0)+step(1.0,scaled.y);
    float alpha = p * (1.0 - clamp(outside,0.0,1.0));
    // trail glow di belakang
    float trail = exp(-dist*4.0) * (1.0-p) * 0.35;
    vec3 rgb = c.rgb * alpha + trail * vec3(0.6,0.85,1.0);
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
