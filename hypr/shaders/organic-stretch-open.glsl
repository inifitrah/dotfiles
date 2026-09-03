#version 320 es
precision highp float;
// @duration 0.52
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

float easeOutElastic(float x){
    float c4 = 2.0*3.14159265/3.0;
    return x==0.0?0.0 : x==1.0?1.0 : pow(2.0,-10.0*x)*sin((x*10.0-0.75)*c4)+1.0;
}

void main(){
    float p = easeOutElastic(clamp(progress,0.0,1.0));
    p = clamp(p,0.0,1.0);
    vec2 uv = v_texcoord;
    // muncul dari bawah, bagian bawah tertinggal
    float stretch = (1.0 - progress) * 0.18 * (1.0 - uv.y);
    vec2 warped = uv - vec2(0.0, stretch);
    // scale kecil -> full dengan sedikit overshoot
    float scale = mix(0.92, 1.0, p);
    vec2 scaled = (warped - 0.5)/scale + 0.5;
    vec4 c = texture(tex, scaled);
    float outside = step(scaled.x,0.0)+step(1.0,scaled.x)+step(scaled.y,0.0)+step(1.0,scaled.y);
    float alpha = p * (1.0 - clamp(outside,0.0,1.0));
    vec3 rgb = c.rgb * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
