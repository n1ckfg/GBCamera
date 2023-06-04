// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/

import processing.video.*;

Capture video;
boolean preview;
PShader shader_gb1, shader_gb2;
PGraphics buffer0, buffer1, buffer2, buffer3, buffer4;
int textureSampleMode = 3;

void setup() {
  size(1280, 960, P2D);
  ((PGraphicsOpenGL)g).textureSampling(textureSampleMode); 
  noSmooth();
  
  // 0. Original video image
  buffer0 = createGraphics(150, 112, P2D);
  ((PGraphicsOpenGL)buffer0).textureSampling(textureSampleMode); 
  buffer0.noSmooth();

  // 1. Delay effect
  buffer1 = createGraphics(150, 112, P2D);
  ((PGraphicsOpenGL)buffer1).textureSampling(textureSampleMode); 
  buffer1.noSmooth();
  buffer1.beginDraw();
  buffer1.background(127);
  buffer1.endDraw();
  
  // 2. GB palette effect
  buffer2 = createGraphics(150, 112, P2D);
  ((PGraphicsOpenGL)buffer2).textureSampling(textureSampleMode); 
  buffer2.noSmooth();
  
  // 3. Crop to GB Camera image size
  buffer3 = createGraphics(128, 112, P2D);
  ((PGraphicsOpenGL)buffer3).textureSampling(textureSampleMode); 
  buffer3.noSmooth();

  // 4. Expand to GB Camera final dimensions
  buffer4 = createGraphics(160, 144, P2D);
  ((PGraphicsOpenGL)buffer4).textureSampling(textureSampleMode); 
  buffer4.noSmooth();
  
  video = new Capture(this, 640, 480);
  video.start(); 

  shader_gb1 = loadShader("gb001.glsl");
  shader_gb1.set("iResolution", float(buffer0.width), float(buffer0.height));
  shader_gb1.set("tex0", buffer0);
  shader_gb1.set("tex1", buffer1);
  
  shader_gb2 = loadShader("gb002.glsl");
  shader_gb2.set("iResolution", float(buffer0.width), float(buffer0.height));
  shader_gb2.set("tex0", buffer0);
}

void draw() {
  background(0);
  
  // 0. Original video image
  buffer0.beginDraw();
  buffer0.image(video, 0, 0, buffer0.width, buffer0.height);
  buffer0.filter(shader_gb1);
  buffer0.endDraw();
  
  // 1. Delay effect
  buffer1.beginDraw();
  buffer1.image(buffer0, 0, 0);
  buffer1.endDraw();
  
  // 2. GB palette effect
  buffer2.beginDraw();
  buffer2.image(buffer0, 0, 0);
  buffer0.filter(shader_gb2);
  buffer2.endDraw();
  
  // 3. Crop to GB Camera image size
  buffer3.beginDraw();
  buffer3.image(buffer0, -11, 0);
  buffer3.endDraw();
  
  // 4. Expand to GB Camera final dimensions
  buffer4.beginDraw();
  buffer4.image(buffer3, 16, 16);
  buffer4.endDraw();
  
  if (preview) {
    image(video, 0, 0);
  } else {
    image(buffer4, 0, 0, width, height);
  }
  
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}
