package gcx;

enum CommandType {
  UnitInch;
  UnitMM;
  RelativePositioning;
  AbsolutePositioning;
  RapidPositioning(a : Array<Address>);
  LinearInterpolation(a : Array<Address>);
  Dwell(a : Array<Address>);
  CircularInterpolation(a : Array<Address>);
  CircularInterpolationCCW(a : Array<Address>);
}