// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/
// Based on ASCII Video by Ben Fry.

import processing.video.*;

Capture video;
boolean firstRun;
PShader shader_gb;
PGraphics buffer, buffer2;
int camW = 160;
int camH = 120;

void setup() {
  size(640, 480, P2D);
  buffer = createGraphics(camW, camH, P2D);
  buffer.noSmooth();
  buffer2 = createGraphics(camW, camH, P2D);
  buffer2.noSmooth();
  
  video = new Capture(this, 640, 480);
  video.start(); 
  setupDelay();
  
  shader_gb = loadShader("gb.glsl");
  shader_gb.set("iResolution", float(buffer.width), float(buffer.height));
}

void draw() {
  background(0);
  
  updateDelay();
    
  shader_gb.set("tex0", buffer);
  
  buffer2.beginDraw();
  buffer2.filter(shader_gb);
  buffer2.endDraw();
  
  image(buffer2, 0, 0, width, height);
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
