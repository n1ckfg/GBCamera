import processing.video.*;

Capture video;
int captureIndex = 1;
boolean preview;
PShader shader;
PGraphics buffer;
int textureSampleMode = 3;

void setup() {
  size(1280, 720, P2D);

  buffer = createGraphics(width, height, P2D);
  ((PGraphicsOpenGL)buffer).textureSampling(textureSampleMode); 
  buffer.noSmooth();
  
  ((PGraphicsOpenGL)g).textureSampling(textureSampleMode); 
  noSmooth();
 
  //shader = loadShader("delay.glsl");
  //shader = loadShader("gameboy.glsl");
  shader = loadShader("pixelvision.glsl");
  //shader = loadShader("vhsc.glsl");
  //shader = loadShader("tv.glsl");
  //shader = loadShader("hypercard.glsl");
  //shader = loadShader("film.glsl");
  
  if (System.getProperty("os.name").toLowerCase().startsWith("mac")) {
    video = new Capture(this, 640, 480, "pipeline:autovideosrc");
  } else {
    video = new Capture(this, 640, 480, Capture.list()[captureIndex], 30);
  }
  video.start(); 

  shader.set("tex0", buffer);
  shader.set("iResolution", float(buffer.width), float(buffer.height));
}

void draw() {
  background(0);
  float time = (float) millis() / 1000.0;
    
  if (preview) {
    image(video, 0, 0, width, height);
  } else {
    shader.set("time", time);

    buffer.beginDraw();
    buffer.image(video, 0, 0, buffer.width, buffer.height);
    buffer.filter(shader);
    buffer.endDraw();
    
    image(buffer, 0, 0, width, height);
  }
    
  surface.setTitle("" + frameRate);
}

void captureEvent(Capture c) {
  c.read();
}

void keyPressed() {
  preview = !preview;
}
