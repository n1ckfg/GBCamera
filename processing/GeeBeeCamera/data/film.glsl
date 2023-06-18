uniform sampler2D tex0;
uniform vec2 iResolution;

const float gamma = 1.2;

float getLuminance(vec3 col) {
    return dot(col, vec3(0.299, 0.587, 0.114));
}

// https://github.com/dmnsgn/glsl-tone-map
vec3 tone_map_aces(vec3 x) {
  const float a = 2.51;
  const float b = 0.03;
  const float c = 2.43;
  const float d = 0.59;
  const float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

vec3 halation(vec3 col) {
    return vec3(getLuminance(col), col.y, col.z) * 0.25;
}

float map(float s, float a1, float a2, float b1, float b2) {
    return b1 + (s - a1) * (b2 - b1) / (a2 - a1);
}

vec3 adjustGamma(vec3 color, float gamma) {
    return pow(color, vec3(1.0 / gamma));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    //uv = vec2(uv.x, abs(1.0 - uv.y));
    vec3 col = adjustGamma(tone_map_aces(texture2D(tex0, uv).xyz), 1.2);   

    fragColor = vec4(col * col + halation(col), 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
