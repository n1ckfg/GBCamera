precision mediump float;

uniform sampler2D tex0;
uniform vec2 iResolution;

varying vec2 vTexCoord;

const vec3 white = vec3(0.937, 0.937, 0.937);
const vec3 lightGray = vec3(0.686, 0.686, 0.686);
const vec3 darkGray = vec3(0.376, 0.376, 0.376);
const vec3 black = vec3(0.066, 0.066, 0.066);

float getLuminance(vec3 col) {
    return dot(col, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec2 uv = vTexCoord.xy;
    vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));
    vec3 texColor = texture2D(tex0, uv2).xyz;
    
    float texGray = getLuminance(texColor);

    vec3 color;
    if (texGray <= 0.25) {
        color = black;
    } else if (texGray <= 0.5) {
        color = darkGray;
    } else if (texGray <= 0.75) {
        color = lightGray;
    } else {
        color = white;
    }

    gl_FragColor = vec4(color, 1.0);
}
