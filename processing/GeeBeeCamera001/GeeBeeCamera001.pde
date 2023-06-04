import processing.video.*;

Capture video;
int textureSampleMode = 3;
PShader shader_delay;
PGraphics buffer0, buffer1;

void setup() {
  size(1280, 960, P2D);
  ((PGraphicsOpenGL)g).textureSampling(textureSampleMode); 
  noSmooth();
  
  buffer0 = createGraphics(150, 112, P2D);
  ((PGraphicsOpenGL)buffer0).textureSampling(textureSampleMode); 
  buffer0.noSmooth();
  
  buffer1 = createGraphics(150, 112, P2D);
  ((PGraphicsOpenGL)buffer1).textureSampling(textureSampleMode); 
  buffer1.noSmooth();
  buffer1.beginDraw();
  buffer1.background(127);
  buffer1.endDraw();
  
  video = new Capture(this, 640, 480);
  video.start(); 
  
  shader_delay = loadShader("gb001.glsl");
  shader_delay.set("iResolution", float(buffer0.width), float(buffer0.height));
  shader_delay.set("tex0", buffer0);
  shader_delay.set("tex1", buffer1);
}

void draw() {
  background(0);

  buffer0.beginDraw();
  buffer0.image(video, 0, 0, buffer0.width, buffer0.height);
  buffer0.filter(shader_delay);
  buffer0.endDraw();
  
  buffer1.beginDraw();
  buffer1.image(buffer0, 0, 0);
  buffer1.endDraw();
  
  image(buffer0, 0, 0, width, height);
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
