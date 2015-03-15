import gcx.GCodeDriver;
import gcx.AddressType;
import gcx.Pointer;
using gcx.GCodes;

class Main {
  static function main() {
    var d = new GCodeDriver(),
        p = new Pointer(d);

    var emD = 25.4 / 8,
        emR = emD / 2,
        holeD = 7,
        holeR = holeD / 2,
        holeL = 100,
        holeS = 19,
        cutDepth = 2.3,
        width = 24,
        passes = 3;

    var m = 10,
        w = 24,
        sx = m + w / 2,
        sy = m + w / 2,
        o = 5;

    p.z(o)
      .abs(sx, sy);
/*
    // go to first hole
    d.position([RZ(5)]);
    d.position([RX(22), RY(22)]);

    // drill hole
    d.position([RZ(-5)]);
    for(step in 1...passes+1) {
      d.linear([RZ(-cutDepth)]);
      d.hole(emD, holeD);
    }
    d.position([RZ(5 + cutDepth * passes)]);

    // drill big cut
    d.position([RY(holeS)]);
    d.position([RZ(-5)]);
    for(step in 1...passes+1) {
      d.linear([RZ(-cutDepth)]);
      d.yHole(emD, holeD, holeL);
    }
    d.position([RZ(5 + cutDepth * passes)]);

    // cut profile
    var r = width / 2 + emR,
        l = holeL + holeS;
    d.position([RX(-r), RY(-holeS)]);
    d.position([RZ(-5)]);
    for(step in 1...passes+1) {
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