// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/

import processing.video.*;

Capture video;
int captureIndex = 0;
boolean preview;
PShader shader_delay, shader_gb, shader_px;
PGraphics buffer0, buffer1, buffer2, buffer3, buffer4;
int textureSampleMode = 3;

void setup() {
  size(1280, 960, P2D);
  
  setupSpecs();
  
  ((PGraphicsOpenGL)g).textureSampling(textureSampleMode); 
  noSmooth();
  
  // 0. Original video image
  buffer0 = createGraphics(baseW, baseH, P2D);
  ((PGraphicsOpenGL)buffer0).textureSampling(textureSampleMode); 
  buffer0.noSmooth();

  // 1. Delay effect
  buffer1 = createGraphics(baseW, baseH, P2D);
  ((PGraphicsOpenGL)buffer1).textureSampling(textureSampleMode); 
  buffer1.noSmooth();
  buffer1.beginDraw();
  buffer1.background(127);
  buffer1.endDraw();
  
  // 2. GB palette effect
  buffer2 = createGraphics(baseW, baseH, P2D);
  ((PGraphicsOpenGL)buffer2).textureSampling(textureSampleMode); 
  buffer2.noSmooth();
  
  // 3. Crop to GB Camera image size
  buffer3 = createGraphics(cropW, cropH, P2D);
  ((PGraphicsOpenGL)buffer3).textureSampling(textureSampleMode); 
  buffer3.noSmooth();

  // 4. Expand to GB Camera final dimensions
  buffer4 = createGraphics(finalW, finalH, P2D);
  ((PGraphicsOpenGL)buffer4).textureSampling(textureSampleMode); 
  buffer4.noSmooth();
  
  video = new Capture(this, camW, camH, Capture.list()[captureIndex], camFps);
  video.start(); 

  shader_delay = loadShader("delay.glsl");
  shader_delay.set("iResolution", float(buffer0.width), float(buffer0.height));
  shader_delay.set("tex0", buffer0);
  shader_delay.set("tex1", buffer1);
  
  shader_gb = loadShader("gb.glsl");
  shader_gb.set("iResolution", float(buffer0.width), float(buffer0.height));
  shader_gb.set("tex0", buffer0);
  
  shader_px = loadShader("px.glsl");
  shader_px.set("iResolution", float(buffer0.width), float(buffer0.height));
  shader_px.set("tex0", buffer0);
}

void draw() {
  background(0);
  
  // 0. Original video image
  buffer0.beginDraw();
  buffer0.image(video, 0, 0, buffer0.width, buffer0.height);
  buffer0.filter(shader_delay);
  buffer0.endDraw();
  
  // 1. Delay effect
  buffer1.beginDraw();
  buffer1.image(buffer0, 0, 0);
  buffer1.endDraw();
  
  // 2. GB palette effect
  buffer2.beginDraw();
  buffer2.image(buffer0, 0, 0);
  switch(format) {
    case "gameboy":
      buffer0.filter(shader_gb);
      break;
    case "pixelvision":
      buffer0.filter(shader_px);
      break;
  }
  buffer2.endDraw();
  
  // 3. Crop to GB Camera image size
  buffer3.beginDraw();
  buffer3.image(buffer0, cropOffsetW, cropOffsetH);
  buffer3.endDraw();
  
  // 4. Expand to GB Camera final dimensions
  buffer4.beginDraw();
  buffer4.image(buffer3, marginW, marginH);
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
