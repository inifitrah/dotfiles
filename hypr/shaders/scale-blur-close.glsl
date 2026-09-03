#version 320 es
precision highp float;
// @duration 0.30
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform float seed;
uniform vec2 surface_size;

float easeBack(float x){
    float c = 1.70158;
    return 1.0 + (c+1.0)*pow(x-1.0,3.0) + c*pow(x-1.0,2.0);
}

void main(){
    float p = progress;
    // close: 1.00 -> 0.96 dengan sedikit overshoot kebalik
    float scale = mix(1.0, 0.96, easeBack(p));
    vec2 uv = v_texcoord;
    vec2 scaled = (uv - 0.5)/scale + 0.5;
    float blur = mix(0.0, 8.0, p);
    vec2 px = 1.0 / surface_size * blur * 0.5;
    vec4 c0 = texture(tex, scaled);
    vec4 c1 = texture(tex, scaled + vec2(px.x,0.0));
    vec4 c2 = texture(tex, scaled - vec2(px.x,0.0));
    vec4 c3 = texture(tex, scaled + vec2(0.0,px.y));
    vec4 c4 = texture(tex, scaled - vec2(0.0,px.y));
    vec3 col = (c0.rgb + c1.rgb + c2.rgb + c3.rgb + c4.rgb)/5.0;
    float aTex = (c0.a+c1.a+c2.a+c3.a+c4.a)/5.0;
    float alpha = 1.0 - p;
    float outside = step(scaled.x,0.0)+step(1.0,scaled.x)+step(scaled.y,0.0)+step(1.0,scaled.y);
    alpha *= 1.0 - clamp(outside,0.0,1.0);
    col *= alpha;
    float a = aTex * alpha;
    fragColor = vec4(col * a, a);
}
