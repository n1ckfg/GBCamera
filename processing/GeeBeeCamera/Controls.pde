void keyPressed() {
  switch(key) {
    case '1':
      setupSpecs("gameboy");
      break;
    case '2':
      setupSpecs("pixelvision");
      break;
    case '3':
      setupSpecs("vhs-c");
      break;
    case 'p':
      preview = !preview;
      break;
  }
}
