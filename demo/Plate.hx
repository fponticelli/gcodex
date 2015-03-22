import gcx.Pointer;
using thx.core.Floats;

class Plate {
  public static function build(po : Pointer) {
    var w = 80,
        h = w,
        o = 5,
        mill = 150,
        passes = 3,
        material = 3,
        depth = -(material / passes).ceilTo(2),
        depthOverlay = 0.2,
        emD = 25.4 / 8,
        r = 1 + emD / 2,
        dx = w - 2 * r + emD,
        dy = h - 2 * r + emD,
        d1 = 5.3,
        d2 = 7.5;

    // holes
    var pos = [
      [10.0,10.0,d1], [30.0,10.0,d1], [10.0,30.0,d1], [30.0,30.0,d1],
      [10.0,50.0,d1], [30.0,50.0,d1], [10.0,70.0,d1], [30.0,70.0,d1],
      [70.0,70.0,d2], [70.0,50.0,d2], [70.0,30.0,d2], [70.0,10.0,d2],
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
      po.rz(depth)
        .ry(dy)
        .rarc(r, 0, r, r)
        .rx(dx)
        .rarc(0, -r, r, -r)
        .ry(-dy)
        .rarc(-r, 0, -r, -r)
        .rx(-dx)
        .rarc(0, r, -r, r);
    }

    po.z(o)
      .abs(0, 0);
  }
}
