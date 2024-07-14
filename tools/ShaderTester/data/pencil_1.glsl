// Leon Denise https://www.shadertoy.com/view/XcsyRH

uniform sampler2D tex0;
uniform vec2 iResolution;

mat2 rot(float a) { 
    float c=cos(a),s=sin(a);
    return mat2(c,-s,s,c); 
}

float gyroid (vec3 seed) { 
    return dot(sin(seed),cos(seed.yzx)); 
}

float noise (vec3 p) {
    float result = 0., a = .5;
    for (int i = 0; i < 3; ++i, a/=2.) {
        result += gyroid(p/a)*a;
    }
    return result;
}

// Dave Hoskins https://www.shadertoy.com/view/4djSRW
vec4 hash41(float p) {
    vec4 p4 = fract(vec4(p) * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy+33.33);
    return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}

vec4 bufferImage(vec4 fragColor, vec2 fragCoord) {
    vec2 uv = fragCoord/iResolution.xy;
    vec2 aspect = vec2(iResolution.x/iResolution.y,1);
    vec4 frame = texture(tex0, uv);
    
    // timeline
    float tick = mod(float(iFrame), 200.);
    
    // init
    if (tick < 1.) {
        vec2 p = (2.*fragCoord-iResolution.xy)/iResolution.y;
        frame = vec4(p, length(p), 0);
        
        // extra shape
        //frame += step(frame.z, .9);
    } else if (tick < 30.) {    // iterate
        // previous coordinates
        vec2 p = frame.xy;
        
        // seed
        vec4 rng = hash41(tick+iDate.w+iDate.z+iDate.y+iDate.x);
        
        // rotate
        p.xy *= rot(rng.z*6.283);
        
        // translate
        p.xy += (rng.xy-.5)*2.;
        
        // curl
        vec2 e = vec2(.001,0);
        vec3 pos = vec3(p/2., length(p)/2.);
        float x = (noise(pos+e.yxy)-noise(pos-e.yxy))/(2.*e.x);
        float y = (noise(pos+e.xyy)-noise(pos-e.xyy))/(2.*e.x);
        vec2 curl = vec2(y, -x);
        p.xy += curl * .5 / tick; // comment this for sharp breaks
        
        // keep result if closer
        float dist = length(p);
        if (dist < frame.z) {
            frame.xy = p.xy;
            frame.z = dist;
            frame.w = tick;
        }
    }
    
    fragColor = frame;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord/iResolution.xy;
    
    // coordinates distance
    #define T(u) texture(tex0, uv+u/iResolution.xy).z
    float z = T(0.);
    
    float edge = 0.;
    float ao = 0.;
    
    const float count = 9.;
    for (float a = 0.; a < count; ++a) {
        // blue noise scroll https://www.shadertoy.com/view/tlySzR
        ivec2 pp = ivec2(fragCoord);
        pp = (pp+(int(a))*ivec2(113,127)) & 1023;
        vec3 blu = vec3(1,1,1); //texelFetch(iChannel1,pp,0).xyz;
        
        // edge detection
        float f = a/count;
        float aa = 6.283*f;
        vec2 xy = vec2(cos(aa),sin(aa));
        edge += abs(z-T(xy));
        
        // sort of ambient occlusion
        float r = (1.+blu.z) * 4.;
        xy = normalize(vec2(blu.xy-.5))*r;
        ao += abs(z-T(xy))/r;
    }
    
    vec3 color = vec3((1.-edge) * (1.-ao));

    fragColor = vec4(color, 1.);
}


void main() {
    mainImage(gl_FragColor, gl_FragCoord.xy);
}

