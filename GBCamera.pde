import processing.javafx.*;

// https://petapixel.com/2022/05/05/a-review-of-the-nintendo-game-boy-camera-24-years-later/
// Based on ASCII Video by Ben Fry.

import processing.video.*;

Capture video;
boolean cheatScreen;

float[] bright;

PFont font;
float spacing = 1.5;


void setup() {
  size(640, 480);

  video = new Capture(this, 160, 120);

  video.start();

  int count = video.width * video.height;

  // current brightness for each point
  bright = new float[count];
  for (int i = 0; i < count; i++) {
    // set each brightness at the midpoint to start
    bright[i] = 128;
  }
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  background(0);

  pushMatrix();

  float hgap = width / float(video.width);
  float vgap = height / float(video.height);

  scale(max(hgap, vgap) * spacing);

  int index = 0;
  video.loadPixels();
  for (int y = 1; y < video.height; y++) {
    translate(0,  1.0 / spacing);

    pushMatrix();
    for (int x = 0; x < video.width; x++) {
      int pixelColor = video.pixels[index];
      // Faster method of calculating r, g, b than red(), green(), blue()
      int r = (pixelColor >> 16) & 0xff;
      int g = (pixelColor >> 8) & 0xff;
      int b = pixelColor & 0xff;

      // Another option would be to properly calculate brightness as luminance:
      // luminance = 0.3*red + 0.59*green + 0.11*blue
      // Or you could instead red + green + blue, and make the the values[] array
      // 256*3 elements long instead of just 256.
      int pixelBright = max(r, g, b);

      // The 0.1 value is used to damp the changes so that letters flicker less
      float diff = pixelBright - bright[index];
      bright[index] += diff * 0.1;

      int num = int(bright[index]);
      stroke(num);
      point(0,0);

      // Move to the next pixel
      index++;

      // Move over for next character
      translate(1.0 / spacing, 0);
    }
    popMatrix();
  }
  popMatrix();

  if (cheatScreen) {
    //image(video, 0, height - video.height);
    // set() is faster than image() when drawing untransformed images
    set(0, height - video.height, video);
  }
}
