package gcx;

using thx.core.Arrays;
import gcx.CommandType;

class GCodeDriver {
  public var commands : Array<Command>;
  public function new() {
    commands = [];
  }

  public function position(a : Array<Address>)
    commands.push(RapidPositioning(a));

  public function linear(a : Array<Address>)
    commands.push(LinearInterpolation(a));

  public function toString()
    return commands.pluck(_.toString()).join("\n");
}