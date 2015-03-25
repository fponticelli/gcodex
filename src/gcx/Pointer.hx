package gcx;

import thx.geom.d3.Point;
import gcx.AddressType;
import thx.geom.Matrix44;
import gcx.Mode;

class Pointer {
  var mode : Mode;
  var d : GCodeDriver;
  var position : Point;
  var feedRate : Float;
  var travelRate : Float;
  public var matrix : Matrix44;
  public function new(driver : GCodeDriver) {
    this.d = driver;
    mode = Travel;
    position = Point.create(0,0,0);
    matrix = Matrix44.identity;
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
    var np = Point.create(
        null == x ? position.x : x,
        null == y ? position.y : y,
        null == z ? position.z : z
      );

    var p = np.transform(matrix),
        l = [];

    if(null != x && np.x != position.x)
      l.push(X(p.x));
    if(null != y && np.y != position.y)
      l.push(Y(p.y));
    if(null != z && np.z != position.z)
      l.push(Z(p.z));

    position.set(p.x, p.y, p.z);

    if(l.length == 0)
      return this;

    switch mode {
      case Travel: d.position(l);
      case Mill: d.linear(l);
    }

    return this;
  }

  public function rcircle(rcx : Float, rcy : Float)
    return rarc(rcx, rcy, 0, 0);

  public function circle(cx : Float, cy : Float)
    return arc(cx, cy, position.x, position.y);

  public function rcircleCCW(rcx : Float, rcy : Float)
    return rarcCCW(rcx, rcy, 0, 0);

  public function circleCCW(cx : Float, cy : Float)
    return arcCCW(cx, cy, position.x, position.y);
/*
var r = cx - position.x;
arc(cx, cy, cx, cy + r);
arc(cx, cy, cx + r, cy);
arc(cx, cy, cx, cy - r);
arc(cx, cy, cx - r, cy);
 */

  public function rarc(rcx : Float, rcy : Float, rex : Float, rey : Float)
    return arc(position.x + rcx, position.y + rcy, position.x + rex, position.y + rey);

  public function arc(cx : Float, cy : Float, ex : Float, ey : Float) {
    var cp = Point.create(cx, cy, position.z).transform(matrix),
        sp = position.transform(matrix);
    position.x = ex;
    position.y = ey;
    var ep = position.transform(matrix);
    d.arc([X(ep.x), Y(ep.y), I(cp.x - sp.x), J(cp.y - sp.y)]);
    return this;
  }

  public function rarcCCW(rcx : Float, rcy : Float, rex : Float, rey : Float)
    return arcCCW(position.x + rcx, position.y + rcy, position.x + rex, position.y + rey);

  public function arcCCW(cx : Float, cy : Float, ex : Float, ey : Float) {
    var cp = Point.create(cx, cy, position.z).transform(matrix),
        sp = position.transform(matrix);
    position.x = ex;
    position.y = ey;
    var ep = position.transform(matrix);
    d.arcCCW([X(ep.x), Y(ep.y), I(cp.x - sp.x), J(cp.y - sp.y)]);
    return this;
  }

  public function hole(toolDiameter : Float, holeDiameter : Float, ?repeats = 1, ?overlap = 0.1) {
    var toolRadius = toolDiameter / 2,
        holeRadius = holeDiameter / 2,
        step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeRadius - toolRadius;

    var counter = 0;
    function circle(cx, cy) {
      if(counter ++ % 2 == 0)
        this.circle(cx, cy);
      else
        this.circleCCW(cx, cy);
    }

    if(rad <= 0)
      return this;
    var lr = [];
    while(dist < rad) {
      lr.push(dist);
      dist += step;
    };

    var center = position.clone();
    var p = 0.0;
    mill();
    for(r in lr) {
      rx(-r + p);
      circle(center.x, center.y);
      p = r;
    }
    rx(-rad + p);
    if(repeats < 1)
      repeats = 1;
    for(_ in 0...repeats) {
      circle(center.x, center.y);
    }
    travel();
    abs(center.x, center.y);
    mill();
    return this;
  }

  public function yHole(toolDiameter : Float, holeDiameter : Float, length : Float, ?overlap = 0.1) {
    var toolRadius = toolDiameter / 2,
        holeRadius = holeDiameter / 2,
        step = toolDiameter * (1 - overlap),
        dist = step,
        rad  = holeRadius - toolRadius;
    ry(length);
    travel();
    ry(-length);
    mill();
    if(rad <= 0)
      return this;
    var lr = [];
    while(dist < rad) {
      lr.push(dist);
      dist += step;
    };
    lr.push(rad);

    var center = position.clone();
    var p = 0.0;
    mill();
    for(r in lr) {
      rx(-r + p);
      ry(length);
      rarc(r, 0, r * 2, 0);
      ry(-length);
      rarc(-r, 0, -r * 2, 0);

      p = r;
    }
    travel();
    abs(center.x, center.y);
    mill();
    return this;
  }

  public function travel(?travelRate : Float) {
    if(null != travelRate && travelRate != this.travelRate)
      d.position([F(this.travelRate = travelRate)]);
    mode = Travel;
    return this;
  }

  public function mill(?feedRate : Float) {
    if(null != feedRate && feedRate != this.feedRate)
      d.linear([F(this.feedRate = feedRate)]);
    mode = Mill;
    return this;
  }
}
