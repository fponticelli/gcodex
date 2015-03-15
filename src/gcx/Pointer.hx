package gcx;

import thx.geom.d3.Point;
import gcx.AddressType;

class Pointer {
  var d : GCodeDriver;
  var mode : Mode;
  var position : Point;
  public function new(driver : GCodeDriver) {
    this.d = driver;
    mode = Travel;
    position = Point.create(0,0,0);
  }

  public function x(v : Float)
    return abs(v, null, null);

  public function rx(v : Float)
    return rel(v, null, null);

  public function y(v : Float)
    return abs(null, v, null);

  public function ry(v : Float)
    return rel(null, v, null);

  public function z(v : Float)
    return abs(null, null, v);

  public function rz(v : Float)
    return rel(null, null, v);

  public function rel(?x : Float, ?y : Float, ?z : Float)
    return abs(
        null == x ? null : x + position.x,
        null == y ? null : y + position.y,
        null == z ? null : z + position.z
      );

  public function abs(?x : Float, ?y : Float, ?z : Float) {
    var l = [];
    if(null != x && x != position.x) {
      l.push(X(x));
      position.x = x;
    }
    if(null != y && y != position.y) {
      l.push(Y(y));
      position.y = y;
    }
    if(null != z && z != position.z) {
      l.push(Z(z));
      position.z = z;
    }
    switch mode {
      case Travel: d.position(l);
      case Mill: d.linear(l);
    }
    return this;
  }

  public function travel() {
    mode = Travel;
    return this;
  }

  public function mill() {
    mode = Mill;
    return this;
  }
}

enum Mode {
  Travel;
  Mill;
}