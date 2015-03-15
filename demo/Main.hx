import gcx.GCodeDriver;
import gcx.AddressType;
using gcx.GCodes;

class Main {
  static function main() {
    var d = new GCodeDriver();

    var emD = 25.4 / 8,
        emR = emD / 2,
        holeD = 7,
        holeR = holeD / 2,
        cutDepth = 2.3;

    // go to first hole
    d.position([Z(5)]);
    d.position([X(22), Y(22)]);

    // drill hole
    for(step in 1...4) {
      d.linear([Z(-5 - cutDepth * step)]);
      d.hole(emD, holeD);
      d.position([Z(5 + cutDepth * step)]);
    }



    trace(d.toString());
  }
}