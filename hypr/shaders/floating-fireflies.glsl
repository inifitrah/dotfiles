#version 320 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float time;
uniform vec2 surface_size;

// Soft particles / fireflies - background transparan, partikel melayang blur/glow
float hash(vec2 p){ return fract(sin(dot(p, vec2(127.1,311.7)))*43758.5453); }

void main() {
    vec4 col = texture(tex, v_texcoord);
    vec2 uv = v_texcoord;
    float aspect = surface_size.x / surface_size.y;
    vec2 p = uv - 0.5;
    p.x *= aspect;

    vec3 rgb = col.rgb;
    float t = time;

    // 7 fireflies
    for(int i=0; i<7; i++){
        float fi = float(i);
        float h = hash(vec2(fi, 42.0));
        vec2 base = vec2(hash(vec2(fi,1.0))-0.5, hash(vec2(fi,2.0))-0.5) * 0.8;
        // gerakan melayang pelan + acak
        vec2 pos = base + vec2(0.10*sin(t*0.6 + h*6.28), 0.08*cos(t*0.5 + h*4.2));
        float d = length(p - pos);
        float size = 0.025 + h*0.015;
        float blink = 0.6 + 0.4 * sin(t*1.8 + h*12.0);
        float spot = 1.0 - smoothstep(0.0, size, d);
        spot *= blink;
        // glow
        float glow = 1.0 - smoothstep(0.0, size*4.0, d);
        glow *= 0.25 * blink;
        vec3 fire = vec3(1.0, 0.92, 0.55);
        // campur warm/cool variasi
        if(mod(fi,2.0) > 0.5) fire = vec3(0.7, 0.95, 1.0);
        rgb += spot * fire * 0.9;
        rgb += glow * fire * 0.45;
    }

    // vignette tipis biar floating tetap kartu
    float vign = 1.0 - length((uv-0.5)*0.9)*0.08;
    rgb *= clamp(vign, 0.96, 1.0);

    fragColor = vec4(rgb * col.a, col.a);
}
