package gcx;

using thx.Arrays;
using thx.Functions;
import gcx.CommandType;
import gcx.AddressType;

class GCodeDriver {
  public var commands : Array<Command>;
  public function new(?absolute = true, ?mm = true) {
    commands = [
      mm ? UnitMM : UnitInch,
      absolute ? AbsolutePositioning : RelativePositioning
    ];
  }

  public function position(a : Array<Address>)
    commands.push(RapidPositioning(a));

  public function linear(a : Array<Address>)
    commands.push(LinearInterpolation(a));

  public function arc(a : Array<Address>)
    commands.push(CircularInterpolation(a));

  public function arcCCW(a : Array<Address>)
    commands.push(CircularInterpolationCCW(a));

  public function wait(millis : Float)
    commands.push(Dwell([P(millis)]));

  public function toString()
    return commands.map.fn(_.toString()).join("\n") + "\n";
}
