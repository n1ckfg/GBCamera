precision mediump float;

varying vec2 vTexCoord;

void main() {
  vec2 coord = vTexCoord;
  
  gl_FragColor = vec4(coord.x, coord.y, 0.5, 1.0 );
}