uniform sampler2D tex0;
uniform vec2 resolution;

const vec3 white = vec3(0.937, 0.937, 0.937);
const vec3 lightGray = vec3(0.686, 0.686, 0.686);
const vec3 darkGray = vec3(0.376, 0.376, 0.376);
const vec3 black = vec3(0.066, 0.066, 0.066);

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / resolution.xy;
    vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));
    vec4 texColor = texture2D(tex0, uv2);

    // Apply GameBoy Camera color palette
    vec3 color;
    if (texColor.r <= 0.25)
        color = black;
    else if (texColor.r <= 0.5)
        color = darkGray;
    else if (texColor.r <= 0.75)
        color = lightGray;
    else
        color = white;

    fragColor = vec4(color, texColor.a);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
