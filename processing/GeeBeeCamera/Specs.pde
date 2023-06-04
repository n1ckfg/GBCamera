String format = "gameboy";
//String format = "pixelvision";

int camW, camH, camFps, baseW, baseH, cropW, cropH, finalW, finalH;
int cropOffsetW, cropOffsetH, marginW, marginH;

void setupSpecs() {
  switch(format) {
    case "gameboy":
      camW = 640;
      camH = 480;
      camFps = 30;
      baseW = 150;
      baseH = 112;
      cropW = 128;
      cropH = 112;
      finalW = 160;
      finalH = 144;
      break;
    case "pixelvision":
      camW = 640;
      camH = 480;
      camFps = 15;
      baseW = 120;
      baseH = 90;
      cropW = 120;
      cropH = 90;
      finalW = 160;
      finalH = 120;
      break;
  }
  
  cropOffsetW = -1 * ((baseW-cropW)/2);
  cropOffsetH = -1 * ((baseH-cropH)/2);
  marginW = (finalW - cropW)/2;
  marginH = (finalH - cropH)/2;
}
