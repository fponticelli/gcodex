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

  public function arc(center : Array<Null<Float>>, endPoint : Array<Null<Float>>) {
    var l = [];
    if(null != endPoint[0])
      l.push(X(endPoint[0]));
    if(null != endPoint[1])
      l.push(Y(endPoint[1]));
    if(null != endPoint[2])
      l.push(Z(endPoint[2]));
    if(null != center[0])
      l.push(I(center[0]));
    if(null != center[1])
      l.push(J(center[1]));
    if(null != center[2])
      l.push(K(center[2]));
    commands.push(CircularInterpolation(l));
  }

  public function arcCCW(center : Array<Null<Float>>, endPoint : Array<Null<Float>>) {
    var l = [];
    if(null != endPoint[0])
      l.push(X(endPoint[0]));
    if(null != endPoint[1])
      l.push(Y(endPoint[1]));
    if(null != endPoint[2])
      l.push(Z(endPoint[2]));
    if(null != center[0])
      l.push(I(center[0]));
    if(null != center[1])
      l.push(J(center[1]));
    if(null != center[2])
      l.push(K(center[2]));
    commands.push(CircularInterpolationCCW(l));
  }

  public function wait(millis : Float)
    commands.push(Dwell([P(millis)]));

  public function toString()
    return commands.pluck(_.toString()).join("\n");
}