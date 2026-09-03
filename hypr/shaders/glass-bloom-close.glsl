#version 320 es
precision highp float;
// @duration 0.35
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform float seed;
uniform vec2 surface_size;

float easeInCubic(float x){ return x*x*x; }

void main(){
    float p = easeInCubic(progress);
    vec2 uv = v_texcoord;
    float scale = mix(1.0, 0.88, p);
    vec2 scaled = (uv - 0.5) / scale + 0.5;

    float blur = p * 8.0;
    vec2 px = 1.0 / surface_size * blur;
    vec4 c0 = texture(tex, scaled);
    vec4 c1 = texture(tex, scaled + vec2(px.x,0.0));
    vec4 c2 = texture(tex, scaled - vec2(px.x,0.0));
    vec3 col = (c0.rgb + c1.rgb + c2.rgb)/3.0;
    float alphaTex = (c0.a+c1.a+c2.a)/3.0;

    float glow = p * 0.35 * (1.0 - length(uv-0.5)*0.8);
    vec3 bloomCol = vec3(0.7,0.88,1.0);
    col += glow * bloomCol * 0.4;

    float alpha = 1.0 - p;
    float outside = step(scaled.x,0.0)+step(1.0,scaled.x)+step(scaled.y,0.0)+step(1.0,scaled.y);
    alpha *= 1.0 - clamp(outside,0.0,1.0);
    // WAJIB transparan di 1.0 buat close
    alpha = clamp(alpha,0.0,1.0);

    col *= alpha;
    float a = alphaTex * alpha;
    fragColor = vec4(col * a, a);
}
