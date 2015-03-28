import gcx.Pointer;
using thx.core.Floats;

class LPlate {
  public static var emD = 25.4 / 8;
  static var w1 = 60;
  static var w2 = 20;
  static var h1 = 60;
  static var h2 = 20;
  static var dh = h1 - h2;
  static var dw = w1 - w2;
  static var o = 5;
  static var mill = 150;
  static var passes = 3;
  static var material = 3;
  static var depth = -(material / passes).ceilTo(2);
  static var depthOverlay = 0.2;
  static var dx1 = w1 + emD;
  static var dx2 = w2 + emD;
  static var dy1 = h1 + emD;
  static var dy2 = h2 + emD;
  static var dy = dy1 - dy2;
  static var dx = dx1 - dx2;
  static var d1 = 5.3;
  static var d2 = 9.3;
  static var screwHeadDepth = -1.5;

  public static function build(po : Pointer) {
    //po.matrix = thx.geom.Matrix44.rotationZ(Math.PI/2).multiply(thx.geom.Matrix44.translation(0,0,0));
    // holes
    var pos = [
      [ 10.0,50.0], [ 10.0,30.0], [ 10.0,10.0],
      [ 30.0,10.0], [ 50.0,10.0]
    ];
    for(hole in pos) {
      po.travel()
        .z(o)
        .abs(hole[0], hole[1])
        .z(0)
        .mill(mill)
        .screwHole(emD, d2, screwHeadDepth, d1, material, -depth, depthOverlay, passes);
    }

    // profile
    po.z(o)
      .abs(-emD/2, -emD/2);
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
      .rx(dx2)
      .ry(dy2-dy1)
      .rx(dx1-dx2)
      .ry(-dy2)
      .rx(-dx1);
  }
}
