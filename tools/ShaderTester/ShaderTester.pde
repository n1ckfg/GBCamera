import processing.video.*;

Capture video;
int captureIndex = 0;
boolean preview;
PShader shader;
PGraphics buffer;
int textureSampleMode = 3;
int camW = 640;
int camH = 480;
int camFps = 30;

void setup() {
  size(1280, 960, P2D);
  ((PGraphicsOpenGL)g).textureSampling(textureSampleMode);
  noSmooth();

  buffer = createGraphics(width, height, P2D);
  ((PGraphicsOpenGL)buffer).textureSampling(textureSampleMode);
  buffer.noSmooth();

  //shader = loadShader("delay.glsl");
  //shader = loadShader("gameboy.glsl");
  //shader = loadShader("pixelvision.glsl");
  //shader = loadShader("vhsc.glsl");
  //shader = loadShader("tv.glsl");
  //shader = loadShader("hypercard.glsl");
  shader = loadShader("pencil_1.glsl");
  //shader = loadShader("film.glsl");

  if (System.getProperty("os.name").toLowerCase().startsWith("mac")) {
    video = new Capture(this, camW, camH, "pipeline: autovideosrc");
  } else {
    video = new Capture(this, camW, camH, Capture.list()[captureIndex], camFps);
  }
  video.start();

  shader.set("tex0", video);
  shader.set("iResolution", float(buffer.width), float(buffer.height));
}

void draw() {
  background(0);
  float time = (float) millis() / 1000.0;
  shader.set("time", time);

  buffer.beginDraw();
  buffer.image(video, 0, 0, buffer.width, buffer.height);
  buffer.filter(shader);
  buffer.endDraw();


  if (preview) {
    image(video, 0, 0, width, height);
  } else {
    translate(0, height);
    scale(1, -1);
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
