package gcx;

enum CommandType {
  RapidPositioning(a : Array<Address>);
  LinearInterpolation(a : Array<Address>);
}