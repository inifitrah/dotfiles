#version 320 es
precision highp float;
// @duration 0.35
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;
uniform float progress;
uniform vec2 surface_size;

void main(){
    float p = clamp(progress,0.0,1.0);
    vec2 uv = v_texcoord;
    vec4 c = texture(tex, uv);
    float blur = p*4.0;
    vec2 px = 1.0/surface_size * blur *0.5;
    vec4 bl = (texture(tex, uv+vec2(px.x,0.0)) + texture(tex, uv-vec2(px.x,0.0)))/2.0;
    vec3 rgb = mix(c.rgb, bl.rgb, p*0.4);
    float dist = length((uv-0.5)*vec2(surface_size.x/surface_size.y,1.0)*2.0);
    float rim = 1.0 - smoothstep(0.55,0.85,dist);
    rim *= (1.0-p)*0.18;
    rgb += rim * vec3(0.75,0.88,1.0) * (1.0-p);
    float alpha = 1.0 - p;
    rgb *= alpha;
    float a = c.a * alpha;
    fragColor = vec4(rgb * a, a);
}
