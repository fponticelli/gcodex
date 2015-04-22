import gcx.Pointer;
using thx.Floats;

class Clamp {
  public static function build(po : Pointer) {
		var m = 5,
        w = 24,
        sx = m + w / 2,
        sy = m + w / 2,
        o = 5,
        materialHeight = 25.4 / 4,
        passes = 3,
        cutDepth = -(materialHeight / passes * 1.1).ceilTo(2),
        emD = 25.4 / 8,
        emR = emD / 2,
        holeD = 8.0,
        holeR = holeD / 2,
        cutOff = 15,
        length = 150,
        mo = o - emR,
        holes = 4,
        cutL = (length - cutOff * (holes - 1)) / holes;

    // go to first hole
    po.z(o)
      .abs(sx, sy);

    // make n holes
    for(i in 0...holes) {
      // mill big cut
      po.y(sy + (cutOff + cutL) * i)
        .z(0)
        .mill(1200);
      for(_ in 1...passes+1) {
        po.rz(cutDepth)
          .yHole(emD, holeD, cutL);
      }
      po.travel()
        .z(o);
    }


    // cut profile
    var pw = w / 2 + emR,
        px = sx - pw;
    po.abs(px, sy)
      .z(0)
      .mill();
    for(_ in 1...passes+1) {
      po.rz(cutDepth)
        .ry(length)
        .rarc(pw, 0, pw * 2, 0)
        .ry(-length)
        .rarc(-pw, 0, -pw * 2, 0);
    }
    po.travel()
      .z(o);
  }
}
