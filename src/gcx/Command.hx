package gcx;

using thx.core.Arrays;
using thx.core.Strings;

abstract Command(CommandType) from CommandType to CommandType {
  @:to public function toString() : String
    return (switch this {
      case RapidPositioning(a): 'G00 ${addressesToString(a)}';
      case LinearInterpolation(a): 'G01 ${addressesToString(a)}';
    }).rtrim();

  static function addressesToString(a : Array<Address>)
    return a.pluck(_.toString()).join(" ");
}

enum CommandType {
  RapidPositioning(a : Array<Address>);
  LinearInterpolation(a : Array<Address>);
}