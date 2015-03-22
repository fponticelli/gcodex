import gcx.Pointer;
using thx.core.Floats;

class CartPlate {
  static var w = 100;
  static var h = 80;
  static var o = 5;
  static var mill = 120;
  static var passes = 3;
  static var material = 3;
  static var depth = -(material / passes).ceilTo(2);
  static var depthOverlay = 0.2;
  static var emD = 25.4 / 8;
  static var r = 2 + emD / 2;
  static var dx = w - 2 * r + emD;
  static var dy = h - 2 * r + emD;
  static var d1 = 5.3;
  static var d2 = 5.3;

  static var px = Math.cos(Math.PI / 4) * 19;
  static var py = Math.sin(Math.PI / 4) * 19;

  static var insertWidth = 15;
  static var insertCenter = 28;
  static var insertRadius = 10;

  static var hw = w / 2;

  public static function build(po : Pointer) {
    // holes
    var pos = [
      [10.0,10.0,d1], [10.0,30.0,d1], [10.0,50.0,d1], [10.0,70.0,d1],
      [hw - px, insertCenter + py, d2], [hw - 19, insertCenter, d2], [hw - px, insertCenter - py, d2],
      [hw + px, insertCenter - py, d2], [hw + 19, insertCenter, d2], [hw + px, insertCenter + py, d2],
      [90.0,10.0,d1], [90.0,30.0,d1], [90.0,50.0,d1], [90.0,70.0,d1],

      //[70.0,70.0,d2], [70.0,50.0,d2], [70.0,30.0,d2], [70.0,10.0,d2],
    ];
    for(hole in pos) {
      po.travel()
        .z(o)
        .abs(hole[0], hole[1])
        .z(0)
        .mill(mill);
      for(i in 0...passes) {
        po.z(depth * (1 + i) - depthOverlay)
          .hole(emD, hole[2], 3);
      }
    }
    po.travel()
      .z(o)
      .abs(-emD/2, r-emD/2)
      .z(0)
      .mill(mill);

    // profile
    for(_ in 0...passes) {
      po.rz(depth);
      profile(po);
    }

    po.z(o)
      .abs(0, 0);
  }
  static function profile(po : Pointer) {
    var sx = (dx - insertWidth) / 2 - r,
        dsx = insertWidth / 2,
        sh = Math.sqrt(insertRadius * insertRadius - dsx * dsx),
        sy = insertCenter - sh - r / 2;

    po.ry(dy)
      .rarc(r, 0, r, r)
      .rx(dx)
      .rarc(0, -r, r, -r)
      .ry(-dy)
      .rarc(-r, 0, -r, -r)
      .rx(-sx)
      .rarc(0, r, -r, r)
      .ry(sy)
      .rarcCCW(-dsx, sh, -dsx*2, 0)
      .ry(-sy)
      .rarc(-r, 0, -r, -r)
      .rx(-sx)
      .rarc(0, r, -r, r);
  }
}
