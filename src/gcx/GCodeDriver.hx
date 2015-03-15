package gcx;

using thx.core.Arrays;
import gcx.CommandType;
import gcx.AddressType;

class GCodeDriver {
  public var commands : Array<Command>;
  public function new(?relative = true, ?mm = true) {
    commands = [
      mm ? UnitMM : UnitInch,
      relative ? RelativePositioning : AbsolutePositioning
    ];
  }

  public function position(a : Array<Address>)
    commands.push(RapidPositioning(a));

  public function linear(a : Array<Address>)
    commands.push(LinearInterpolation(a));

  public function wait(millis : Float)
    commands.push(Dwell([P(millis)]));

  public function toString()
    return commands.pluck(_.toString()).join("\n");
}