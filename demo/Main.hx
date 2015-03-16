import gcx.GCodeDriver;
import gcx.Pointer;
using thx.core.Floats;

class Main {
  static function main() {
    var d = new GCodeDriver(),
        po = new Pointer(d);

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
        cutOff = 19,
        cutL = 100,
        mo = o - emR;

    // go to first hole
    po.z(o)
      .abs(sx, sy);

    // mill hole
    po.z(0)
      .mill(600);
    for(_ in 1...passes+1) {
      po.rz(cutDepth)
        .hole(emD, holeD);
    }
    po.travel()
      .z(o);

    // mill big cut
    po.y(sy + cutOff)
      .z(0)
      .mill();
    for(_ in 1...passes+1) {
      po.rz(cutDepth)
        .yHole(emD, holeD, cutL);
    }
    po.travel()
      .z(o);

    // cut profile
    var pw = w / 2 + emR,
        px = sx - pw;
    po.abs(px, sy)
      .z(0)
      .mill();
    for(_ in 1...passes+1) {
      po.rz(cutDepth)
        .ry(cutL + cutOff)
        .rarc(pw, 0, pw * 2, 0)
        .ry(-cutL - cutOff)
        .rarc(-pw, 0, -pw * 2, 0);
    }
    po.travel()
      .z(o);

    trace(d.toString());
  }
}