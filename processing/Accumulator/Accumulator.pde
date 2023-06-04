import processing.video.*;

Capture video;
int textureSampleMode = 3;
PShader shader_delay;
PGraphics buffer;

void setup() {
  size(1280, 960, P2D);
  ((PGraphicsOpenGL)g).textureSampling(textureSampleMode); 
  noSmooth();
  
  buffer = createGraphics(150, 112, P2D);
  ((PGraphicsOpenGL)buffer).textureSampling(textureSampleMode); 
  buffer.noSmooth();
  
  video = new Capture(this, 640, 480);
  video.start(); 
  
  shader_delay = loadShader("delay.glsl");
  shader_delay.set("iResolution", float(buffer.width), float(buffer.height));
  shader_delay.set("tex0", buffer);
}

void draw() {
  background(0);

  buffer.beginDraw();
  buffer.image(video, 0, 0, buffer.width, buffer.height);
  buffer.filter(shader_delay);
  buffer.endDraw();
  
  image(buffer, 0, 0, width, height);
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
