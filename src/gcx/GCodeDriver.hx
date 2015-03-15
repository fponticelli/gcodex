package gcx;

using thx.core.Arrays;

class GCodeDriver {
  public var commands : Array<Command>;
  public function new() {
    commands = [];
  }

  public function toString()
    return commands.pluck(_.toString()).join("\n");
}