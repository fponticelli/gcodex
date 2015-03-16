import gcx.GCodeDriver;
import gcx.AddressType;
import gcx.Pointer;
using gcx.GCodes;
using thx.core.Floats;

class Main {
  static function main() {
    var d = new GCodeDriver(),
        po = new Pointer(d);

    var m = 10,
        w = 24,
        sx = m + w / 2,
        sy = m + w / 2,
        o = 5,
        materialHeight = 25.4 / 4,
        passes = 3,
        cutDepth = -(materialHeight / passes).ceilTo(2),
        emD = 25.4 / 8,
        emR = emD / 2,
        holeD = 7,
        holeR = holeD / 2,
        cutOff = 19,
        cutL = 100,
        mo = o - emR;

    // go to first hole
    po.z(o)
      .abs(sx, sy);

    // mill hole
    po.z(0)
      .mill();
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
    po.abs(sx-w/2, sy)
      .z(0)
      .mill();
    for(_ in 1...passes+1) {
      po.rz(cutDepth)
        .ry(cutL + cutOff)
        .rarc(w / 2, 0, w, 0)
        .ry(-cutL - cutOff)
        .rarc(-w / 2, 0, -w, 0);
    }
    po.travel()
      .z(o);
/*
    var r = width / 2 + emR,
        l = holeL + holeS;
    d.position([RX(-r), RY(-holeS)]);
    d.position([RZ(-5)]);
      d.linear([RZ(-cutDepth)]);
      d.linear([RY(l)]);
      d.arc([RX(r*2), RY(0), I(r), J(0)]);
      d.linear([RY(-l)]);
      d.arc([RX(-r*2), RY(0), I(-r), J(0)]);
    }
    d.position([RZ(5 + cutDepth * passes)]);
*/

    trace(d.toString());
  }
}