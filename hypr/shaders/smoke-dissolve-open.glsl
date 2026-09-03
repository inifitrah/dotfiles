#version 320 es
precision highp float;
// @duration 0.55
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

float hash(vec2 p){ return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }
float noise(vec2 p){
    vec2 i=floor(p); vec2 f=fract(p); f=f*f*(3.0-2.0*f);
    float a=hash(i); float b=hash(i+vec2(1.0,0.0)); float c=hash(i+vec2(0.0,1.0)); float d=hash(i+vec2(1.0,1.0));
    return mix(mix(a,b,f.x), mix(c,d,f.x), f.y);
}

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    float n = noise(uv * 8.0);
    // threshold: pixel muncul kalau noise < progress
    float mask = step(n, p);
    // soften edge
    float soft = smoothstep(0.0, 0.08, p - n);
    vec4 c = texture(tex, uv);
    float alpha = mask * soft;
    // sedikit partikel glow di tepi yang baru muncul
    float edge = soft * (1.0 - mask*0.5) * 0.8;
    vec3 rgb = c.rgb * alpha + edge * vec3(0.75,0.78,0.82) * 0.25 * alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
