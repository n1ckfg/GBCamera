uniform sampler2D tex0, tex1;
uniform vec2 iResolution;

float getLuminance(vec3 col) {
    return 0.3*col.x + 0.59*col.y + 0.11*col.z;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    //vec2 uv2 = vec2(uv.x, abs(1.0 - uv.y));
    vec3 texColor0 = texture2D(tex0, uv).xyz;
    vec3 texColor1 = texture2D(tex1, uv).xyz;
    
    float luminance0 = getLuminance(texColor0);
    float luminance1 = getLuminance(texColor1);

    float diff = luminance0 - luminance1;
    float luminance2 = luminance1 + diff * 0.1;

    fragColor = vec4(luminance2, luminance2, luminance2, 1.0);
}

void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}
