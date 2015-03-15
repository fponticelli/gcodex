import gcx.GCodeDriver;
import gcx.AddressType;

class Main {
  static function main() {
    var d = new GCodeDriver();

    var emD = 25.4 / 8,
        emR = emD / 2,
        cutDepth = 2.3;

    d.position([Z(-5)]);
    d.position([X(22), Y(22)]);
    d.linear([Z(cutDepth)]);

    trace(d.toString());
  }
}