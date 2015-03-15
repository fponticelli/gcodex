package gcx;

using thx.core.Arrays;
using thx.core.Strings;

abstract Command(CommandType) from CommandType to CommandType {
  @:to public function toString() : String
    return (switch this {
      case CircularInterpolation(a): 'G02 ${addressesToString(a)}';
      case CircularInterpolationCCW(a): 'G03 ${addressesToString(a)}';
      case Dwell(a): 'G04 ${addressesToString(a)}';
      case UnitMM: "G21";
      case UnitInch: "G20";
      case RelativePositioning: "G91";
      case AbsolutePositioning: "G90";
      case RapidPositioning(a): 'G00 ${addressesToString(a)}';
      case LinearInterpolation(a): 'G01 ${addressesToString(a)}';
    }).rtrim();

  static function addressesToString(a : Array<Address>)
    return a.pluck(_.toString()).join(" ");
}