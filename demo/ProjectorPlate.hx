import gcx.Pointer;
using thx.Floats;

class ProjectorPlate {
  public static function build(po : Pointer) {
    var w = 160,
        h = 120,
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
        d1 = 3.3,
        d2 = 5.3;

    // holes
    var pos = [[0.0, 0.0], [55, 81.5], [55 - 110.05, 81.5]]
			.map(function(xy) return [xy[0] + w / 2, xy[1] + h / 2 - 81.5 / 2, d1])
			.concat([
	      [10.0,40.0, d2], [30.0,40.0, d2], [50.0,40.0, d2], [70.0,40.0, d2], [90.0,40.0, d2], [110.0,40.0, d2], [130.0,40.0, d2], [150.0,40.0, d2],
	      [10.0,60.0, d2], [30.0,60.0, d2], [50.0,60.0, d2], [70.0,60.0, d2], [90.0,60.0, d2], [110.0,60.0, d2], [130.0,60.0, d2], [150.0,60.0, d2],
				[10.0,80.0, d2], [30.0,80.0, d2], [50.0,80.0, d2], [70.0,80.0, d2], [90.0,80.0, d2], [110.0,80.0, d2], [130.0,80.0, d2], [150.0,80.0, d2],
	    ]);
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
