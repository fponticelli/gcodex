import gcx.Pointer;
using thx.Floats;

class BottomPlate {
  public static var emD = 25.4 / 8;
  static var w1 = 150;
  static var w2 = 100;
  public static var h1 = 60;
  static var h2 = 20;
  static var dh = h1 - h2;
  static var dw = w1 - w2;
  static var hdw = dw / 2;
  static var o = 5;
  static var mill = 150;
  static var passes = 3;
  static var material = 2.9;
  static var depth = -(material / passes).ceilTo(2);
  static var depthOverlay = 0.15;
  static var dx1 = w1 + emD;
  static var dx2 = w2 + emD;
  static var dy1 = h1 + emD;
  static var dy2 = h2 + emD;
  static var dyd = dy1 - dy2;
  static var dx = dx1 - dx2;
  static var hdx = dx / 2;
  static var d1 = 5.3;
  static var d2 = 9.8;
  static var screwHeadDepth = 0.8;

  static var hw1 = w1 / 2;

  public static function build(po : Pointer) {
    // holes
    var pos = [
      [ 10.0,10.0], [ 10.0,30.0], [ 10.0,50.0],
      [ 75.0,50.0], [ 40.0,50.0], [110.0,50.0],
      [140.0,50.0], [140.0,30.0], [140.0,10.0]
    ];
    for(hole in pos) {
      po.travel()
        .z(o)
        .abs(hole[0], hole[1])
        .z(0)
        .mill(mill)
        .screwHole(emD, d2, screwHeadDepth, d1, material, -depth, depthOverlay, 3);
    }

    // profile
    po.travel()
      .z(o)
      .abs(-emD/2, -emD/2)
      .z(0)
      .mill();
    for(i in 0...passes) {
      po.z(depth * (1 + i) - depthOverlay);
      profile(po);
    }

    po.travel()
      .z(o)
      .abs(0, 0);
  }

  static function profile(po : Pointer) {
    po.ry(dy1)
      .rx(dx1)
      .ry(-dy1)
      .rx(-20-emD)
      .ry( dy1-dy2)
      .rx(-dx1+40+emD*2)
      .ry(-dy1+dy2)
      .rx(-20-emD);
  }
}
