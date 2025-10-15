import 'package:app/models/animation/pallete/pallete_item.dart';

abstract class Pallete {
  static const int colorOff                 = 0;
  static const int colorWhite               = 1;
  static const int colorRedBright           = 2;
  static const int colorRedDim              = 3;
  static const int colorOrangeBright        = 4;
  static const int colorOrangeDim           = 5;
  static const int colorYellowBright        = 6;
  static const int colorYellowDim           = 7;
  static const int colorChartreuseBright    = 8;
  static const int colorChartreuseDim       = 9;
  static const int colorGreenBright         = 10;
  static const int colorGreenDim            = 11;
  static const int colorCyanBright          = 12;
  static const int colorCyanDim             = 13;
  static const int colorBlueBright          = 14;
  static const int colorBlueDim             = 15;

  static List<PalleteItem> palette = [
    PalleteItem(color: [0x00, 0x00, 0x00], name: "Off"),
    PalleteItem(color: [0xFF, 0xFF, 0xFF], name: "White"),
    PalleteItem(color: [0xFF, 0x00, 0x00], name: "Red Bright"),
    PalleteItem(color: [0x80, 0x00, 0x00], name: "Red Dim"),
    PalleteItem(color: [0xFF, 0x80, 0x00], name: "Orange Bright"),
    PalleteItem(color: [0x80, 0x40, 0x00], name: "Orange Dim"),
    PalleteItem(color: [0xFF, 0xFF, 0x00], name: "Yellow Bright"),
    PalleteItem(color: [0x80, 0x80, 0x00], name: "Yellow Dim"),
    PalleteItem(color: [0x80, 0xFF, 0x00], name: "Chartreuse Bright"),
    PalleteItem(color: [0x40, 0x80, 0x00], name: "Chartreuse Dim"),
    PalleteItem(color: [0x00, 0xFF, 0x00], name: "Green Bright"),
    PalleteItem(color: [0x00, 0x80, 0x00], name: "Green Dim"),
    PalleteItem(color: [0x00, 0xFF, 0xFF], name: "Cyan Bright"),
    PalleteItem(color: [0x00, 0x80, 0x80], name: "Cyan Dim"),
    PalleteItem(color: [0x00, 0x00, 0xFF], name: "Blue Bright"),
    PalleteItem(color: [0x00, 0x00, 0x80], name: "Blue Dim")
  ];
}


/// C definitons
// static const color_t COLOR_OFF                  = { 0x00, 0x00, 0x00 };
// static const color_t COLOR_WHITE                = { 0xFF, 0xFF, 0xFF };
// static const color_t COLOR_RED_BRIGHT           = { 0xFF, 0x00, 0x00 };
// static const color_t COLOR_RED_DIM              = { 0x80, 0x00, 0x00 };
// static const color_t COLOR_ORANGE_BRIGHT        = { 0xFF, 0x80, 0x00 };
// static const color_t COLOR_ORANGE_DIM           = { 0x80, 0x40, 0x00 };
// static const color_t COLOR_YELLOW_BRIGHT        = { 0xFF, 0xFF, 0x00 };
// static const color_t COLOR_YELLOW_DIM           = { 0x80, 0x80, 0x00 };
// static const color_t COLOR_CHARTREUSE_BRIGHT    = { 0x80, 0xFF, 0x00 };
// static const color_t COLOR_CHARTREUSE_DIM       = { 0x40, 0x80, 0x00 };
// static const color_t COLOR_GREEN_BRIGHT         = { 0x00, 0xFF, 0x00 };
// static const color_t COLOR_GREEN_DIM            = { 0x00, 0x80, 0x00 };
// static const color_t COLOR_CYAN_BRIGHT          = { 0x00, 0xFF, 0xFF };
// static const color_t COLOR_CYAN_DIM             = { 0x00, 0x80, 0x80 };
// static const color_t COLOR_BLUE_BRIGHT          = { 0x00, 0x00, 0xFF };
// static const color_t COLOR_BLUE_DIM             = { 0x00, 0x00, 0x80 };