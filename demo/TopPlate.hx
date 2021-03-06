import gcx.Pointer;
using thx.Floats;

class TopPlate {
  public static var emD = 25.4 / 8;
  static var w1 = 150;
  static var w2 = 100;
  public static var h1 = 80;
  static var h2 = 40;
  static var dh = h1 - h2;
  static var dw = w1 - w2;
  static var hdw = dw / 2;
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
  static var dyd = dy1 - dy2;
  static var dx = dx1 - dx2;
  static var hdx = dx / 2;
  static var d1 = 5.3;
  static var d2 = 5.3;
  static var nemaD = 31;

  static var px = Math.cos(Math.PI / 4) * 19;
  static var py = Math.sin(Math.PI / 4) * 19;

  static var insertWidth = 15;
  static var insertCenter = 32;
  static var insertRadius = 10;

  static var hw1 = w1 / 2;

  public static function build(po : Pointer) {
    // nema holes
    var r2 = 31.0 / Math.sqrt(2),
        pos = [
          [0.0, 0.0], [0.0, 31.0],
          [31.0, 31.0], [31.0, 0.0]
        ]
      .map(function(xy) {
          return [w1 / 2 - 15.5 + xy[0], insertCenter - 15.5 + xy[1]];
        })
      .concat([
        [0.0, r2], [0.0, -r2]
      ].map(function(xy) {
          return [w1/2 + xy[0], insertCenter + xy[1]];
        }));

    for(hole in pos) {
      po.travel()
        .z(o)
        .abs(hole[0], hole[1])
        .z(0)
        .mill(mill);
      for(i in 0...2) {
        po.z(depth * passes - depthOverlay)
          .z(0);
      }
    }

    // holes
    var pos = [
      [10.0,50.0,d1], [10.0,70.0,d1],
      [hw1 - 23, insertCenter, d2], [hw1 - 23, insertCenter + 18, d2],
      [hw1 + 23, insertCenter + 18, d2], [hw1 + 23, insertCenter, d2],
      [140.0,50.0,d1], [140.0,70.0,d1],
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

    // big center cut
    po.travel()
      .z(o)
      .abs(hw1 - insertRadius, insertCenter)
      .z(0)
      .mill(mill);

    for(i in 0...passes) {
      po.z(depth * (1 + i) - depthOverlay)
        .circle(hw1, insertCenter)
        .circleCCW(hw1, insertCenter)
        .circle(hw1, insertCenter);
    }

    po.travel()
      .z(o)
      .abs(-emD/2, h1 + emD/2)
      .z(0)
      .mill(mill);

    // profile
    for(i in 0...passes) {
      po.z(depth * (1 + i) - depthOverlay);
      profile(po);
    }

    po.travel()
      .z(o)
      .abs(0, 0);
  }

  static function profile(po : Pointer) {
    po.rx(dx1)
      .ry(-dy2)
      .rx(-hdx)
      .rarc(-dyd, 0, -dyd, -dyd)
      .rx(-dx2 + dyd * 2)
      .rarc(0, dyd, -dyd, dyd)
      .rx(-hdx)
      .ry(dy2);
  }
}
