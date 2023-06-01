// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/

import processing.video.*;

Capture video;
boolean preview;
PShader shader_gb;
PGraphics buffer, buffer2, buffer3;

void setup() {
  size(1280, 960, P2D);
  noSmooth();

  buffer = createGraphics(150, 112, P2D);
  buffer.noSmooth();
  buffer2 = createGraphics(128, 112, P2D);
  buffer2.noSmooth();
  buffer3 = createGraphics(160, 144, P2D);
  buffer3.noSmooth();
  
  video = new Capture(this, 640, 480);
  video.start(); 
  setupDelay();
  
  shader_gb = loadShader("gb.glsl");
  shader_gb.set("iResolution", float(buffer.width), float(buffer.height));
  shader_gb.set("tex0", buffer);
}

void draw() {
  background(0);
  
  updateDelay();
    
  buffer2.beginDraw();
  buffer2.image(buffer, -11, 0);
  buffer2.endDraw();
  
  buffer3.beginDraw();
  buffer3.image(buffer2, 16, 16);
  buffer3.endDraw();
  
  if (preview) {
    image(video, 0, 0);
  } else {
    image(buffer3, 0, 0, width, height);
  }
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
